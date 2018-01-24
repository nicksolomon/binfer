#' Title
#'
#' @param x The output of \code{assume()}
#' @param ... Parameters to be passed to \code{mcmc::metrop()}.
#'
#' @return A dataframe of draws from the posterior distribution.
#' @export
#'

simulate_posterior <- function(x, ...) {

  attr_names <- names(attributes(x))

  if (!("likelihood" %in% attr_names &&
        "response" %in% attr_names &&
        "prior" %in% attr_names)){
    stop("Missing likelihood, response, or prior. Did you follow all the steps?")
  }

  single_lik <- match.fun(attr(x, "likelihood"))
  prior <- match.fun(attr(x, "prior"))
  response <- attr(x, "response")

  log_dens <- function(theta) {sum(log(single_lik(x[[response]], theta))) + log(prior(theta))}

  chain <- mcmc::metrop(log_dens, ...)

  out <- data.frame(chain = chain$batch)
  class(out) <- c("binfer.posterior", class(x))

  out
}
