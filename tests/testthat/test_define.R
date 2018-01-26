library(binfer)
library(dplyr)
data("taxis")
my_lik <- function(data, theta) {if (theta > 0) dpois(data, lambda = theta) else 0}
my_prior <- function(theta) {dgamma(theta, rate = 10, shape = 10)}

context("Testing `define()`")

test_that("Response column is selected",{
  expect_true(all(define(taxis, passenger_count ~ my_lik) == select(taxis, passenger_count)))
})

test_that("Unknown likelihood throws an error", {
  expect_error(define(taxis, passenger_count ~ unknown_lik))
})

test_that("Unkown column throws an error", {
  expect_error(define(taxis, foo ~ my_lik))
})

test_that("Non-numeric column throws an error", {
  expect_error(define(taxis, rate ~ my_lik))
})

test_that("Attributes are added correctly", {
  expect_match(attr(define(taxis, passenger_count ~ my_lik), "response"), "passenger_count")
  expect_match(attr(define(taxis, passenger_count ~ my_lik), "likelihood"), "my_lik")
})
