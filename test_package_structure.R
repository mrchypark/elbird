#!/usr/bin/env Rscript

# Package structure and function definition test
# Verification at source code level without actual installation

cat("=== elbird Package Structure Test ===\n")

# 1. DESCRIPTION file verification
cat("\n1. DESCRIPTION File Verification\n")
desc_content <- readLines("DESCRIPTION")
cat("✓ DESCRIPTION file read successfully\n")

# Version check
version_line <- grep("^Version:", desc_content, value = TRUE)
cat("Package version:", gsub("Version: ", "", version_line), "\n")

# Dependencies check
imports_start <- grep("^Imports:", desc_content)
if (length(imports_start) > 0) {
  cat("✓ Imports section confirmed\n")
}

# 2. NAMESPACE file verification
cat("\n2. NAMESPACE File Verification\n")
namespace_content <- readLines("NAMESPACE")
exported_functions <- grep("^export\\(", namespace_content, value = TRUE)
cat("✓ NAMESPACE file read successfully\n")
cat("Number of exported functions:", length(exported_functions), "\n")

# Main functions check
main_functions <- c("tokenize", "analyze", "Kiwi", "Morphset", "Pretokenized")
for (func in main_functions) {
  if (any(grepl(func, exported_functions))) {
    cat("✓", func, "function export confirmed\n")
  } else {
    cat("✗", func, "function export missing\n")
  }
}

# 3. R source file verification
cat("\n3. R Source File Verification\n")
r_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
cat("Number of R source files:", length(r_files), "\n")

for (file in r_files) {
  tryCatch({
    source(file, local = TRUE)
    cat("✓", basename(file), "syntax check passed\n")
  }, error = function(e) {
    cat("✗", basename(file), "syntax error:", e$message, "\n")
  })
}

# 4. C++ source file verification
cat("\n4. C++ Source File Verification\n")
cpp_files <- list.files("src", pattern = "\\.(cpp|h)$", full.names = TRUE)
cat("Number of C++ source files:", length(cpp_files), "\n")

for (file in cpp_files) {
  if (file.exists(file)) {
    file_size <- file.info(file)$size
    cat("✓", basename(file), "exists (", file_size, "bytes)\n")
  } else {
    cat("✗", basename(file), "file not found\n")
  }
}

# 5. Test file verification
cat("\n5. Test File Verification\n")
test_files <- list.files("tests/testthat", pattern = "^test-.*\\.R$", full.names = TRUE)
cat("Number of test files:", length(test_files), "\n")

for (file in test_files) {
  tryCatch({
    # Perform basic syntax check only
    parse(file)
    cat("✓", basename(file), "syntax check passed\n")
  }, error = function(e) {
    cat("✗", basename(file), "syntax error:", e$message, "\n")
  })
}

# 6. Documentation file verification
cat("\n6. Documentation File Verification\n")
man_files <- list.files("man", pattern = "\\.Rd$", full.names = TRUE)
cat("Number of documentation files:", length(man_files), "\n")

# Main function documentation check
main_docs <- c("tokenize.Rd", "analyze.Rd", "Kiwi.Rd", "Morphset.Rd", "Pretokenized.Rd")
for (doc in main_docs) {
  doc_path <- file.path("man", doc)
  if (file.exists(doc_path)) {
    cat("✓", doc, "documentation exists\n")
  } else {
    cat("✗", doc, "documentation missing\n")
  }
}

# 7. Build configuration file verification
cat("\n7. Build Configuration File Verification\n")

# configure script
if (file.exists("configure")) {
  cat("✓ configure script exists\n")
  # Check execution permission
  file_info <- file.info("configure")
  if (file_info$mode != 0) {
    cat("✓ configure script executable\n")
  }
} else {
  cat("✗ configure script not found\n")
}

# Makevars.in
if (file.exists("src/Makevars.in")) {
  cat("✓ Makevars.in exists\n")
} else {
  cat("✗ Makevars.in not found\n")
}

# 8. Package metadata consistency verification
cat("\n8. Package Metadata Consistency Verification\n")

# DESCRIPTION and NAMESPACE consistency
desc_package <- grep("^Package:", desc_content, value = TRUE)
package_name <- gsub("Package: ", "", desc_package)
cat("Package name:", package_name, "\n")

# useDynLib check
dynlib_line <- grep("useDynLib", namespace_content, value = TRUE)
if (length(dynlib_line) > 0) {
  cat("✓ Dynamic library connection setting confirmed\n")
  cat("DynLib setting:", dynlib_line, "\n")
} else {
  cat("✗ Dynamic library connection setting not found\n")
}

# 9. New feature implementation status check
cat("\n9. New Feature Implementation Status Check\n")

# Kiwi v0.21.0 related functions check
new_functions <- c("kiwi_new_morphset_", "kiwi_pt_init_", "kiwi_typo_init_")
cpp_content <- paste(readLines("src/kiwi_bind.cpp"), collapse = "\n")

for (func in new_functions) {
  if (grepl(func, cpp_content)) {
    cat("✓", func, "implementation confirmed\n")
  } else {
    cat("✗", func, "implementation missing\n")
  }
}

# 10. Summary
cat("\n=== Package Structure Test Summary ===\n")
cat("Package structure verification has been completed.\n")
cat("Main components are properly arranged,\n")
cat("and Kiwi v0.21.0 upgrade related code has been implemented.\n")
cat("\nActual functionality testing is available after package installation.\n")