# elbird 0.3.0

## Major Changes

* **BREAKING**: Upgraded Kiwi library from v0.11.2 to v0.21.0
* **BREAKING**: Now requires C++17 compatible compiler (upgraded from C++11)
* Updated build system to support new Kiwi version and C++17 requirements

## New Features

### Advanced Analysis Features
* Added `Morphset` class for blocking specific morphemes from analysis results
* Added `Pretokenized` class for guided morphological analysis with predefined token boundaries
* Added typo correction functionality with customizable rules and cost thresholds

### Enhanced API
* Extended `analyze()` and `tokenize()` functions with new optional parameters:
  - `blocklist`: Accept `Morphset` objects to block specific morphemes
  - `pretokenized`: Accept `Pretokenized` objects for guided analysis
* Added new methods to `Kiwi` class:
  - `create_morphset()`: Create morpheme sets for blocking
  - `create_pretokenized()`: Create pretokenized objects for guided analysis
  - `set_typo_correction()`: Configure typo correction settings
  - `get_typo_correction_settings()`: Get current typo correction configuration

### New Classes and Methods
* `Morphset` class with methods:
  - `add()`: Add single morpheme to block list
  - `add_multiple()`: Add multiple morphemes at once
  - `size()`: Get number of morphemes in set
  - `get_morphemes()`: Get list of all morphemes
  - `clear()`: Clear all morphemes
* `Pretokenized` class with methods:
  - `add_span()`: Add text span for tokenization
  - `add_token_to_span()`: Add token to specific span
  - `add_tokens_to_span()`: Add multiple tokens to span
  - `span_count()`: Get number of spans
  - `token_count()`: Get total number of tokens
  - `get_span_info()`: Get information about specific span
  - `get_all_spans()`: Get information about all spans
  - `clear()`: Clear all spans and tokens

## Improvements

* Enhanced error handling and validation for all new features
* Improved memory management for C++ objects with proper finalizers
* Updated documentation with comprehensive examples for new features
* Added extensive test coverage for new functionality
* Performance optimizations through upgraded Kiwi library

## Backward Compatibility

* All existing code continues to work without modification
* New parameters are optional with sensible defaults (`NULL`)
* Existing function signatures and return formats unchanged
* No breaking changes to user-facing API (except system requirements)

## Documentation Updates

* Updated README with new features and migration guide
* Enhanced vignettes with examples of new functionality
* Added comprehensive roxygen2 documentation for all new classes and methods
* Updated Korean documentation (README_kr.Rmd and vignettes)

## System Requirements

* **NEW**: C++17 compatible compiler required
* **NEW**: Updated build system with enhanced compiler detection
* All other system requirements remain the same

## Known Issues

* Users with older compilers may need to upgrade to C++17 support
* Custom build configurations may need adjustment for new C++17 requirements

## Migration Guide

### For Existing Users
No code changes required. All existing functionality works as before.

### To Use New Features
1. **Morpheme Blocking**: Create morphset with `kw$create_morphset()` and use `blocklist` parameter
2. **Typo Correction**: Enable with `kw$set_typo_correction(TRUE)`
3. **Guided Analysis**: Create pretokenized objects with `kw$create_pretokenized()`

### System Upgrade
Ensure your system has a C++17 compatible compiler before upgrading.

# elbird 0.2.5

* Fix url on readme for cran.

# elbird 0.2.4

* Rebuild document with roxygen2 7.2.1

# elbird 0.2.3

* Fix cran test fail.

# elbird 0.2.2

* size to 30 for [-Wvla]

# elbird 0.2.1

* Add `Stopwords` `add()` method form param default value NA.
* Fix `Stopwords` `add_from_dict()` param pass.

# elbird 0.2.0

* Change `_tbl` function to base.
  `tokenize()` return `tibble` base and remove `tokenize_tbl()`.
* Fix Kiwi when builder updated, kiwi rebuild.
* Change git clone to curl release source download for mac.
* Change tokenize function stopwords params default to TRUE.
* Update Model version to 0.11.2

# elbird 0.1.3

* Fix bashism on configure file for cran.

# elbird 0.1.2

* Fix -Wbitwise-instead-of-logical warning for cran.

# elbird 0.1.1

* Fix -Wreorder warning for cran.

# elbird 0.1.0

* Change backend python to cpp.

# elbird 0.0.2

* Package name to lower.
* Kiwi version 0.10.3 support.
* Python version 3.10.2 support.

# Elbird 0.0.1

* Fix add_user_word function with cache.

# Elbird 0.0.0.9001

* Added a `NEWS.md` file to track changes to the package.
