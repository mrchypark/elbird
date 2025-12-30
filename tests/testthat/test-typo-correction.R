
test_that("typo correction works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  if (!model_works("base")) {
    get_model("base")
  }

  # Test basic typo correction
  kw <- Kiwi$new(model_size = "base")
  expect_equal(class(kw), c("Kiwi", "R6"))

  # Test analysis with typo correction enabled
  result_with_typo <- kw$analyze("안뇽하세요", typos = TRUE)
  result_without_typo <- kw$analyze("안뇽하세요", typos = FALSE)

  expect_true(length(result_with_typo) > 0)
  expect_true(length(result_without_typo) > 0)
  expect_true(is.list(result_with_typo))
  expect_true(is.list(result_without_typo))
})

test_that("typo correction with custom settings works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  if (!model_works("base")) {
    get_model("base")
  }

  # Test with different typo correction levels
  kw <- Kiwi$new(model_size = "base")

  # Test with typo_cost_threshold parameter
  result1 <- kw$analyze("안뇽하세요", typos = TRUE, typo_cost_threshold = 2.5)
  result2 <- kw$analyze("안뇽하세요", typos = TRUE, typo_cost_threshold = 5.0)

  expect_true(length(result1) > 0)
  expect_true(length(result2) > 0)
  expect_true(is.list(result1))
  expect_true(is.list(result2))
})
