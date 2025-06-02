library(elbird)

test_that("tokenize stopword works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  err <- NULL
  model_successfully_acquired <- FALSE
  res_false <- NULL
  res_true <- NULL

  tryCatch({
    if (!model_exists("base")) {
        get_model("base")
    }
    model_successfully_acquired <- model_exists("base")

    if(model_successfully_acquired){
      res_false <- tokenize("Test text.", stopwords = FALSE)
      res_true <- tokenize("Test text.", stopwords = TRUE)
    }
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message) &&
        (grepl("base", err$message) || grepl("kiwi_model_v0.21.0_base.tgz", err$message) || grepl("cong_base", err$message) ) ) {
      fail(paste0("Test setup failed: 'base' model (v0.21.0) not found, but was expected. Error: ", err$message))
      return() # Ensure exit after fail
    } else {
      fail(paste0("Test setup for 'stopwords' failed with an unexpected error: ", err$message))
      return() # Ensure exit after fail
    }
  }

  if (!model_successfully_acquired) {
      skip("Skipping test for 'stopwords': 'base' model not available after attempted acquisition.")
      return()
  }

  expect_false(is.null(res_false), "res_false should not be NULL if setup succeeded.")
  expect_false(is.null(res_true), "res_true should not be NULL if setup succeeded.")
  if(!is.null(res_false) && !is.null(res_true)){
    expect_equal(nrow(res_false), 3)
    expect_true(res_false[nrow(res_false), "form"] == ".")
    expect_equal(nrow(res_true), 2)
    expect_true(res_true[nrow(res_true), "form"] != ".")
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
