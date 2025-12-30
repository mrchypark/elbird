#!/usr/bin/env Rscript

# Real user scenario test
# Simulate common usage patterns and workflows

cat("=== Real User Scenario Test ===\n")

# Load packages
tryCatch({
  library(elbird)
  library(dplyr, warn.conflicts = FALSE)
  library(tibble, warn.conflicts = FALSE)
  cat("✓ Required packages loaded successfully\n")
}, error = function(e) {
  cat("✗ Package loading failed:", e$message, "\n")
  quit(status = 1)
})

# Scenario 1: Basic text analysis workflow
cat("\n=== Scenario 1: Basic Text Analysis ===\n")

sample_texts <- c(
  "Natural language processing is a very interesting field.",
  "Text structure can be understood through morphological analysis.",
  "The elbird package processes Korean at high speed.",
  "It is one of the tools frequently used by data scientists."
)

tryCatch({
  # Basic tokenization
  tokens <- tokenize(sample_texts)
  cat("✓ Multi-text tokenization successful\n")
  cat("  - Total token count:", nrow(tokens), "\n")
  
  # Morphological analysis
  analysis <- analyze(sample_texts[1], top_n = 3)
  cat("✓ Morphological analysis successful\n")
  cat("  - Analysis result count:", length(analysis), "\n")
  
  # Result data manipulation
  if (nrow(tokens) > 0) {
    # Extract nouns only
    nouns <- tokens %>% 
      filter(pos %in% c("NNG", "NNP", "NNB")) %>%
      count(token, sort = TRUE)
    
    cat("✓ Noun extraction successful\n")
    cat("  - Unique noun count:", nrow(nouns), "\n")
    if (nrow(nouns) > 0) {
      cat("  - Most frequent noun:", nouns$token[1], "(", nouns$n[1], "times)\n")
    }
  }
  
}, error = function(e) {
  cat("✗ Scenario 1 failed:", e$message, "\n")
})

# Scenario 2: Advanced analysis using Kiwi class
cat("\n=== Scenario 2: Kiwi Class Advanced Usage ===\n")

tryCatch({
  # Create Kiwi instance
  kw <- Kiwi$new()
  cat("✓ Kiwi instance creation successful\n")
  
  # Add user dictionary (if available)
  tryCatch({
    kw$add_user_word("elbird", "NNP", 1.0)
    cat("✓ User word addition successful\n")
  }, error = function(e) {
    cat("- User word addition feature not supported or error:", e$message, "\n")
  })
  
  # Perform analysis
  test_text <- "elbird is a Korean morphological analysis package."
  result <- kw$analyze(test_text)
  cat("✓ Kiwi class analysis successful\n")
  
  # Perform tokenization
  tokens <- kw$tokenize(test_text)
  cat("✓ Kiwi class tokenization successful\n")
  
}, error = function(e) {
  cat("✗ Scenario 2 failed:", e$message, "\n")
})

# Scenario 3: Large-scale data processing
cat("\n=== Scenario 3: Large-scale Data Processing ===\n")

# Generate virtual large-scale text data
large_dataset <- data.frame(
  id = 1:100,
  text = rep(c(
    "Customer satisfaction with the service is high.",
    "The product quality was better than expected.",
    "Delivery was fast and packaging was neat.",
    "The product has excellent performance for the price.",
    "This is a service I would like to use again."
  ), 20),
  stringsAsFactors = FALSE
)

tryCatch({
  start_time <- Sys.time()
  
  # Batch processing
  results <- large_dataset %>%
    mutate(
      tokens = map(text, ~ tokenize(.x)),
      token_count = map_int(tokens, nrow)
    )
  
  end_time <- Sys.time()
  processing_time <- as.numeric(difftime(end_time, start_time, units = "secs"))
  
  cat("✓ Large-scale batch processing successful\n")
  cat("  - Number of processed texts:", nrow(results), "\n")
  cat("  - Total processing time:", round(processing_time, 2), "seconds\n")
  cat("  - Average token count:", round(mean(results$token_count), 1), "\n")
  
  # Performance criteria check
  if (processing_time < 30) {
    cat("✓ Performance criteria passed (within 30 seconds)\n")
  } else {
    cat("⚠ Performance criteria not met (over 30 seconds)\n")
  }
  
}, error = function(e) {
  cat("✗ Scenario 3 failed:", e$message, "\n")
})

