#' Stop word Class
#'
#' @export
Stopwords <- R6::R6Class(
  'Stopwords',
  public = list(
    # print = function(x, ...) {
    #   cat("<elbird dictionary> ", sep = "\n")
    #   cat("  Stopwords ", sep = "\n")
    #   invisible()
    # },

    initialize = function(use_system_dict = TRUE) {
      if (use_system_dict)
        private$set_system_dict()

      invisible(self)
    },

    add = function(form, tag = "NNP") {
      private$add_dict_el(tibble::tibble(form = form, tag = check_tag(tag)),
                       "addfunc",
                       paste0(form, "/" , tag))
      invisible(self)
    },

    add_from_dict = function(path, dict_name = "user") {
      path <- normalizePath(path, mustWork = TRUE)
      private$set_dict(path)
      invisible(self)
    },

    remove = function(form = NULL, tag = NULL) {
      private$remove_dict_el(tibble::tibble(form = form, tag = check_tag(tag)),
                          "removefunc",
                          paste0(form, "/" , tag))
      invisible(self)
    },

    save_user_dict = function(path) {
      vroom::vroom_write(
        x = private$stopword_list,
        file = path,
        delim = "/",
        na = "",
        col_names = FALSE
      )
    },

    get = function() {
      private$stopword_list
    },

    use = function() {
      unique(private$stopword_list[c("form", "tag")])
    },

    lists = function() {
      private$dict_list
    }
  ),

  private = list(
    # stopword_list = NULL,
    # init_stopword_list = function() {
    #   private$stopword_list <- tibble::tibble(form = "",
    #                                           tag = Tags$nng)[-1, ]
    # },

    stopword_list = tibble::tibble(form = character(),
                                   tag = character()),

    dict_list = tibble::tibble(dict_name = character(),
                               info = character()),

    set_system_dict = function() {
      private$set_dict(dict_stopwords_path(), "system")
    },

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

    add_dict_el = function(dict, dict_name, dict_info) {
      private$stopword_list <-
        unique(dplyr::bind_rows(private$stopword_list, dict))
      private$dict_list <-
        dplyr::bind_rows(private$dict_list,
                         tibble::tibble(dict_name = dict_name, info = dict_info))
    },

    remove_dict_el = function(dict, dict_name, dict_info) {
      private$stopword_list <-
        dplyr::anti_join(private$stopword_list, dict, by = names(dict))
      private$dict_list <-
        dplyr::bind_rows(private$dict_list,
                         tibble::tibble(dict_name = dict_name, info = dict_info))
    }
  )
)
