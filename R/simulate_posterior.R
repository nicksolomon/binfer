#' Title
#'
#' @param x The output of \code{assume()}
#' @param ... Parameters to be passed to \code{mcmc::metrop()}.
#'
#' @return A dataframe of draws from the posterior distribution.
#' @export
#'

simulate_posterior <- function(x, ...) {
  single_lik <- match.fun(attr(x, "likelihood"))
  prior <- match.fun(attr(x, "prior"))
  response <- attr(x, "response")

  dens <- function(theta) {log(prod(single_lik(x[[response]], theta) * prior(theta)))}

  chain <- mcmc::metrop(dens, ...)

  data.frame(chain = chain$batch)
}
