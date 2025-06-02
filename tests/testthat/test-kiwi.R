library(elbird)

test_that("kiwi works with model_size = small", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  res <- NULL
  err <- NULL
  tryCatch({
    kw <- Kiwi$new(model_size = "small")
    res <- kw$analyze("테스트 문장입니다.")
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message)) {
      skip("Skipping test: Model file for 'small' (v0.21.0) not found at expected URL.")
    } else {
      fail(paste0("Test failed with an unexpected error: ", err$message)) # Fail for other errors
    }
  } else { # Proceed with assertions only if there was no error
    expect_equal(class(kw), c("Kiwi","R6"))
    expect_true(is.list(res))
    expect_true(length(res) > 0)
  }
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

  res <- NULL
  err <- NULL
  tryCatch({
    kw <- Kiwi$new(model_size = "large")
    res <- kw$analyze("테스트 문장입니다.")
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message)) {
      skip("Skipping test: Model file for 'large' (v0.21.0) not found at expected URL.")
    } else {
      fail(paste0("Test failed with an unexpected error: ", err$message)) # Fail for other errors
    }
  } else { # Proceed with assertions only if there was no error
    expect_equal(class(kw), c("Kiwi","R6"))
    expect_true(is.list(res))
    expect_true(length(res) > 0)
  }
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

  res <- NULL
  err <- NULL
  tryCatch({
    kw <- Kiwi$new(model_size = "CoNg-large")
    res <- kw$analyze("테스트 문장입니다.")
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message)) {
      skip("Skipping test: Model file for 'CoNg-large' (v0.21.0) not found at expected URL.")
    } else {
      fail(paste0("Test failed with an unexpected error: ", err$message)) # Fail for other errors
    }
  } else { # Proceed with assertions only if there was no error
    expect_equal(class(kw), c("Kiwi","R6"))
    expect_true(is.list(res))
    expect_true(length(res) > 0)
  }
})
