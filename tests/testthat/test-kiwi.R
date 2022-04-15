test_that("kiwi works", {
  skip_if_offline()
  kw <- Kiwi$new(model_size = "small")
  expect_equal(class(kw), c("Kiwi","R6"))
})
