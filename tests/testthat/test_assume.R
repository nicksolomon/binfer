

context("Testing `assume()`")

test_that("Data isn't changed",{
  expect_true(all(to_assume == assume(to_assume, ~ my_prior)))
})

test_that("Prior is added as an attribute",{
  expect_match(attr(assume(to_assume, ~ my_prior), "prior"), "my_prior")
})

# test_that("Uknown prior throws an error", {
#   expect_error(assume(to_assume, ~my_prior2))
# })

test_that("Output has class `binfer`", {
  expect_true("binfer" %in% class(assume(to_assume, ~ my_prior)))
})
