context("Testing `diagnose()`")

test_that("Posterior is unchanged", {
  expect_equal(diagnose(posterior), posterior)
})

test_that("Acceptance rate is output", {
  expect_message(diagnose(posterior), regexp = "Acceptance rate: 0\\.686868686868687")
})

p <- ggplot2::last_plot()
test_that("Diagnostic plots are correct", {
  vdiffr::expect_doppelganger("Diagnostic plots", p)
})
