# Project Structure

## Standard R Package Layout

### Core Directories
- **R/**: R source code and function definitions
- **src/**: C++ source code and binding files
- **man/**: Generated documentation files (via roxygen2)
- **tests/testthat/**: Unit tests using testthat framework
- **inst/**: Package installation files (dictionaries, models)
- **vignettes/**: Package documentation and tutorials

### Key Files
- **DESCRIPTION**: Package metadata and dependencies
- **NAMESPACE**: Exported functions and imports (auto-generated)
- **configure**: Build configuration script for C++ components
- **cleanup**: Build cleanup script

## R Code Organization

### Main Functions (`R/`)
- **elbird-package.R**: Package documentation and imports
- **kiwi.R**: Main Kiwi R6 class implementation
- **tokenize.R**: Simple tokenization functions
- **analyze.R**: Text analysis functions
- **wrapper.R**: C++ binding wrappers
- **types.R**: Type definitions and enums
- **stopwords.R**: Stopwords functionality
- **init.R**: Package initialization
- **onLoad.R**: Package loading hooks

### C++ Integration (`src/`)
- **cpp11.cpp**: Auto-generated cpp11 bindings
- **kiwi_bind.cpp**: Manual C++ binding implementations
- **Makevars.in**: Template for compilation configuration
- **Makevars.win**: Windows-specific build configuration

## Testing Structure
- **tests/testthat.R**: Test runner entry point
- **tests/testthat/test-*.R**: Individual test files by functionality
  - Naming pattern: `test-[function-name].R`
  - Each major function has dedicated test file

## Documentation
- **README.Rmd**: Source for README (knitted to README.md)
- **vignettes/articles/**: Extended documentation and tutorials
- **man/figures/**: Images and plots for documentation
- **_pkgdown.yml**: Website generation configuration

## Build Artifacts (Generated)
- **kiwilibs/**: Downloaded Kiwi C++ library (build-time)
- **inst/model/**: Kiwi language models (runtime)
- **src/Makevars**: Generated build configuration

## Conventions
- Use roxygen2 for documentation (`#'` comments)
- Follow tidyverse style guide for R code
- Test files mirror R/ structure with `test-` prefix
- C++ files use snake_case with trailing underscore for bindings
- Exported functions use camelCase or snake_case consistently