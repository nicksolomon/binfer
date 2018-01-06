simulate_posterior <- function(x, ...) {
  single_lik <- match.fun(attr(x, "likelihood"))
  prior <- match.fun(attr(x, "prior"))
  response <- attr(x, "response")

  dens <- function(theta) {log(prod(single_lik(x[[response]], theta) * prior(theta)))}

  chain <- mcmc::metrop(dens, ...)

  data.frame(chain = chain$batch)
}
