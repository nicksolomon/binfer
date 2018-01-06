mh_sampler <- function(dens,
                       start = 0,
                       nreps = 1000,
                       prop_sd = 1,
                       ...){
  theta <- numeric(nreps)
  theta[1] <- start

  for (i in 2:nreps){
    theta_star <- rnorm(1, mean = theta[i - 1], sd = prop_sd)
    alpha <- dens(theta_star, ...) / dens(theta[i - 1], ...)

    if (!is.nan(alpha) && runif(1) < alpha) theta[i] <- theta_star
    else theta[i] <- theta[i - 1]
  }

  return(theta)
}
