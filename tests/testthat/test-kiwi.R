library(elbird)

test_that("kiwi works with model_size = small", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  kw <- Kiwi$new(model_size = "small")
  expect_equal(class(kw), c("Kiwi","R6"))
  res <- kw$analyze("테스트 문장입니다.")
  expect_true(is.list(res))
  expect_true(length(res) > 0)
})

test_that("kiwi works with model_size = base", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  kw <- Kiwi$new(model_size = "base")
  expect_equal(class(kw), c("Kiwi","R6"))
  res <- kw$analyze("테스트 문장입니다.")
  expect_true(is.list(res))
  expect_true(length(res) > 0)
})

test_that("kiwi works with model_size = large", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  kw <- Kiwi$new(model_size = "large")
  expect_equal(class(kw), c("Kiwi","R6"))
  res <- kw$analyze("테스트 문장입니다.")
  expect_true(is.list(res))
  expect_true(length(res) > 0)
})

test_that("kiwi works with model_size = CoNg-base", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  kw <- Kiwi$new(model_size = "CoNg-base")
  expect_equal(class(kw), c("Kiwi","R6"))
  res <- kw$analyze("테스트 문장입니다.")
  expect_true(is.list(res))
  expect_true(length(res) > 0)
})

test_that("kiwi works with model_size = CoNg-large", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  kw <- Kiwi$new(model_size = "CoNg-large")
  expect_equal(class(kw), c("Kiwi","R6"))
  res <- kw$analyze("테스트 문장입니다.")
  expect_true(is.list(res))
  expect_true(length(res) > 0)
})
