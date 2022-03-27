Tags <- NULL

Stopwords <- R6::R6Class('Stopwords',
  public = list(
    # print = function(x, ...) {
    #   cat("<elbird dictionary> ", sep = "\n")
    #   cat("  Stopwords ", sep = "\n")
    #   invisible()
    # },

    initialize = function(system_load = FALSE) {
      if (system_load) private$set_system_dict()
      invisible(self)
    },

    set_user_dict = function(path, dict_name = "user") {
      path <- normalizePath(path, mustWork = TRUE)
      private$set_dict(path)
      invisible(self)
    },

    add = function(form, tag = "NNP") {
      private$add_dict(tibble::tibble(form = form, tag = to_tag(tag)), "addfunc", paste0(form, "/" ,tag))
      invisible(self)
    },
    remove = function(form = NULL, tag = NULL) {
      word <- tibble::tibble(form = form, tag = to_tag(tag))
      private$stopword_list <- dplyr::anti_join(private$stopword_list, word, by = names(word))
      invisible(self)
    },
    save_user_dict = function(path) {
      invisible(self)
    },
    get = function() {
      private$stopword_list
    },
    use = function() {
      unique(private$stopword_list[c("form","tag")])
    },
    lists = function() {
      private$dict_list
    }
  ),

  private = list(
    stopword_list = tibble::tibble(
      form = "",
      tag = Tags$nng
    )[-1,],
    dict_list = tibble::tibble(
      dict_name = character(),
      info = character()
    ),
    set_system_dict = function() {
      private$set_dict(dict_stopwords_path(), "system")
    },
    set_dict = function(dict_path, dict_name) {
      loaded <- vroom::vroom(dict_path, delim = "/", show_col_types = F, col_names = F)
      loaded <- unique(loaded)
      names(loaded) <- c("form", "tag")
      purrr::map(loaded[["tag"]], ~ to_tag(.x))
      private$add_dict(loaded, dict_name, dict_path)
    },
    add_dict = function(dict, dict_name, dict_info) {
      private$stopword_list <- dplyr::bind_rows(private$stopword_list, dict)
      private$dict_list <- dplyr::bind_rows(private$dict_list, tibble::tibble(dict_name = dict_name, info = dict_info))
    },
    validated = function(data) {
      if (is.vector(data) && is.character(data)) {

      }
    }
  )
)
