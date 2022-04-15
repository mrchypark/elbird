#' Stopwords Class
#'
#' @description
#'   Stopwords is for filter result.
#'
#' @examples
#' \dontrun{
#'   Stopwords$new()
#'}
#' @export
Stopwords <- R6::R6Class(
  'Stopwords',
  public = list(

    #' @description print method for `Stopwords` objects
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<stopwords dict>", sep = "\n")
      cat(paste0("  word count: ", nrow(private$stopword_list)), sep = "\n")
      invisible(self)
    },

    #' @description
    #'   Create a stopwords object for filter stopwords on [analyze()] and [tokenize()] results.
    #' @param use_system_dict \code{bool(optional)}: use system stopwords dictionary or not.
    #'                              Defualt is TRUE.
    initialize = function(use_system_dict = TRUE) {
      if (use_system_dict)
        private$set_system_dict()

      invisible(self)
    },

    #' @description
    #'   add stopword one at a time.
    #' @param form \code{char(optional)}: Form information. Default is NA.
    #' @param tag  \code{char(optional)}: Tag information. Default is "NNP". Please check [Tags].
    #' @examples
    #'  \dontrun{
    #'   sw <- Stopwords$new()
    #'   sw$add("word", "NNG")
    #'   sw$add("word", Tags$nng)
    #'   }
    add = function(form = NA, tag = Tags$nnp) {
      private$add_dict_el(tibble::tibble(form = form, tag = check_tag(tag)),
                       "addfunc",
                       paste0(form, "/" , tag))
      invisible(self)
    },

    #' @description
    #'   add stopword from text file.
    #'   text file need to form "TEXT/TAG".
    #'   TEXT can remove like "/NNP".
    #'   TAG required like "FORM/NNP".
    #' @param path       \code{char(required)}: dictionary file path.
    #' @param dict_name  \code{char(optional)}: default is "user"
    add_from_dict = function(path, dict_name = "user") {
      path <- normalizePath(path, mustWork = TRUE)
      private$set_dict(path, dict_name)
      invisible(self)
    },

    #' @description
    #'   remove stopword one at a time.
    #' @param form \code{char(optional)}: Form information. If form not set, remove tag in input.
    #' @param tag  \code{char(required)}: Tag information. Please check [Tags].
    remove = function(form = NULL, tag = NULL) {
      if (is.null(tag)) {stop("argument \"tag\" is missing, with no default")}
      private$remove_dict_el(tibble::tibble(form = form, tag = check_tag(tag)),
                          "removefunc",
                          paste0(form, "/" , tag))
      invisible(self)
    },

    #' @description
    #'   save current stopwords list in text file.
    #' @param path \code{char(required)}: file path to save stopwords list.
    #' @importFrom vroom vroom_write
    save_dict = function(path) {
      vroom::vroom_write(
        x = private$stopword_list,
        file = path,
        delim = "/",
        na = "",
        col_names = FALSE
      )
    },

    # history = function() {
    #   private$dict_list
    # }

    #' @description
    #'  return tibble of stopwords.
    #' @return a [tibble][tibble::tibble-package] for stopwords options
    #'         for [analyze()] / [tokenize()] function.
    get = function() {
      unique(private$stopword_list[c("form", "tag")])
    }
  ),

  private = list(

    stopword_list = tibble::tibble(form = character(),
                                   tag = character()),

    dict_list = tibble::tibble(dict_name = character(),
                               info = character()),

    set_system_dict = function() {
      private$set_dict(dict_stopwords_path(), "system")
    },

    #' @importFrom vroom vroom
    #' @importFrom dplyr mutate
    #' @importFrom purrr map_chr
    set_dict = function(dict_path, dict_name) {
      loaded <-
        vroom::vroom(
          dict_path,
          delim = "/",
          show_col_types = F,
          col_names = F
        )
      loaded <- unique(loaded)
      names(loaded) <- c("form", "tag")
      private$add_dict_el(dplyr::mutate(loaded,
                                     tag = purrr::map_chr(tag, ~ check_tag(.x))),
                       dict_name,
                       dict_path)
    },

    #' @importFrom dplyr bind_rows
    add_dict_el = function(dict, dict_name, dict_info) {
      private$stopword_list <-
        unique(dplyr::bind_rows(private$stopword_list, dict))
      private$dict_list <-
        dplyr::bind_rows(private$dict_list,
                         tibble::tibble(dict_name = dict_name, info = dict_info))
    },

    #' @importFrom dplyr anti_join bind_rows
    remove_dict_el = function(dict, dict_name, dict_info) {
      private$stopword_list <-
        dplyr::anti_join(private$stopword_list, dict, by = names(dict))
      private$dict_list <-
        dplyr::bind_rows(private$dict_list,
                         tibble::tibble(dict_name = dict_name, info = dict_info))
    }
  )
)
