#' kiwi R6 class
#'
#' @importFrom R6 R6Class
#' @export
Kiwi <- R6::R6Class(
  "Kiwi",
  public = list(
    initialize = function(num_workers = 0,
                          model_size = "base",
                          integrate_allomorph = TRUE,
                          load_default_dict = TRUE) {
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
      private$kiwi_builder <-
        kiwi_builder_init_(kiwi_model_path_full(model_size), num_workers, boptions)
    },

    add_user_words = function(word, pos, score) {
      kiwi_builder_add_word_(private$kiwi_builder, word, pos, score)
    },

    add_pre_analyzed_words = function(alias, pos, score, orig_word) {
      kiwi_builder_add_word_(private$kiwi_builder, alias, pos, score, orig_word)
    },

    # add_rules = function(tag, replacer, score) {},
    # add_re_rules = function(tag, pattern, repl, score) {},

    load_user_dictionarys = function(user_dict_path) {
      # TODO validate dict
      # TODO add user dict list for save
      kiwi_builder_load_dict_(private$kiwi_builder, user_dict_path)
    },

    extract_words =  function(input,
                              min_cnt,
                              max_word_len,
                              min_score,
                              pos_threshold) {
      kiwi_builder_extract_words_(private$kiwi_builder,
                                  input,
                                  min_cnt,
                                  max_word_len,
                                  min_score,
                                  pos_threshold)
    },

    extract_add_words =  function(input,
                                  min_cnt,
                                  max_word_len,
                                  min_score,
                                  pos_threshold) {
      kiwi_builder_extract_add_words_(private$kiwi_builder,
                                      input,
                                      min_cnt,
                                      max_word_len,
                                      min_score,
                                      pos_threshold)
    },

    analyze = function(text,
                       top_n = 3,
                       match_options = Match$ALL,
                       stopwords_r = FALSE) {
      if (private$kiwi_not_ready)
        private$kiwi_build()
      kiwi_analyze_(private$kiwi, text, top_n, match_options, stopwords_r)
    },

    tokenize = function(text,
                        match_options = Match$ALL,
                        stopwords_r = FALSE) {
      if (private$kiwi_not_ready)
        private$kiwi_build()
      kiwi_analyze_(private$kiwi, text, 1, match_options, stopwords_r)
    },

    split_into_sents = function(text, match_options, return_tokens) {
      if (private$kiwi_not_ready)
        private$kiwi_build()
      kiwi_split_into_sents_(private$kiwi, text, match_options, return_tokens)
    },

    save_user_dictionarys = function(user_dict_path) {

    }

  ),

  private = list(
    kiwi = NULL,
    kiwi_builder = NULL,
    user_dic = NULL,
    kiwi_not_ready = FALSE,

    kiwi_build = function() {
      private$kiwi <- kiwi_builder_build_(private$kiwi_builder)
    },

    num_workers = NULL,
    model_path = NULL,
    build_options = NULL
  )
)
