library(elbird)

test_that("split sents works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  err <- NULL
  model_successfully_acquired <- FALSE
  res_sents1 <- NULL
  res_sents2 <- NULL

  tryCatch({
    if (!model_exists("base")) {
      get_model("base")
    }
    model_successfully_acquired <- model_exists("base")

    if(model_successfully_acquired){
      res_sents1 <- split_into_sents("안녕하세요 박박사입니다 다시 한번 인사드립니다")
      res_sents2 <- split_into_sents("안녕하세요 박박사입니다 다시 한번 인사드립니다", return_tokens = TRUE)
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
      fail(paste0("Test setup for 'splitsents' failed with an unexpected error: ", err$message))
      return() # Ensure exit after fail
    }
  }

  if (!model_successfully_acquired) {
      skip("Skipping test for 'splitsents': 'base' model not available after attempted acquisition.")
      return()
  }

  expect_false(is.null(res_sents1), "res_sents1 should not be NULL if setup succeeded.")
  expect_false(is.null(res_sents2), "res_sents2 should not be NULL if setup succeeded.")
  if(!is.null(res_sents1) && !is.null(res_sents2)){
    expect_equal(length(res_sents1), 2)
    expect_equal(res_sents1[[1]]$tokens, list())
    expect_equal(res_sents1[[2]]$tokens, list())
    expect_equal(length(res_sents2[[1]]$tokens), 5)
    expect_equal(length(res_sents2[[2]]$tokens), 5)
  }
})
