library(elbird)

test_that("split sents works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  err <- NULL
  res_sents1 <- NULL
  res_sents2 <- NULL

  tryCatch({
    # This test implicitly uses the default model.
    # Ensure "base" model is available as it's the default for Kiwi$new() if no argument is passed,
    # and split_into_sents might initialize Kiwi implicitly.
    # If "base" (v0.21.0) is not found (it should be), this will error and be caught.
    # If another model like "small" was intended as a fallback, that needs explicit handling.
    if (!model_exists("base")) {
      get_model("base")
    }
    # If base model exists, proceed. Otherwise, the error from get_model will be caught.
    res_sents1 <- split_into_sents("안녕하세요 박박사입니다 다시 한번 인사드립니다")
    res_sents2 <- split_into_sents("안녕하세요 박박사입니다 다시 한번 인사드립니다", return_tokens = TRUE)
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message)) {
      skip("Skipping test: Required 'base' model file (v0.21.0) not found at expected URL.")
    } else {
      fail(paste0("Test prerequisites failed with an unexpected error: ", err$message))
    }
    return() # Stop if there was an error during model acquisition
  }

  # If err is NULL, proceed based on model existence and analysis result
  if (model_exists("base")) {
    if (!is.null(res_sents1) && !is.null(res_sents2)) { # Proceed only if calls succeeded
      expect_equal(length(res_sents1), 2)
      expect_equal(res_sents1[[1]]$tokens, list())
      expect_equal(res_sents1[[2]]$tokens, list())
      expect_equal(length(res_sents2[[1]]$tokens), 5)
      expect_equal(length(res_sents2[[2]]$tokens), 5)
    } else {
      fail("split_into_sents calls did not produce results, even though 'base' model exists and no download error was caught.")
    }
  } else { # Model does not exist, and get_model() didn't error
    skip("Skipping test execution because 'base' model is not available.")
  }
})
