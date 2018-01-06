simulate_posterior <- function(x,
                               ...) {
  single_lik <- match.fun(attr(x, "likelihood"))
  prior <- match.fun(attr(x, "prior"))
  response <- attr(x, "response")
  lik <- function(theta) {
    x %>%
      dplyr::mutate(.lik = single_lik(x[[response]], theta)) %>%
      dplyr::pull(.lik) %>%
      prod()
  }

  dens <- function(theta) {lik(theta) * prior(theta)}

  chain <- mh_sampler(dens, ...)
  data.frame(chain = chain)
}
