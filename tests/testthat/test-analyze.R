test_that("analyze works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  err <- NULL
  res_analyze <- NULL
  tryCatch({
    # This test implicitly uses the default model (small, if not specified otherwise or if base is not found first)
    if (!model_exists("small")) {
      get_model("small")
    }
    res_analyze <- analyze("Test text.")
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message)) {
      skip("Skipping test: Default model (likely 'small' v0.21.0) not found at expected URL.")
    } else {
      fail(paste0("Test prerequisites failed with an unexpected error: ", err$message))
    }
    return() # Stop if there was an error during model acquisition
  }

  # If err is NULL, proceed based on model existence and analysis result
  if (model_exists("small")) {
    if (!is.null(res_analyze)) { # Proceed only if analysis was successful
      expect_equal(length(res_analyze), 3)
    } else {
      # Model exists, but analysis result is null (and no error was caught by tryCatch)
      fail("Analysis did not produce a result, even though 'small' model exists and no download error was caught.")
    }
  } else { # Model does not exist, and get_model() didn't error (or wasn't called if model_exists was initially true)
    skip("Skipping test execution because 'small' model is not available.")
  }
})
