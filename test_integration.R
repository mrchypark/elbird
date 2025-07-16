#!/usr/bin/env Rscript

# Integration test script
# Test real usage scenarios to verify upgraded package functionality

cat("=== elbird Package Integration Test ===\n")

# Package loading test
tryCatch({
  library(elbird)
  cat("✓ Package loaded successfully\n")
}, error = function(e) {
  cat("✗ Package loading failed:", e$message, "\n")
  quit(status = 1)
})

# Version check
cat("Package version:", as.character(packageVersion("elbird")), "\n")

# Basic functionality test
cat("\n=== Basic Functionality Test ===\n")

# 1. Existing tokenize function test
test_text <- "Hello. This is a test sentence."
cat("Test text:", test_text, "\n")

tryCatch({
  result1 <- tokenize(test_text)
  cat("✓ tokenize() function working correctly\n")
  cat("  - Result type:", class(result1), "\n")
  cat("  - Token count:", nrow(result1), "\n")
}, error = function(e) {
  cat("✗ tokenize() function error:", e$message, "\n")
})

# 2. Existing analyze function test
tryCatch({
  result2 <- analyze(test_text)
  cat("✓ analyze() function working correctly\n")
  cat("  - Result type:", class(result2), "\n")
  cat("  - Analysis result count:", length(result2), "\n")
}, error = function(e) {
  cat("✗ analyze() function error:", e$message, "\n")
})

# 3. Kiwi R6 class test
cat("\n=== Kiwi R6 Class Test ===\n")

tryCatch({
  kw <- Kiwi$new()
  cat("✓ Kiwi class initialization successful\n")
  
  # Existing method test
  result3 <- kw$analyze(test_text)
  cat("✓ Kiwi$analyze() method working correctly\n")
  
  result4 <- kw$tokenize(test_text)
  cat("✓ Kiwi$tokenize() method working correctly\n")
  
}, error = function(e) {
  cat("✗ Kiwi class error:", e$message, "\n")
})

# 4. New feature test (if available)
cat("\n=== New Feature Test ===\n")

# Morphset class test
tryCatch({
  if (exists("Morphset")) {
    morphset <- Morphset$new()
    cat("✓ Morphset class available\n")
  } else {
    cat("- Morphset class not implemented\n")
  }
}, error = function(e) {
  cat("- Morphset class error:", e$message, "\n")
})

# Pretokenized class test
tryCatch({
  if (exists("Pretokenized")) {
    pretokenized <- Pretokenized$new()
    cat("✓ Pretokenized class available\n")
  } else {
    cat("- Pretokenized class not implemented\n")
  }
}, error = function(e) {
  cat("- Pretokenized class error:", e$message, "\n")
})

# 5. Performance test
cat("\n=== Performance Test ===\n")

# Large text processing test
large_text <- paste(rep(test_text, 100), collapse = " ")

start_time <- Sys.time()
tryCatch({
  result5 <- tokenize(large_text)
  end_time <- Sys.time()
  processing_time <- as.numeric(difftime(end_time, start_time, units = "secs"))
  
  cat("✓ Large text processing successful\n")
  cat("  - Processing time:", round(processing_time, 2), "seconds\n")
  cat("  - Token count:", nrow(result5), "\n")
  
  if (processing_time < 10) {
    cat("✓ Performance criteria passed (within 10 seconds)\n")
  } else {
    cat("⚠ Performance criteria not met (over 10 seconds)\n")
  }
}, error = function(e) {
  cat("✗ Large text processing failed:", e$message, "\n")
})

# 6. Backward compatibility test
cat("\n=== Backward Compatibility Test ===\n")

# Existing user code simulation
tryCatch({
  # Common usage pattern 1
  tokens <- tokenize("Korean morphological analysis test")
  analysis <- analyze("Korean morphological analysis test", top_n = 1)
  
  # Common usage pattern 2
  kiwi_instance <- Kiwi$new()
  kiwi_tokens <- kiwi_instance$tokenize("Test sentence")
  kiwi_analysis <- kiwi_instance$analyze("Test sentence")
  
  cat("✓ Existing user code pattern compatibility confirmed\n")
}, error = function(e) {
  cat("✗ Backward compatibility issue:", e$message, "\n")
})

# 7. Error handling test
cat("\n=== Error Handling Test ===\n")

# Error handling verification for invalid inputs
tryCatch({
  tokenize(NULL)
  cat("✗ NULL input error handling failed\n")
}, error = function(e) {
  cat("✓ NULL input error handling normal:", e$message, "\n")
})

tryCatch({
  tokenize(123)
  cat("✗ Numeric input error handling failed\n")
}, error = function(e) {
  cat("✓ Numeric input error handling normal:", e$message, "\n")
})

# Empty string handling
tryCatch({
  result_empty <- tokenize("")
  cat("✓ Empty string handling normal\n")
}, error = function(e) {
  cat("✗ Empty string handling failed:", e$message, "\n")
})

cat("\n=== Test Complete ===\n")
cat("All tests have been completed.\n")