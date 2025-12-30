
test_that("analyze works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  err <- NULL
  model_successfully_acquired <- FALSE
  res_analyze <- NULL

  tryCatch({
    if (!model_exists("base")) {
      get_model("base")
    }
    model_successfully_acquired <- model_exists("base")

    if(model_successfully_acquired){
      res_analyze <- analyze("Test text.")
    }
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message)) {
      skip(paste0("Skipping test: Model file for 'base' (v0.22.2) not found. Error: ", err$message))
    } else {
      fail(paste0("Test setup for 'analyze' (with base model) failed with an unexpected error: ", err$message))
    }
    return() # Ensure exit after skip or fail
  }

  if (!model_successfully_acquired) {
    skip("Skipping test for 'analyze': 'base' model not available after attempted acquisition.")
    return()
  }

  expect_false(is.null(res_analyze), "res_analyze should not be NULL if setup succeeded for 'analyze' with base model.")
  if(!is.null(res_analyze)) expect_equal(length(res_analyze), 3)
})
