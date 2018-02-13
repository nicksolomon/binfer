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
posterior <- draw(to_simulate, initial = 1, nbatch = 100, scale = .1)

context("Testing `draw()`")

test_that("Posterior mean is correct",{
  expect_equal(mean(posterior$chain), 1.748938037, 1e-7)
})

test_that("Posterior sd is correct",{
  expect_equal(sd(posterior$chain), 0.2148743676, 1e-7)
})

test_that("Right number of simulations is output", {
  expect_equal(nrow(posterior), 100)
})
