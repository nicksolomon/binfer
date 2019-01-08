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
to_simulate_error <- rapply(to_simulate ,function(x) ifelse(x==6, NaN, x), how = "replace")

set.seed(20180128)

posterior <- draw(to_simulate, initial = 1, nbatch = 100, scale = .1)

posterior_error <- draw(to_simulate_error, initial = 1, nbatch = 100, scale = .2)


clean_df <- posterior %>%
  clean(burn = 10, subsample = 10)

