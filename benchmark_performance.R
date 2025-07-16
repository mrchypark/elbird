#!/usr/bin/env Rscript

# Performance benchmark script
# Performance comparison and measurement before and after upgrade

cat("=== elbird Performance Benchmark ===\n")

# Load required packages
tryCatch({
  library(elbird)
  cat("✓ elbird package loaded successfully\n")
}, error = function(e) {
  cat("✗ elbird package loading failed:", e$message, "\n")
  quit(status = 1)
})

# Prepare test data
test_texts <- c(
  "Hello. This is a Korean morphological analyzer test.",
  "This is the second sentence for performance measurement.",
  "The third test sentence includes complex sentence structure and various vocabulary.",
  "A mixed language sentence containing number 123 and English hello.",
  "Modern text containing special characters !@#$% and emoji 😊."
)

# Generate large text
large_text <- paste(rep(test_texts, 50), collapse = " ")
very_large_text <- paste(rep(test_texts, 200), collapse = " ")

cat("Test data preparation complete\n")
cat("- Number of basic sentences:", length(test_texts), "\n")
cat("- Large text length:", nchar(large_text), "characters\n")
cat("- Very large text length:", nchar(very_large_text), "characters\n")

# Performance measurement function
measure_performance <- function(func, data, description, iterations = 5) {
  cat("\n--- ", description, " ---\n")
  
  times <- numeric(iterations)
  results <- list()
  
  for (i in 1:iterations) {
    start_time <- Sys.time()
    tryCatch({
      result <- func(data)
      end_time <- Sys.time()
      times[i] <- as.numeric(difftime(end_time, start_time, units = "secs"))
      if (i == 1) results[[1]] <- result  # Store only first result
    }, error = function(e) {
      cat("Error occurred:", e$message, "\n")
      times[i] <- NA
    })
  }
  
  valid_times <- times[!is.na(times)]
  if (length(valid_times) > 0) {
    cat("Average processing time:", round(mean(valid_times), 4), "seconds\n")
    cat("Minimum processing time:", round(min(valid_times), 4), "seconds\n")
    cat("Maximum processing time:", round(max(valid_times), 4), "seconds\n")
    cat("Standard deviation:", round(sd(valid_times), 4), "seconds\n")
    
    # Output result information
    if (length(results) > 0 && !is.null(results[[1]])) {
      if (is.data.frame(results[[1]])) {
        cat("Number of result rows:", nrow(results[[1]]), "\n")
      } else if (is.list(results[[1]])) {
        cat("Result list length:", length(results[[1]]), "\n")
      }
    }
  } else {
    cat("Error occurred in all attempts\n")
  }
  
  return(valid_times)
}

# 1. Basic tokenize performance test
cat("\n=== tokenize Function Performance Test ===\n")

# Single sentence
single_times <- measure_performance(tokenize, test_texts[1], "Single sentence tokenize")

# Multiple sentences
multi_times <- measure_performance(tokenize, test_texts, "Multiple sentences tokenize")

# Large text
large_times <- measure_performance(tokenize, large_text, "Large text tokenize", 3)

# 2. analyze function performance test
cat("\n=== analyze Function Performance Test ===\n")

analyze_single <- function(text) analyze(text, top_n = 1)
analyze_multi <- function(text) analyze(text, top_n = 3)

# Single analysis
single_analyze_times <- measure_performance(analyze_single, test_texts[1], "Single sentence analyze (top_n=1)")

# Multiple analysis
multi_analyze_times <- measure_performance(analyze_multi, test_texts[1], "Single sentence analyze (top_n=3)")

# Large text analysis
large_analyze_times <- measure_performance(analyze_single, large_text, "Large text analyze", 3)

# 3. Kiwi class performance test
cat("\n=== Kiwi Class Performance Test ===\n")

tryCatch({
  kw <- Kiwi$new()
  
  # Class method performance
  kiwi_tokenize_times <- measure_performance(
    function(x) kw$tokenize(x), 
    test_texts[1], 
    "Kiwi class tokenize"
  )
  
  kiwi_analyze_times <- measure_performance(
    function(x) kw$analyze(x), 
    test_texts[1], 
    "Kiwi class analyze"
  )
  
}, error = function(e) {
  cat("Kiwi class test failed:", e$message, "\n")
})

# 4. Memory usage test
cat("\n=== Memory Usage Test ===\n")

# Initial memory usage
initial_memory <- as.numeric(system("ps -o rss= -p $$", intern = TRUE))
cat("Initial memory usage:", initial_memory, "KB\n")

# Memory usage after repeated processing
for (i in 1:20) {
  result <- tokenize(test_texts[i %% length(test_texts) + 1])
  if (i %% 5 == 0) gc()  # Periodic garbage collection
}

final_memory <- as.numeric(system("ps -o rss= -p $$", intern = TRUE))
cat("Memory usage after processing:", final_memory, "KB\n")
cat("Memory increase:", final_memory - initial_memory, "KB\n")

# 5. Throughput calculation
cat("\n=== Throughput Analysis ===\n")

if (exists("large_times") && length(large_times) > 0) {
  avg_time <- mean(large_times)
  text_length <- nchar(large_text)
  chars_per_sec <- text_length / avg_time
  
  cat("Large text processing performance:\n")
  cat("- Text length:", text_length, "characters\n")
  cat("- Average processing time:", round(avg_time, 4), "seconds\n")
  cat("- Processing speed:", round(chars_per_sec), "characters/second\n")
  
  # Word-based throughput (approximate calculation)
  estimated_words <- text_length / 5  # Assuming average English word length
  words_per_sec <- estimated_words / avg_time
  cat("- Estimated processing speed:", round(words_per_sec), "words/second\n")
}

# 6. Performance summary
cat("\n=== Performance Summary ===\n")

performance_summary <- data.frame(
  Test = c("Single sentence tokenize", "Multiple sentences tokenize", "Large text tokenize", 
           "Single sentence analyze", "Large text analyze"),
  AvgTime = c(
    if(exists("single_times") && length(single_times) > 0) round(mean(single_times), 4) else NA,
    if(exists("multi_times") && length(multi_times) > 0) round(mean(multi_times), 4) else NA,
    if(exists("large_times") && length(large_times) > 0) round(mean(large_times), 4) else NA,
    if(exists("single_analyze_times") && length(single_analyze_times) > 0) round(mean(single_analyze_times), 4) else NA,
    if(exists("large_analyze_times") && length(large_analyze_times) > 0) round(mean(large_analyze_times), 4) else NA
  ),
  Status = c(
    if(exists("single_times") && length(single_times) > 0 && mean(single_times) < 1) "Good" else "Needs Improvement",
    if(exists("multi_times") && length(multi_times) > 0 && mean(multi_times) < 2) "Good" else "Needs Improvement",
    if(exists("large_times") && length(large_times) > 0 && mean(large_times) < 10) "Good" else "Needs Improvement",
    if(exists("single_analyze_times") && length(single_analyze_times) > 0 && mean(single_analyze_times) < 2) "Good" else "Needs Improvement",
    if(exists("large_analyze_times") && length(large_analyze_times) > 0 && mean(large_analyze_times) < 15) "Good" else "Needs Improvement"
  )
)

print(performance_summary)

cat("\n=== Benchmark Complete ===\n")
cat("Performance measurement has been completed.\n")
cat("Please refer to the summary table above for results.\n")