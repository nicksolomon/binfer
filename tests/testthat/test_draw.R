library(binfer)
library(dplyr)


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

test_that("Error isn't thrown when parameter proposals are invalid", {
  expect_error(draw(to_simulate_bad_prior, initial = 1, nbatch = 100, scale = .2), NA)
})
