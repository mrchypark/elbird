test_that("analyze works", {
  skip_if_offline()
  skip_on_cran()
  res <- analyze("Test text.")
  expect_equal(length(res), 3)
})
