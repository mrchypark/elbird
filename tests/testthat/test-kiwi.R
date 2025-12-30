library(elbird)

test_that("kiwi works with model_size = base", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  err <- NULL
  kw <- NULL
  res <- NULL
  model_successfully_acquired_and_analyzed <- FALSE

  tryCatch({
    kw <- Kiwi$new(model_size = "base")
    res <- kw$analyze("테스트 문장입니다.")
    model_successfully_acquired_and_analyzed <- TRUE
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message)) {
      skip(paste0("Skipping test: Model file for 'base' (v0.22.2) not found. Error: ", err$message))
    } else {
      fail(paste0("Test for 'base' model failed during setup or analysis with an unexpected error: ", err$message))
    }
    return()
  }

  expect_true(model_successfully_acquired_and_analyzed, "Model 'base' acquisition and analysis flag should be TRUE if no error.")
  expect_false(is.null(kw), "Kiwi object 'kw' for 'base' model should have been created.")
  expect_equal(class(kw), c("Kiwi","R6"))
  expect_true(is.list(res), "Result of analyze should be a list.")
  expect_true(length(res) > 0)
})
