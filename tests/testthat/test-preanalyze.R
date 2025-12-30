library(elbird)

test_that("pre analyze words df", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  err <- NULL
  model_successfully_acquired <- FALSE
  anl <- NULL
  kb <- NULL
  res_add1 <- NULL
  res_add2 <- NULL
  kw_built <- NULL # Changed from kw to kw_built for clarity
  res_analyze <- NULL

  tryCatch({
    if (!model_exists("base")) {
      get_model("base")
    }
    model_successfully_acquired <- model_exists("base")

    if(model_successfully_acquired){
      anl <- tibble::tibble(
        morphs = c("팅기", "었", "어"),
        pos = c("vv", "ep", "ef"),
        start = c(0L, 1L, 2L),
        end = c(1L, 2L, 3L)
      )
      kb <- elbird:::kiwi_builder_init_(elbird:::kiwi_model_path_full("base"), 0, elbird:::kiwi_default_build_options())
      res_add1 <- elbird:::kiwi_builder_add_pre_analyzed_word_(kb, "팅겼어", anl, 0)
      elbird:::kiwi_builder_add_alias_word_(kb, "팅기","vv", -1, "튕기")
      res_add2 <- elbird:::kiwi_builder_add_pre_analyzed_word_(kb, "팅겼어", anl, 0)
      kw_built <- elbird:::kiwi_builder_build_(kb)
      res_analyze <- elbird:::kiwi_analyze_wrap(kw_built, text = "팅겼어...", 1, Match$ALL_WITH_NORMALIZING)
    }
  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    if (grepl("HTTP status was '404 Not Found'", err$message)) {
      skip(paste0("Skipping test: Model file for 'base' (v0.22.2) not found. Error: ", err$message))
    } else {
      fail(paste0("Test setup for 'preanalyze' (with base model) failed with an unexpected error: ", err$message))
    }
    return() # Ensure exit after skip or fail
  }

  if (!model_successfully_acquired) {
    skip("Skipping test for 'preanalyze': 'base' model not available after attempted acquisition.")
    return()
  }

  # Assertions
  expect_equal(res_add1, 0)
  expect_equal(res_add2, -1)
  expect_false(is.null(res_analyze), "res_analyze should not be NULL if setup succeeded for 'preanalyze'.")
  if(!is.null(res_analyze)) {
    expect_equal(res_analyze[[1]]$Token[[1]]$form, "팅기")
    expect_equal(res_analyze[[1]]$Token[[1]]$tag, "VV")
  }
})
