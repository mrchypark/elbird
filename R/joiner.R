#' Joiner Class
#'
#' @description
#'   Joiner class provides methods to compose morphemes into text.
#'
#' @importFrom R6 R6Class
#' @export
Joiner <- R6::R6Class(
  "Joiner",
  public = list(
    #' @description print method for `Joiner` objects
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<Joiner class>", sep = "\n")
      invisible(self)
    },

    #' @description
    #'   Create a joiner instance with a C++ handle.
    #' @param handle C++ handle for the joiner object
    initialize = function(handle) {
      if (missing(handle) || is.null(handle)) {
        stop("Joiner requires a valid handle")
      }
      private$handle <- handle
    },

    #' @description
    #'   Add a morpheme to the joiner.
    #' @param form \code{char(required)}: morpheme form.
    #' @param tag \code{char(required)}: POS tag.
    #' @param auto_irregular \code{bool(optional)}: auto detect irregular. Default is TRUE.
    add = function(form, tag, auto_irregular = TRUE) {
      if (missing(form) || missing(tag)) {
        stop("Both 'form' and 'tag' are required")
      }
      if (!is.character(form) || !is.character(tag)) {
        stop("Both 'form' and 'tag' must be character strings")
      }
      if (length(form) != 1 || length(tag) != 1) {
        stop("Both 'form' and 'tag' must be single character strings")
      }
      if (!is_tag(tag)) {
        stop(paste0("'", tag, "' is not a valid POS tag. Check Tags for valid options."))
      }
      kiwi_joiner_add_(private$handle, form, check_tag(tag), as.integer(auto_irregular))
      invisible(self)
    },

    #' @description
    #'   Get the composed text from the joiner.
    #' @return \code{character} composed text
    get = function() {
      kiwi_joiner_get_(private$handle)
    },

    #' @description
    #'   Get the internal C++ handle for this joiner.
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
            kiwi_joiner_close_(private$handle)
          },
          error = function(e) {}
        )
      }
    }
  )
)
