# Load packages and data
library(binfer)
library(dplyr)

set.seed(20180127)
data("taxis")
taxis_small <- sample_frac(taxis, .01)

# Create objects to test
to_assume <- define(taxis_small, passenger_count ~ dpois(.data, lambda = .theta))


to_simulate <- to_assume %>%
  assume(~ dgamma(.theta, rate = 10, shape = 10))

# Purposefully introduce NaNs
# to_simulate_error <- rapply(to_simulate, function(x) ifelse(x==6, NaN, x), how = "replace")

to_simulate_bad_prior <- to_assume %>%
  assume(~ dnorm(.theta, mean = -6))

set.seed(20180128)

posterior <- draw(to_simulate, initial = 1, nbatch = 100, scale = .1)

# posterior_bad_prior <- draw(to_simulate_bad_prior, initial = 1, nbatch = 100, scale = .2)


clean_df <- posterior %>%
  clean(burn = 10, subsample = 10)

