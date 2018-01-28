library(binfer)
data("taxis")
my_lik <- function(data, theta) {if (theta > 0) dpois(data, lambda = theta) else 0}
my_prior <- function(theta) {dgamma(theta, rate = 10, shape = 10)}

to_assume <- define(taxis, passenger_count ~ my_lik)

context("Testing `assume()`")

test_that("Data isn't changed",{
  expect_true(all(to_assume == assume(to_assume, ~ my_prior)))
})

test_that("Prior is added as an attribut",{
  expect_match(attr(assume(to_assume, ~ my_prior), "prior"), "my_prior")
})

test_that("Uknown prior throws an error", {
  expect_error(assume(to_assume, ~my_prior2))
})

test_that("Output has class `binfer`", {
  expect_true("binfer" %in% class(assume(to_assume, ~ my_prior)))
})
