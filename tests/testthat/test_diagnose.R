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

context("Testing diagnose()")

test_that("Posterior is unchanged", {
  expect_equal(diagnose(posterior), posterior)
})

test_that("Acceptance rate is output", {
  expect_message(diagnose(posterior), regexp = "Acceptance rate: 0\\.686868686868687")
})

test_that("Diagnostic plots are correct", {
  vdiffr::expect_doppelganger("Diagnostic plots", ggplot2::last_plot())
})
