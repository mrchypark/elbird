test_that("kiwi works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  kw <- Kiwi$new(model_size = "base")
  expect_equal(class(kw), c("Kiwi","R6"))
})
