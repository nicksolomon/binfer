library(binfer)
library(dplyr)

data("taxis")
my_lik <- function(data, theta) {if (theta > 0) dpois(data, lambda = theta) else 0}
my_prior <- function(theta) {dgamma(theta, rate = 10, shape = 10)}

set.seed(20180127)

taxis_small <- sample_frac(taxis, .01)

to_simulate <- define(taxis_small, passenger_count ~ my_lik) %>%
  assume(~ my_prior)

set.seed(20180128)
posterior <- simulate_posterior(to_simulate, initial = 1, nbatch = 100, scale = .1)

clean_df <- posterior %>%
  clean(burn = 10, subsample = 10)

context("Testing clean()")

test_that("Cleaned dataframe has the expected number of rows", {
  expect_equal(nrow(clean_df), 9)
})
