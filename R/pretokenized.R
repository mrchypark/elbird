#' Pretokenized Class
#'
#' @description
#'   Pretokenized class provides methods for managing pretokenized objects
#'   that can guide the morphological analysis process by providing
#'   predefined token boundaries and information.
#'
#' @importFrom R6 R6Class
#' @examples
#' \dontrun{
#'   kw <- Kiwi$new()
#'   pt <- kw$create_pretokenized()
#'   span_id <- pt$add_span(0, 10)
#'   pt$add_token_to_span(span_id, "테스트", "NNG", 0, 3)
#'   result <- kw$analyze("테스트 문장", pretokenized = pt)
#' }
#' @export
Pretokenized <- R6::R6Class(
  "Pretokenized",
  public = list(
    #' @description print method for `Pretokenized` objects
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<Pretokenized class>", sep = "\n")
      cat(paste0("  spans: ", length(private$spans)), sep = "\n")
      cat(paste0("  total tokens: ", private$total_tokens), sep = "\n")
      if (length(private$spans) > 0) {
        cat("  span details:", sep = "\n")
        for (i in seq_len(min(3, length(private$spans)))) {
          span <- private$spans[[i]]
          cat(paste0("    span ", i-1, ": [", span$begin, ", ", span$end, ") with ", 
                    length(span$tokens), " tokens"), sep = "\n")
          if (length(span$tokens) > 0) {
            for (j in seq_len(min(2, length(span$tokens)))) {
              token <- span$tokens[[j]]
              cat(paste0("      ", token$form, "/", token$tag, " [", 
                        token$begin, ", ", token$end, ")"), sep = "\n")
            }
            if (length(span$tokens) > 2) {
              cat(paste0("      ... and ", length(span$tokens) - 2, " more tokens"), sep = "\n")
            }
          }
        }
        if (length(private$spans) > 3) {
          cat(paste0("    ... and ", length(private$spans) - 3, " more spans"), sep = "\n")
        }
      }
      invisible(self)
    },

    #' @description
    #'   Create a pretokenized instance with a C++ handle.
    #' @param handle C++ handle for the pretokenized object
    initialize = function(handle) {
      if (missing(handle) || is.null(handle)) {
        stop("Pretokenized requires a valid handle")
      }
      private$handle <- handle
      private$spans <- list()
      private$total_tokens <- 0
    },

    #' @description
    #'   Add a span to the pretokenized object.
    #' @param begin \code{integer(required)}: beginning position of the span.
    #' @param end \code{integer(required)}: ending position of the span.
    #' @return \code{integer} span ID for adding tokens to this span
    add_span = function(begin, end) {
      if (missing(begin) || missing(end)) {
        stop("Both 'begin' and 'end' are required")
      }
      
      if (!is.numeric(begin) || !is.numeric(end)) {
        stop("Both 'begin' and 'end' must be numeric")
      }
      
      if (length(begin) != 1 || length(end) != 1) {
        stop("Both 'begin' and 'end' must be single values")
      }
      
      begin <- as.integer(begin)
      end <- as.integer(end)
      
      if (begin < 0 || end < 0) {
        stop("Both 'begin' and 'end' must be non-negative")
      }
      
      if (begin >= end) {
        stop("'begin' must be less than 'end'")
      }
      
      # Add span to C++ object
      result <- kiwi_pt_add_span_(private$handle, begin, end)
      
      if (result >= 0) {
        # Add to internal tracking for print method
        span_id <- length(private$spans)
        private$spans <- append(private$spans, 
                               list(list(begin = begin, end = end, tokens = list())))
        return(span_id)
      } else {
        stop(paste0("Failed to add span [", begin, ", ", end, ")"))
      }
    },

    #' @description
    #'   Add a token to a specific span.
    #' @param span_id \code{integer(required)}: ID of the span to add token to.
    #' @param form \code{char(required)}: token form.
    #' @param tag \code{char(required)}: POS tag for the token.
    #' @param begin \code{integer(required)}: beginning position of the token.
    #' @param end \code{integer(required)}: ending position of the token.
    #' @return \code{logical} indicating success
    add_token_to_span = function(span_id, form, tag, begin, end) {
      if (missing(span_id) || missing(form) || missing(tag) || missing(begin) || missing(end)) {
        stop("All parameters are required: span_id, form, tag, begin, end")
      }
      
      if (!is.numeric(span_id)) {
        stop("'span_id' must be numeric")
      }
      
      if (!is.character(form) || !is.character(tag)) {
        stop("Both 'form' and 'tag' must be character strings")
      }
      
      if (!is.numeric(begin) || !is.numeric(end)) {
        stop("Both 'begin' and 'end' must be numeric")
      }
      
      if (length(span_id) != 1 || length(form) != 1 || length(tag) != 1 || 
          length(begin) != 1 || length(end) != 1) {
        stop("All parameters must be single values")
      }
      
      span_id <- as.integer(span_id)
      begin <- as.integer(begin)
      end <- as.integer(end)
      
      if (span_id < 0 || span_id >= length(private$spans)) {
        stop(paste0("Invalid span_id: ", span_id, ". Must be between 0 and ", 
                   length(private$spans) - 1))
      }
      
      if (begin < 0 || end < 0) {
        stop("Both 'begin' and 'end' must be non-negative")
      }
      
      if (begin >= end) {
        stop("'begin' must be less than 'end'")
      }
      
      # Validate tag
      if (!is_tag(tag)) {
        stop(paste0("'", tag, "' is not a valid POS tag. Check Tags for valid options."))
      }
      
      # Check if token is within span boundaries
      span <- private$spans[[span_id + 1]]  # R uses 1-based indexing
      if (begin < span$begin || end > span$end) {
        stop(paste0("Token [", begin, ", ", end, ") is outside span [", 
                   span$begin, ", ", span$end, ")"))
      }
      
      # Add token to C++ object
      result <- kiwi_pt_add_token_to_span_(private$handle, span_id, form, check_tag(tag), begin, end)
      
      if (result == 0) {
        # Add to internal tracking for print method
        token_info <- list(form = form, tag = tag, begin = begin, end = end)
        private$spans[[span_id + 1]]$tokens <- append(private$spans[[span_id + 1]]$tokens, 
                                                      list(token_info))
        private$total_tokens <- private$total_tokens + 1
        return(TRUE)
      } else {
        warning(paste0("Failed to add token: ", form, "/", tag, " [", begin, ", ", end, ")"))
        return(FALSE)
      }
    },

    #' @description
    #'   Add multiple tokens to a span at once.
    #' @param span_id \code{integer(required)}: ID of the span to add tokens to.
    #' @param forms \code{character vector}: token forms.
    #' @param tags \code{character vector}: POS tags for the tokens.
    #' @param begins \code{integer vector}: beginning positions of the tokens.
    #' @param ends \code{integer vector}: ending positions of the tokens.
    #' @return \code{logical vector} indicating success for each token
    add_tokens_to_span = function(span_id, forms, tags, begins, ends) {
      if (missing(span_id) || missing(forms) || missing(tags) || missing(begins) || missing(ends)) {
        stop("All parameters are required: span_id, forms, tags, begins, ends")
      }
      
      if (!is.character(forms) || !is.character(tags)) {
        stop("Both 'forms' and 'tags' must be character vectors")
      }
      
      if (!is.numeric(begins) || !is.numeric(ends)) {
        stop("Both 'begins' and 'ends' must be numeric vectors")
      }
      
      lengths <- c(length(forms), length(tags), length(begins), length(ends))
      if (length(unique(lengths)) != 1) {
        stop("All vectors must have the same length")
      }
      
      results <- logical(length(forms))
      for (i in seq_along(forms)) {
        results[i] <- self$add_token_to_span(span_id, forms[i], tags[i], begins[i], ends[i])
      }
      
      return(results)
    },

    #' @description
    #'   Get the internal C++ handle for this pretokenized object.
    #'   This is used internally by the Kiwi class.
    #' @return C++ handle
    get_handle = function() {
      private$handle
    },

    #' @description
    #'   Get the number of spans in this pretokenized object.
    #' @return \code{integer} number of spans
    span_count = function() {
      length(private$spans)
    },

    #' @description
    #'   Get the total number of tokens across all spans.
    #' @return \code{integer} total number of tokens
    token_count = function() {
      private$total_tokens
    },

    #' @description
    #'   Get information about a specific span.
    #' @param span_id \code{integer(required)}: ID of the span to get information for.
    #' @return \code{list} with span information
    get_span_info = function(span_id) {
      if (missing(span_id)) {
        stop("'span_id' is required")
      }
      
      if (!is.numeric(span_id) || length(span_id) != 1) {
        stop("'span_id' must be a single numeric value")
      }
      
      span_id <- as.integer(span_id)
      
      if (span_id < 0 || span_id >= length(private$spans)) {
        stop(paste0("Invalid span_id: ", span_id, ". Must be between 0 and ", 
                   length(private$spans) - 1))
      }
      
      return(private$spans[[span_id + 1]])
    },

    #' @description
    #'   Get information about all spans.
    #' @return \code{list} of all spans
    get_all_spans = function() {
      private$spans
    },

    #' @description
    #'   Clear all spans and tokens from this pretokenized object.
    #'   Note: This creates a new pretokenized handle, so existing references may become invalid.
    clear = function() {
      # Close current handle
      if (!is.null(private$handle)) {
        tryCatch({
          kiwi_pt_close_(private$handle)
        }, error = function(e) {
          # Handle may already be closed, ignore error
        })
      }
      
      # Reset internal state
      private$spans <- list()
      private$total_tokens <- 0
      private$handle <- NULL
      
      warning("Pretokenized object has been cleared. You need to create a new one from Kiwi instance.")
    }
  ),

  private = list(
    handle = NULL,
    spans = NULL,
    total_tokens = NULL,
    
    # Finalizer to clean up C++ resources
    finalize = function() {
      if (!is.null(private$handle)) {
        tryCatch({
          kiwi_pt_close_(private$handle)
        }, error = function(e) {
          # Handle may already be closed, ignore error
        })
      }
    }
  )
)