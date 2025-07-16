# Product Overview

elbird is an R package that provides a blazing fast Korean morphological analyzer based on Kiwi (Korean Intelligent Word Identifier). 

## Key Features
- High-performance Korean text tokenization and morphological analysis
- User dictionary support for custom vocabulary
- Unregistered noun detection based on frequency analysis
- Integration with tidytext ecosystem for text mining workflows
- Multiple output formats (tibble, list, tidytext-compatible)
- Sentence splitting functionality
- Stopwords filtering capabilities

## Target Users
- R developers working with Korean text processing
- Data scientists performing Korean NLP tasks
- Researchers analyzing Korean language data
- Text mining practitioners in Korean language contexts

## Core Functionality
The package wraps the C++ Kiwi library to provide:
- `tokenize()` functions for basic text tokenization
- `analyze()` for detailed morphological analysis with scoring
- `Kiwi` R6 class for advanced usage with custom dictionaries
- Integration functions for tidytext workflows