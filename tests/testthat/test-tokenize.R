library(elbird) # Adding library call

test_that("tokenize works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  err <- NULL
  model_successfully_acquired <- FALSE
  res_default_stopwords <- NULL
  res_no_stopwords <- NULL

  tryCatch({
    if (!model_exists("base")) {
        get_model("base")
    }
    model_successfully_acquired <- model_exists("base")

    if(model_successfully_acquired){
      # Assuming tokenize() uses a Kiwi instance that would default to "base" model
      res_default_stopwords <- tokenize("Test text.") # Default stopwords = TRUE in function signature
      res_no_stopwords <- tokenize("Test text.", stopwords = FALSE)
    }
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message) && 
        (grepl("base", err$message) || grepl("kiwi_model_v0.21.0_base.tgz", err$message) || grepl("cong_base", err$message) ) ) {
      fail(paste0("Test setup failed: 'base' model (v0.21.0) not found, but was expected. Error: ", err$message))
      return() 
    } else {
      fail(paste0("Test setup for 'tokenize' failed with an unexpected error: ", err$message))
      return() 
    }
  }
  
  if (!model_successfully_acquired) {
      skip("Skipping test for 'tokenize': 'base' model not available after attempted acquisition.")
      return() 
  }

  expect_false(is.null(res_default_stopwords), "res_default_stopwords should not be NULL if setup succeeded.")
  if(!is.null(res_default_stopwords)){
    expect_true(tibble::is_tibble(res_default_stopwords))
    expect_equal(nrow(res_default_stopwords), 2) # Default stopwords remove the period
    expect_equal(ncol(res_default_stopwords), 5)
    expect_true(all(c("sent", "form", "tag", "start", "len") %in% names(res_default_stopwords)))
  }

  expect_false(is.null(res_no_stopwords), "res_no_stopwords should not be NULL if setup succeeded.")
  if(!is.null(res_no_stopwords)){
    expect_true(tibble::is_tibble(res_no_stopwords))
    expect_equal(nrow(res_no_stopwords), 3) # No stopwords, period is a token
    expect_equal(ncol(res_no_stopwords), 5)
    expect_true(all(c("sent", "form", "tag", "start", "len") %in% names(res_no_stopwords)))
  }
})
