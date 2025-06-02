library(elbird)

test_that("kiwi works with model_size = small", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  
  err <- NULL
  kw <- NULL
  res <- NULL
  model_successfully_acquired_and_analyzed <- FALSE

  tryCatch({
    # Kiwi$new will attempt to download the model if not present.
    kw <- Kiwi$new(model_size = "small") 
    res <- kw$analyze("테스트 문장입니다.")
    model_successfully_acquired_and_analyzed <- TRUE
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message)) { # Simplified condition
      skip(paste0("Skipping test: Model file for 'small' (v0.21.0) not found. Error: ", err$message))
    } else {
      fail(paste0("Test for 'small' model failed during setup or analysis with an unexpected error: ", err$message))
    }
    return() # Ensure exit after skip or fail
  }
  
  # This part should only be reached if err is NULL
  expect_true(model_successfully_acquired_and_analyzed, "Model 'small' acquisition and analysis flag should be TRUE if no error.")
  expect_false(is.null(kw), "Kiwi object 'kw' for 'small' model should have been created.")
  expect_equal(class(kw), c("Kiwi","R6"))
  expect_true(is.list(res), "Result of analyze should be a list.")
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
  
  res <- NULL
  err <- NULL
  kw <- NULL 
  model_successfully_acquired_and_analyzed <- FALSE
  tryCatch({
    kw <- Kiwi$new(model_size = "large") 
    res <- kw$analyze("테스트 문장입니다.")
    model_successfully_acquired_and_analyzed <- TRUE
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message)) { # Simplified condition
      skip(paste0("Skipping test: Model file for 'large' (v0.21.0) not found. Error: ", err$message))
    } else {
      fail(paste0("Test for 'large' model failed during setup or analysis with an unexpected error: ", err$message))
    }
    return() # Ensure exit after skip or fail
  }
  
  expect_true(model_successfully_acquired_and_analyzed, "Model 'large' acquisition and analysis flag should be TRUE if no error.")
  expect_false(is.null(kw), "Kiwi object 'kw' for 'large' model should have been created.")
  expect_equal(class(kw), c("Kiwi","R6"))
  expect_true(is.list(res), "Result of analyze should be a list.")
  expect_true(length(res) > 0)
})

test_that("kiwi works with model_size = CoNg-base", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  # This test does not use tryCatch for 404, as CoNg-base model with specific filename is expected to exist or fail differently.
  # It will fail if the model v0.21.0 cong_base is not downloadable or if analysis fails.
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
  kw <- NULL 
  model_successfully_acquired_and_analyzed <- FALSE
  tryCatch({
    kw <- Kiwi$new(model_size = "CoNg-large") 
    res <- kw$analyze("테스트 문장입니다.")
    model_successfully_acquired_and_analyzed <- TRUE
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message)) { # Simplified condition
      skip(paste0("Skipping test: Model file for 'CoNg-large' (v0.21.0) not found. Error: ", err$message))
    } else {
      fail(paste0("Test for 'CoNg-large' model failed during setup or analysis with an unexpected error: ", err$message))
    }
    return() # Ensure exit after skip or fail
  }
  
  expect_true(model_successfully_acquired_and_analyzed, "Model 'CoNg-large' acquisition and analysis flag should be TRUE if no error.")
  expect_false(is.null(kw), "Kiwi object 'kw' for 'CoNg-large' model should have been created.")
  expect_equal(class(kw), c("Kiwi","R6"))
  expect_true(is.list(res), "Result of analyze should be a list.")
  expect_true(length(res) > 0)
})
