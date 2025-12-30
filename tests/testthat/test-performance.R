test_that("large text processing performance", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  skip_on_cran() # Skip on CRAN due to time constraints

  if (!model_works("base")) {
    get_model("base")
  }

  # Create large text for testing
  base_text <- "안녕하세요 이것은 성능 테스트를 위한 긴 텍스트입니다. 한국어 형태소 분석기의 성능을 측정하기 위해 작성되었습니다."
  large_text <- paste(rep(base_text, 100), collapse = " ")

  # Test tokenize performance
  start_time <- Sys.time()
  result <- tokenize(large_text)
  end_time <- Sys.time()
  processing_time <- as.numeric(difftime(end_time, start_time, units = "secs"))

  expect_true(tibble::is_tibble(result))
  expect_true(nrow(result) > 1000) # Should have many tokens
  expect_true(processing_time < 30) # Should complete within 30 seconds

  # Test analyze performance
  start_time <- Sys.time()
  result2 <- analyze(large_text, top_n = 1)
  end_time <- Sys.time()
  processing_time2 <- as.numeric(difftime(end_time, start_time, units = "secs"))

  expect_true(length(result2) > 0)
  expect_true(processing_time2 < 30) # Should complete within 30 seconds
})

test_that("batch processing performance", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  skip_on_cran() # Skip on CRAN due to time constraints

  # Create multiple texts for batch processing
  texts <- c(
    "첫 번째 테스트 문장입니다.",
    "두 번째 테스트 문장입니다.",
    "세 번째 테스트 문장입니다.",
    "네 번째 테스트 문장입니다.",
    "다섯 번째 테스트 문장입니다."
  )

  # Repeat to create larger batch
  batch_texts <- rep(texts, 20) # 100 texts total

  # Test batch tokenization performance
  start_time <- Sys.time()
  results <- tokenize(batch_texts)
  end_time <- Sys.time()
  processing_time <- as.numeric(difftime(end_time, start_time, units = "secs"))

  expect_true(tibble::is_tibble(results))
  expect_true(nrow(results) > 100) # Should have many tokens
  expect_true(processing_time < 60) # Should complete within 60 seconds
})

test_that("memory usage stability", {
  skip_if_offline()
  skip_on_os(os = "windows")
  skip_on_cran() # Skip on CRAN due to resource constraints

  if (!model_works("base")) {
    get_model("base")
  }

  get_rss_kb <- function() {
    rss <- suppressWarnings(system("ps -o rss= -p $$", intern = TRUE))
    rss <- suppressWarnings(as.numeric(rss))
    if (length(rss) == 0 || is.na(rss)) {
      return(NA_real_)
    }
    rss
  }

  # Test repeated operations for memory leaks
  initial_memory <- get_rss_kb()
  if (is.na(initial_memory)) {
    skip("RSS measurement not available on this platform")
  }

  # Perform repeated operations
  for (i in 1:50) {
    result <- tokenize("반복적인 메모리 테스트를 위한 문장입니다.")
    expect_true(tibble::is_tibble(result))

    # Force garbage collection periodically
    if (i %% 10 == 0) {
      gc()
    }
  }

  # Check memory usage after operations
  final_memory <- get_rss_kb()
  if (is.na(final_memory)) {
    skip("RSS measurement not available on this platform")
  }
  memory_increase <- final_memory - initial_memory

  # Memory increase should be reasonable (less than 100MB)
  expect_true(memory_increase < 100000) # RSS is in KB
})

test_that("concurrent processing stability", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  skip_on_cran() # Skip on CRAN due to complexity

  if (!requireNamespace("parallel", quietly = TRUE)) {
    skip("parallel package not available")
  }

  # Test concurrent tokenization
  texts <- c(
    "첫 번째 동시 처리 테스트 문장입니다.",
    "두 번째 동시 처리 테스트 문장입니다.",
    "세 번째 동시 처리 테스트 문장입니다.",
    "네 번째 동시 처리 테스트 문장입니다."
  )

  # Use parallel processing
  cl <- parallel::makeCluster(2)
  on.exit(parallel::stopCluster(cl))

  # Export necessary functions to cluster
  parallel::clusterEvalQ(cl, library(elbird))

  # Test parallel tokenization
  results <- parallel::parLapply(cl, texts, function(text) {
    tryCatch(
      {
        tokenize(text)
      },
      error = function(e) {
        list(error = e$message)
      }
    )
  })

  # Check that all results are valid
  for (result in results) {
    if ("error" %in% names(result)) {
      fail(paste("Parallel processing failed:", result$error))
    } else {
      expect_true(tibble::is_tibble(result))
    }
  }
})

test_that("error handling and recovery", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  # Test with invalid inputs
  expect_error(tokenize(NULL), "text.*cannot be NULL")
  expect_error(tokenize(123), "text.*must be character")
  expect_error(tokenize(""), NA) # Empty string should not error

  # Test with very long single token
  very_long_token <- paste(rep("가", 10000), collapse = "")
  expect_no_error(tokenize(very_long_token))

  # Test with special characters
  special_text <- "!@#$%^&*()_+-=[]{}|;':\",./<>?`~"
  result <- tokenize(special_text)
  expect_true(tibble::is_tibble(result))

  # Test with mixed languages
  mixed_text <- "Hello 안녕하세요 こんにちは 你好"
  result2 <- tokenize(mixed_text)
  expect_true(tibble::is_tibble(result2))
  expect_true(nrow(result2) > 0)
})
