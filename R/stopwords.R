Stopwords <- R6::R6Class('Stopwords',
  public = list(
    # print = function(x, ...) {
    #   cat("<elbird dictionary> ", sep = "\n")
    #   cat("  Stopwords ", sep = "\n")
    #   invisible()
    # },

    initialize = function(empty = FALSE) {
      if (!empty) private$set_system_dict()
      invisible(self)
    },

    set_user_dict = function(path) {
      path <- normalizePath(path, mustWork = TRUE)
      private$set_dict(path)
    },

    add = function(form, tag = "NNP") {

    },
    # remove = function(word) {
    #
    #
    # },
    get = function() {
      private$stopword_list[c("form","tag")]
    }
  ),

  private = list(
    stopword_list =  tibble::tibble(
      type = character(),
      form = character(),
      tag = character()
    ),
    set_system_dict = function() {
      private$set_dict(dict_stopwords_path())
    },
    set_dict = function(dict_path) {
      loaded <- vroom::vroom(dict_path, delim = "/", show_col_types = F, col_names = F, id = "type")
      names(loaded) <- c("type", "form", "tag")
      private$stopword_list <- dplyr::bind_rows(private$stopword_list, loaded)
    },
    validated = function(data) {
      if (is.vector(data) && is.character(data)) {

      }
    }
  )
)
