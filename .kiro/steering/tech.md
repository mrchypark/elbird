# Technology Stack

## Core Technologies
- **R**: Primary language (requires R >= 3.5)
- **C++11**: Backend implementation via Kiwi library
- **cpp11**: R-C++ interface for binding
- **CMake**: Build system for C++ components
- **Git**: Version control and dependency management

## Key Dependencies
- **R6**: Object-oriented programming framework
- **dplyr**: Data manipulation
- **tibble**: Modern data frames
- **purrr**: Functional programming utilities
- **vroom**: Fast file I/O
- **matchr**: Enum support

## Build System
The package uses a custom configure script that:
1. Checks for system dependencies (git, cmake, uname)
2. Downloads and builds Kiwi C++ library from source if not found
3. Configures compilation flags via Makevars.in template
4. Supports custom library locations via INCLUDE_DIR/LIB_DIR

## Common Commands

### Development
```r
# Install development version
install.packages('elbird', repos = c('https://mrchypark.r-universe.dev', 'https://cloud.r-project.org'))

# Load package
library(elbird)
```

### Testing
```r
# Run tests
testthat::test_check("elbird")

# Or use devtools
devtools::test()
```

### Building from Source
```bash
# System requirements
# - git (for downloading Kiwi source)
# - cmake (for building Kiwi)
# - C++11 compatible compiler

# Build with custom paths
R CMD INSTALL --configure-vars='INCLUDE_DIR=/path/to/include LIB_DIR=/path/to/lib' .
```

## Platform Support
- Primary: Unix-like systems (Linux, macOS)
- Windows: Supported via specific Makevars.win and winlibs.R
- Requires pthread support for multi-threading

## Model Management
- Kiwi models downloaded automatically during installation
- Model sizes: "small", "base", "large"
- Models cached in package installation directory

## Code
- code first and import with ide and check correct