#' SwTokenizer Class
#'
#' @description
#'   SwTokenizer class provides encode/decode helpers for subword tokenization.
#'
#' @importFrom R6 R6Class
#' @export
SwTokenizer <- R6::R6Class(
  "SwTokenizer",
  public = list(
    #' @description print method for `SwTokenizer` objects
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<SwTokenizer class>", sep = "\n")
      invisible(self)
    },

    #' @description
    #'   Create a SwTokenizer instance with a C++ handle.
    #' @param handle C++ handle for the SwTokenizer object
    initialize = function(handle) {
      if (missing(handle) || is.null(handle)) {
        stop("SwTokenizer requires a valid handle")
      }
      private$handle <- handle
    },

    #' @description
    #'   Encode text into token ids.
    #' @param text \code{char(required)}: input text.
    #' @param return_offsets \code{bool(optional)}: include offsets. Default is TRUE.
    #' @return token ids (and offsets if requested)
    encode = function(text, return_offsets = TRUE) {
      if (missing(text) || !is.character(text) || length(text) != 1) {
        stop("'text' must be a single character string")
      }
      kiwi_swt_encode_(private$handle, text, -1, return_offsets)
    },

    #' @description
    #'   Decode token ids into text.
    #' @param token_ids \code{integer vector(required)}: token ids to decode.
    #' @return \code{character} decoded text
    decode = function(token_ids) {
      if (missing(token_ids)) {
        stop("'token_ids' is required")
      }
      kiwi_swt_decode_(private$handle, as.integer(token_ids))
    },

    #' @description
    #'   Get the internal C++ handle for this tokenizer.
    #' @return C++ handle
    get_handle = function() {
      private$handle
    }
  ),
  private = list(
    handle = NULL,
    finalize = function() {
      if (!is.null(private$handle)) {
        tryCatch(
          {
            kiwi_swt_close_(private$handle)
          },
          error = function(e) {}
        )
      }
    }
  )
)
