test_that("analyze works", {
  skip_if_offline()
  res <- analyze("Test text.")
  expect_equal(length(res), 3)
})
