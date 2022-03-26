#' kiwi R6 class
#'
#' @importFrom R6 R6Class
Kiwi <- R6::R6Class("Kiwi",
  public = list(
    initialize = function(
      num_workers = 0,
      model_size = "base",
      integrate_allomorph = TRUE,
      load_default_dict = TRUE
    ) {
      private$num_workers = num_workers
      private$model_path <- kiwi_model_path_full(model_size)

      boptions <- 0L
      if (integrate_allomorph) {
        boptions <- bitwOr(boptions, build_options$INTEGRATE_ALLOMORPH)
      }
      if (load_default_dict) {
        boptions <- bitwOr(boptions, build_options$LOAD_DEFAULT_DICT)
      }
      private$build_options <- boptions
      private$kiwi_builder <- kiwi_builder_init_(kiwi_model_path_full(model_size), num_workers, boptions)
    },

    tokenize = function(text) {

    },
    split_into_sents = function(text) {

    },
    extract_words =  function(variables) {

    },
    extract_add_words = function(variables) {

    },
    add_user_words = function(word, pos, score, orig_word) {},
    add_pre_analyzed_words = function(form, analyzed, score) {},
    # add_rules = function(tag, replacer, score) {},
    # add_re_rules = function(tag, pattern, repl, score) {},
    save_user_dictionarys = function(user_dict_path) {},
    load_user_dictionarys = function(user_dict_path) {}
  ),

  private = list(
    kiwi = NULL,
    kiwi_builder = NULL,
    user_dic = NULL,

    num_workers = NULL,
    model_path = NULL,
    build_options = NULL
  )
)
