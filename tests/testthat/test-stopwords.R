library(elbird)

test_that("tokenize stopword works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  err <- NULL
  res_false <- NULL
  res_true <- NULL

  tryCatch({
    # This test implicitly uses the default model.
    # Ensure "base" model is available.
    if (!model_exists("base")) {
        get_model("base")
    }
    res_false <- tokenize("Test text.", stopwords = FALSE)
    res_true <- tokenize("Test text.", stopwords = TRUE)
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

  if (!model_exists("base")) { # Check if model is actually usable
      skip("Skipping test execution because 'base' model is not available.")
      return()
  }

  if (!is.null(res_false) && !is.null(res_true)) { # Proceed only if calls succeeded
    expect_equal(nrow(res_false), 3)
    expect_true(res_false[nrow(res_false), "form"] == ".")
    expect_equal(nrow(res_true), 2)
    expect_true(res_true[nrow(res_true), "form"] != ".")
  } else {
    fail("tokenize calls did not produce results, even if model download error was not caught (and model exists).")
  }
})

test_that("stopwords works", {
  sw <- Stopwords$new()
  expect_equal(class(sw), c("Stopwords","R6"))
  expect_equal(nrow(sw$get()), 106)
  sw <- Stopwords$new(use_system_dict = F)
  expect_equal(nrow(sw$get()), 0)
  sw$add("dkdh")
  expect_equal(nrow(sw$get()), 1)
})
