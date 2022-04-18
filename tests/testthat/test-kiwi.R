test_that("kiwi works", {
  skip_if_offline()
  skip_on_cran()
  kw <- Kiwi$new(model_size = "small")
  expect_equal(class(kw), c("Kiwi","R6"))
})
