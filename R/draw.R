#' Simulate posterior
#'
#' Simulate the posterior distribution
#'
#' @param x The output of \code{assume()}
#' @param ... Parameters to be passed to \code{mcmc::metrop()}.
#'
#' @return A dataframe of draws from the posterior distribution.
#' @export
#' @importFrom stats as.formula

draw <- function(x, ...) {

  attr_names <- names(attributes(x))

  if (!("likelihood" %in% attr_names &&
        "response" %in% attr_names &&
        "prior" %in% attr_names)){
    stop("Missing likelihood, response, or prior. Did you follow all the steps?")
  }

  single_lik_unsafe <- attr(x, "likelihood") %>%
    sub(".data", "..1" ,. , fixed = TRUE) %>%
    sub(".theta", "..2", ., fixed = TRUE) %>%
    paste("~", .) %>%
    as.formula() %>%
    rlang::as_function()
  single_lik <- really(single_lik_unsafe, otherwise = 0)

  prior_unsafe <- attr(x, "prior") %>%
    sub(".theta", "..1", ., fixed = TRUE) %>%
    paste("~", .) %>%
    as.formula() %>%
    rlang::as_function()
  prior <- really(prior_unsafe, otherwise = 0)

  response <- attr(x, "response")

  log_dens <- function(theta) {
    sum(log(single_lik(x[[response]], theta))) + log(prior(theta))
    }

  chain <- mcmc::metrop(log_dens, ...)

  out <- data.frame(chain = chain$batch)
  class(out) <- c("binfer.posterior", class(x))

  out
}
