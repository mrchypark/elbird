test_that("analyze works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  res <- analyze("Test text.")
  expect_equal(length(res), 3)
})
