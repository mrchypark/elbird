library(elbird)

test_that("add rule works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  err <- NULL
  tryCatch({
    if (!model_exists("small")) { # Check if model exists to avoid re-download
      get_model("small")
    }
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message)) {
      skip("Skipping test: Model file for 'small' (v0.21.0) not found at expected URL.")
    } else {
      fail(paste0("Test prerequisites failed with an unexpected error: ", err$message))
    }
    return() # Stop if there was an error during model acquisition
  }

  # This block was the source of the parse error.
  # The correct logic is to run the test if err is NULL AND model_exists("small") is TRUE.
  # If err is NULL but model_exists("small") is FALSE, then skip.
  if (model_exists("small")) {
    # Proceed only if model is available and no download error occurred
    kw <- kiwi_init_(kiwi_model_path_full("small"), 0, BuildOpt$DEFAULT)
    res1 <- kiwi_analyze_wrap(kw, "했어요! 하잖아요! 할까요?", top_n = 1)
    res2 <- kiwi_analyze_wrap(kw, "했어용! 하잖아용! 할까용?", top_n = 1)

    expect_false(identical(res1[[1]]$Score, res2[[1]]$Score))

    kb <- kiwi_builder_init_(kiwi_model_path_full("small"), 0, BuildOpt$DEFAULT)
    kiwi_builder_add_rule_(kb, "ef", "요$", "용", -2)
    kw <- kiwi_builder_build_(kb)
    res <- kiwi_analyze_wrap(kw, "했어용! 하잖아용! 할까용?")
    expect_false(identical(res1[[1]]$Score, res[[1]]$Score))
  } else {
    # This case handles if get_model() didn't error but model is still not present.
    skip("Skipping test execution because 'small' model could not be obtained.")
  }
})
