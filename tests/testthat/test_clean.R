context("Testing `clean()`")

test_that("Cleaned dataframe has the expected number of rows", {
  expect_equal(nrow(clean_df), 9)
})