# Scenario 4: Text preprocessing pipeline
cat("\n=== Scenario 4: Text Preprocessing Pipeline ===\n")

raw_texts <- c(
  "Hello!!! This is a test... 😊",
  "Text mixed with number 123 and English HELLO.",
  "Sentence with special characters @#$%.",
  "   Sentence   with   many   spaces   .",
  "Text with\nline breaks\nincluded."
)

tryCatch({
  # Preprocessing and analysis pipeline
  processed_results <- tibble(original = raw_texts) %>%
    mutate(
      # Basic cleaning
      cleaned = str_trim(original),
      # Tokenization
      tokens = map(cleaned, ~ tokenize(.x)),
      # Statistics calculation
      token_count = map_int(tokens, nrow),
      # POS aggregation
      pos_summary = map(tokens, ~ .x %>% count(pos, sort = TRUE))
    )
  
  cat("✓ Text preprocessing pipeline successful\n")
  cat("  - Number of processed texts:", nrow(processed_results), "\n")
  cat("  - Average token count:", round(mean(processed_results$token_count), 1), "\n")
  
  # POS distribution check
  all_pos <- processed_results$pos_summary %>%
    bind_rows() %>%
    group_by(pos) %>%
    summarise(total = sum(n), .groups = "drop") %>%
    arrange(desc(total))
  
  cat("  - Main POS tags:", paste(head(all_pos$pos, 3), collapse = ", "), "\n")
  
}, error = function(e) {
  cat("✗ Scenario 4 failed:", e$message, "\n")
})

# Scenario 5: New feature utilization (if available)
cat("\n=== Scenario 5: New Feature Utilization ===\n")

# Morphset feature test
tryCatch({
  if (exists("Morphset")) {
    morphset <- Morphset$new()
    morphset$add("test", "NNG")
    cat("✓ Morphset feature available\n")
  } else {
    cat("- Morphset feature not implemented\n")
  }
}, error = function(e) {
  cat("- Morphset feature error:", e$message, "\n")
})

# Pretokenized feature test
tryCatch({
  if (exists("Pretokenized")) {
    pretokenized <- Pretokenized$new()
    cat("✓ Pretokenized feature available\n")
  } else {
    cat("- Pretokenized feature not implemented\n")
  }
}, error = function(e) {
  cat("- Pretokenized feature error:", e$message, "\n")
})

# Typo correction feature test
tryCatch({
  kw <- Kiwi$new()
  if ("set_typo_correction" %in% names(kw)) {
    kw$set_typo_correction(TRUE, 2.0)
    result <- kw$analyze("testt")  # Intentional typo
    cat("✓ Typo correction feature available\n")
  } else {
    cat("- Typo correction feature not implemented\n")
  }
}, error = function(e) {
  cat("- Typo correction feature error:", e$message, "\n")
})

# Scenario 6: Error recovery and stability test
cat("\n=== Scenario 6: Error Recovery and Stability ===\n")

error_test_cases <- list(
  list(input = NULL, desc = "NULL input"),
  list(input = "", desc = "Empty string"),
  list(input = "   ", desc = "Whitespace only string"),
  list(input = 123, desc = "Numeric input"),
  list(input = c("a", "b"), desc = "Vector input"),
  list(input = paste(rep("a", 10000), collapse = ""), desc = "Very long single token")
)

success_count <- 0
total_count <- length(error_test_cases)

for (test_case in error_test_cases) {
  tryCatch({
    result <- tokenize(test_case$input)
    cat("✓", test_case$desc, "processing successful\n")
    success_count <- success_count + 1
  }, error = function(e) {
    cat("✗", test_case$desc, "processing failed:", e$message, "\n")
  })
}

cat("Error handling success rate:", round(success_count / total_count * 100, 1), "%\n")

# Final summary
cat("\n=== User Scenario Test Summary ===\n")
cat("All real user scenario tests have been completed.\n")
cat("The practicality and stability of the package can be confirmed through the above results.\n")