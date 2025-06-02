library(elbird)

test_that("add rule works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386") # Keep standard skips

  # Initialize Kiwi builder with 'base' model
  # We need two kiwi instances: one original, one with the rule.

  # Ensure 'base' model is available. The package should handle download on init if not present.
  # We will create Kiwi objects, which internally might call get_model if needed.
  # Using tryCatch around the critical operations.

  err <- NULL
  kw_orig_ptr <- NULL
  kw_with_rule_ptr <- NULL
  res1 <- NULL
  res2_orig <- NULL
  res_with_rule <- NULL

  tryCatch({
    # Create original Kiwi instance
    # Kiwi$new itself will try to get_model("base") if not already available
    # and initialize the builder and build kiwi.
    kw_orig_obj <- Kiwi$new(model_size = "base")
    # Accessing the internal pointer for direct C API calls if needed, though analyze is a R6 method
    # This direct pointer access is more aligned with the original test's use of kiwi_builder_init_ etc.
    # However, for simplicity and R6 best practices, we should use kw_orig_obj$analyze.
    # The original test used kiwi_init_ and kiwi_builder_init_ directly.
    # Let's try to stick to R6 methods first, then adapt if direct C-level handles are truly needed
    # from the testthat context for this specific rule test.

    # For this test, direct builder manipulation is intended to add a rule.
    # So, first, create a base instance to get baseline scores.
    kw_baseline_builder <- kiwi_builder_init_(kiwi_model_path_full("base"), 0, BuildOpt$DEFAULT)
    if(is.null(kw_baseline_builder)) stop("Failed to init baseline kiwi_builder_init_ for base model.")
    kw_orig_ptr <- kiwi_builder_build_(kw_baseline_builder)
    if(is.null(kw_orig_ptr)) stop("Failed to build baseline kiwi_builder_build_ for base model.")

    text1 <- "했어요! 하잖아요! 할까요?"
    res1 <- kiwi_analyze_wrap(kw_orig_ptr, text1, top_n = 1)
    if (is.null(res1) || length(res1) == 0 || !is.list(res1[[1]]$Token) || is.null(res1[[1]]$Score)) {
      stop(paste0("Initial analysis of '", text1, "' with base model returned unexpected result."))
    }

    text2 <- "했어용! 하잖아용! 할까용?" # Text that should be affected by the rule
    res2_orig <- kiwi_analyze_wrap(kw_orig_ptr, text2, top_n = 1)
    if (is.null(res2_orig) || length(res2_orig) == 0 || !is.list(res2_orig[[1]]$Token) || is.null(res2_orig[[1]]$Score)) {
      stop(paste0("Second analysis (orig) of '", text2, "' with base model returned unexpected result."))
    }

    # Create a new builder instance to add the rule
    kb_rule_builder_ptr <- kiwi_builder_init_(kiwi_model_path_full("base"), 0, BuildOpt$DEFAULT)
    if (is.null(kb_rule_builder_ptr)) {
      stop("Failed to initialize kiwi_builder for rule with base model.")
    }

    add_rule_result <- kiwi_builder_add_rule_(kb_rule_builder_ptr, "EF", "요$", "용", -2.0)
    if (add_rule_result != 0L) { # C API returns 0 on success
        stop(paste0("kiwi_builder_add_rule_ failed with code: ", add_rule_result))
    }

    kw_with_rule_ptr <- kiwi_builder_build_(kb_rule_builder_ptr)
    if (is.null(kw_with_rule_ptr)) {
      stop("Failed to build kiwi from builder (with rule, base model).")
    }

    res_with_rule <- kiwi_analyze_wrap(kw_with_rule_ptr, text2, top_n = 1)
    if (is.null(res_with_rule) || length(res_with_rule) == 0 || !is.list(res_with_rule[[1]]$Token) || is.null(res_with_rule[[1]]$Score)) {
      stop(paste0("Analysis of '", text2, "' with rule added returned unexpected result."))
    }

  }, error = function(e) {
    err <<- e
  })

  if (!is.null(err)) {
    # If a 404 for the base model occurs, it's a critical failure for this test.
    if (grepl("HTTP status was '404 Not Found'", err$message) &&
        (grepl("base", err$message) || grepl("kiwi_model_v0.21.0_base.tgz", err$message) || grepl("cong_base", err$message))) {
      fail(paste0("Test setup failed: 'base' model (v0.21.0) not found, but was expected. Error: ", err$message))
    } else {
      fail(paste0("Test failed with an unexpected error: ", err$message))
    }
    return() # Stop if there was an error
  }

  # Assertions (only if err is NULL)
  expect_false(is.null(res1), "res1 should not be NULL")
  expect_false(is.null(res2_orig), "res2_orig should not be NULL")
  expect_false(is.null(res_with_rule), "res_with_rule should not be NULL")

  # Check that scores are present before trying to compare them
  if(!is.null(res1) && !is.null(res1[[1]]$Score) &&
     !is.null(res2_orig) && !is.null(res2_orig[[1]]$Score)) {
    expect_false(identical(res1[[1]]$Score, res2_orig[[1]]$Score),
                 info = "Scores for text1 and text2 (original) should ideally differ if text content is different enough, or this might indicate an issue if they are identical for different texts.")
  } else {
    fail("Score component missing in res1 or res2_orig.")
  }

  if(!is.null(res2_orig) && !is.null(res2_orig[[1]]$Score) &&
     !is.null(res_with_rule) && !is.null(res_with_rule[[1]]$Score)) {
    expect_false(identical(res2_orig[[1]]$Score, res_with_rule[[1]]$Score),
                 info = "Scores for text affected by rule should differ after rule application.")
  } else {
    fail("Score component missing in res2_orig or res_with_rule.")
  }

  if(!is.null(res1) && !is.null(res1[[1]]$Score) &&
     !is.null(res_with_rule) && !is.null(res_with_rule[[1]]$Score)) {
      expect_false(identical(res1[[1]]$Score, res_with_rule[[1]]$Score),
              info = "Scores for original text1 and rule-affected text2 should differ if rule has an impact.")
  } else {
    fail("Score component missing in res1 or res_with_rule.")
  }
})
