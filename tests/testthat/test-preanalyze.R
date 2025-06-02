library(elbird)

test_that("pre analyze words df", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  err <- NULL
  tryCatch({
    if (!model_exists("small")) { # Use model_exists to avoid re-downloading if already present
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

  # If err is NULL, proceed based on model existence
  if (model_exists("small")) {
    anl <- tibble::tibble(
      morphs = c("팅기", "었", "어"),
      pos = c("vv", "ep", "ef"),
      start = c(0L, 1L, 2L),
      end = c(1L, 2L, 3L)
    )

    kb <- kiwi_builder_init_(kiwi_model_path_full("small"), 0, BuildOpt$DEFAULT)

    res_add1 <- kiwi_builder_add_pre_analyzed_word_(kb, "팅겼어", anl, 0)
    expect_equal(res_add1, -1)

    kiwi_builder_add_alias_word_(kb, "팅기","vv", -1, "튕기")

    res_add2 <- kiwi_builder_add_pre_analyzed_word_(kb, "팅겼어", anl, 0)
    expect_equal(res_add2, 0)
    kw <- kiwi_builder_build_(kb)
    res_analyze <- kiwi_analyze_wrap(kw, text = "팅겼어...", 1, Match$ALL_WITH_NORMALIZING)
    expect_equal(res_analyze[[1]]$Token[[1]]$form, "팅기")
    expect_equal(res_analyze[[1]]$Token[[1]]$tag, "VV")
  } else {
    skip("Skipping test execution because 'small' model could not be obtained.")
  }
})
