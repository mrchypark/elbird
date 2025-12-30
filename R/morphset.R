#' Morphset Class
#'
#' @description
#'   Morphset class provides methods for managing morpheme sets that can be used
#'   to block specific morphemes from analysis results.
#'
#' @importFrom R6 R6Class
#' @examples
#' \dontrun{
#'   kw <- Kiwi$new()
#'   morphset <- kw$create_morphset()
#'   morphset$add("테스트", "NNG")
#'   result <- kw$analyze("테스트 문장", blocklist = morphset)
#' }
#' @export
Morphset <- R6::R6Class(
  "Morphset",
  public = list(
    #' @description print method for `Morphset` objects
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<Morphset class>", sep = "\n")
      cat(paste0("  morphemes: ", length(private$morphemes)), sep = "\n")
      if (length(private$morphemes) > 0) {
        cat("  entries:", sep = "\n")
        for (i in seq_len(min(5, length(private$morphemes)))) {
          entry <- private$morphemes[[i]]
          cat(paste0("    ", entry$form, "/", entry$tag), sep = "\n")
        }
        if (length(private$morphemes) > 5) {
          cat(paste0("    ... and ", length(private$morphemes) - 5, " more"), sep = "\n")
        }
      }
      invisible(self)
    },

    #' @description
    #'   Create a morphset instance with a C++ handle.
    #' @param handle C++ handle for the morphset object
    initialize = function(handle) {
      if (missing(handle) || is.null(handle)) {
        stop("Morphset requires a valid handle from Kiwi instance")
      }
      private$handle <- handle
      private$morphemes <- list()
    },

    #' @description
    #'   Add a morpheme to the morphset.
    #' @param form \code{char(required)}: morpheme form to add.
    #' @param tag \code{char(required)}: POS tag for the morpheme.
    #' @return \code{logical} indicating success
    add = function(form, tag) {
      if (missing(form) || missing(tag)) {
        stop("Both 'form' and 'tag' are required")
      }
      
      if (!is.character(form) || !is.character(tag)) {
        stop("Both 'form' and 'tag' must be character strings")
      }
      
      if (length(form) != 1 || length(tag) != 1) {
        stop("Both 'form' and 'tag' must be single character strings")
      }
      
      # Validate tag
      if (!is_tag(tag)) {
        stop(paste0("'", tag, "' is not a valid POS tag. Check Tags for valid options."))
      }
      
      # Add to C++ morphset
      result <- kiwi_morphset_add_(private$handle, form, check_tag(tag))
      
      if (result == 0) {
        # Add to internal tracking list for print method
        private$morphemes <- append(private$morphemes, 
                                   list(list(form = form, tag = tag)))
        return(TRUE)
      } else {
        warning(paste0("Failed to add morpheme: ", form, "/", tag))
        return(FALSE)
      }
    },

    #' @description
    #'   Add multiple morphemes to the morphset.
    #' @param forms \code{character vector}: morpheme forms to add.
    #' @param tags \code{character vector}: POS tags for the morphemes.
    #' @return \code{logical vector} indicating success for each morpheme
    add_multiple = function(forms, tags) {
      if (missing(forms) || missing(tags)) {
        stop("Both 'forms' and 'tags' are required")
      }
      
      if (!is.character(forms) || !is.character(tags)) {
        stop("Both 'forms' and 'tags' must be character vectors")
      }
      
      if (length(forms) != length(tags)) {
        stop("'forms' and 'tags' must have the same length")
      }
      
      results <- logical(length(forms))
      for (i in seq_along(forms)) {
        results[i] <- self$add(forms[i], tags[i])
      }
      
      return(results)
    },

    #' @description
    #'   Get the internal C++ handle for this morphset.
    #'   This is used internally by the Kiwi class.
    #' @return C++ handle
    get_handle = function() {
      private$handle
    },

    #' @description
    #'   Get the number of morphemes in this morphset.
    #' @return \code{integer} number of morphemes
    size = function() {
      length(private$morphemes)
    },

    #' @description
    #'   Get a list of all morphemes in this morphset.
    #' @return \code{list} of morphemes with form and tag
    get_morphemes = function() {
      private$morphemes
    },

    #' @description
    #'   Clear all morphemes from this morphset.
    #'   Note: This creates a new morphset handle, so existing references may become invalid.
    clear = function() {
      # Close current handle
      if (!is.null(private$handle)) {
        tryCatch({
          kiwi_morphset_close_(private$handle)
        }, error = function(e) {
          # Handle may already be closed, ignore error
        })
      }
      
      # Reset internal state
      private$morphemes <- list()
      private$handle <- NULL
      
      warning("Morphset has been cleared. You need to create a new morphset from Kiwi instance.")
    }
  ),

  private = list(
    handle = NULL,
    morphemes = NULL,
    
    # Finalizer to clean up C++ resources
    finalize = function() {
      if (!is.null(private$handle)) {
        tryCatch({
          kiwi_morphset_close_(private$handle)
        }, error = function(e) {
          # Handle may already be closed, ignore error
        })
      }
    }
  )
)