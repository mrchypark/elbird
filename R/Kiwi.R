#' kiwi R6 class
#'
#' @importFrom R6 R6Class
#' @export
Kiwi <- R6::R6Class(
  "Kiwi",

  public = list(
    #' @description print method for `Kiwi` objects
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<kiwi class> ", sep = "\n")
      invisible()
    },

    #' @description
    #'   Create a kiwi instance.
    #' @param num_workers use multi-thread core number. default is 0 which means use all core.
    #' @param model_size kiwi model select. default is "base". "small", "large" is available.
    #' @param integrate_allomorph default is TRUE.
    #' @param load_default_dict use defualt dictionary. default is TRUE.
    initialize = function(num_workers = 0,
                          model_size = "base",
                          integrate_allomorph = TRUE,
                          load_default_dict = TRUE) {
      private$num_workers = num_workers
      private$model_path <- kiwi_model_path_full(model_size)
      if (!kiwi_model_exists(model_size))
        get_kiwi_models(model_size)

      boptions <- 0L
      if (integrate_allomorph) {
        boptions <- bitwOr(boptions, BuildOpt$INTEGRATE_ALLOMORPH)
      }
      if (load_default_dict) {
        boptions <- bitwOr(boptions, BuildOpt$LOAD_DEFAULT_DICT)
      }
      private$build_options <- boptions
      private$kiwi_builder <-
        kiwi_builder_init_(kiwi_model_path_full(model_size), num_workers, boptions)
    },

    #' @description
    #'   add user word with pos and score
    #' @param word target word to add.
    #' @param pos pos information about word.
    #' @param score score information about word.
    #' @return
    add_user_words = function(word, pos, score) {
      kiwi_builder_add_word_(private$kiwi_builder, word, pos, score)
    },

    # add_pre_analyzed_words = function(alias, pos, score, orig_word) {
    #   kiwi_builder_add_word_(private$kiwi_builder, alias, pos, score, orig_word)
    # },

    # add_rules = function(tag, replacer, score) {},
    # add_re_rules = function(tag, pattern, repl, score) {},

    #' @description
    #'   add user dictionary using text file.
    #' @param user_dict_path path of user dictionary file.
    load_user_dictionarys = function(user_dict_path) {
      # TODO validate dict
      # TODO add user dict list for save
      kiwi_builder_load_dict_(private$kiwi_builder, user_dict_path)
    },

    #' @description
    #'   Extract Noun word candidate from texts.
    #' @param input target text data
    #' @param min_cnt minimum count of word in text.
    #' @param max_word_len max word length.
    #' @param min_score minimum score.
    #' @param pos_threshold pos threashold.
    #' @return
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

    #' @description
    #'   Extract Noun word candidate from texts and add user words.
    #' @param input target text data
    #' @param min_cnt minimum count of word in text.
    #' @param max_word_len max word length.
    #' @param min_score minimum score.
    #' @param pos_threshold pos threashold.
    #' @return
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

    #' @description
    #'   Analyze text to token and pos results.
    #' @param text target text.
    #' @param top_n number of result. Default is 3.
    #' @param match_option [`Match`]: use Match. Default is Match$ALL
    #' @param stopwords stopwords option. Default is TRUE which is
    #'                  to use embaded stopwords dictionany.
    #'                  If FALSE, use not embaded stopwords dictionany.
    #'                  If char: path of dictionary txt file, use file.
    #'                  If [`Stopwords`] class, use it.
    #'                  If not valid value, work same as FALSE.
    #' @return
    analyze = function(text,
                       top_n = 3,
                       match_option = Match$ALL,
                       stopwords = FALSE) {
      if (is.null(private$kiwi))
        private$kiwi_build()

      kiwi_analyze_wrap(private$kiwi, text, top_n, match_option, stopwords)
    },

    #' @description
    #'   Analyze text to token and pos result just top 1.
    #' @param text target text.
    #' @param match_option [`Match`]: use Match. Default is Match$ALL
    #' @param stopwords stopwords option. Default is TRUE which is
    #'                  to use embaded stopwords dictionary.
    #'                  If FALSE, use not embaded stopwords dictionary.
    #'                  If char: path of dictionary txt file, use file.
    #'                  If [`Stopwords`] class, use it.
    #'                  If not valid value, work same as FALSE.
    #' @param form return form. default is "tibble". "list", "tidytext" is available.
    #' @return
    tokenize = function(text,
                        match_option = Match$ALL,
                        stopwords = FALSE,
                        form = "tibble") {
      form <- match.arg(form, c("list", "tibble", "tidytext"))
      res <- purrr::map(
        text,
        ~ self$analyze(
          text = .x,
          top_n = 1,
          match_option = match_option,
          stopwords = stopwords
        )[[1]][1]
      )
      if (form == "list")
        return(res)
      raw <- purrr::map(
        res,
        ~ tibble::tibble(
          form = purrr::map_chr(.x$Token, ~ .x$form),
          tag = purrr::map_chr(.x$Token, ~ .x$tag),
          start = purrr::map_int(.x$Token, ~ .x$start),
          len = purrr::map_int(.x$Token, ~ .x$len),
        )
      )
      if (form == "tibble")
        return(dplyr::bind_rows(raw, .id = "unique"))
      if (form == "tidytext")
        return(purrr::map(raw, ~ paste0(.x$form, "/", .x$tag)))
    },

    #' @description
    #'   set function to tidytext unnest_tokens.
    #' @param match_option match_option [`Match`]: use Match. Default is Match$ALL
    #' @param stopwords stopwords option. Default is TRUE which is
    #'                  to use embaded stopwords dictionary.
    #'                  If FALSE, use not embaded stopwords dictionary.
    #'                  If char: path of dictionary txt file, use file.
    #'                  If [`Stopwords`] class, use it.
    #'                  If not valid value, work same as FALSE.
    #' @return
    get_tidytext_func = function(match_option = Match$ALL,
                                 stopwords = FALSE) {
      function(text) {
        self$tokenize(text,
                      match_option,
                      stopwords,
                      form = "tidytext")
      }
    },

    #' @description
    #' Some text may not split sentence by sentence.
    #' split_into_sents works split sentences to sentence by sentence.
    #'
    #' @param text target text.
    #' @param match_option match_option [`Match`]: use Match. Default is Match$ALL
    #' @param return_tokens add tokenized resault.
    #' @return
    split_into_sents = function(text,
                                match_option = Match$ALL,
                                return_tokens = FALSE) {
      if (private$kiwi_not_ready)
        private$kiwi_build()
      kiwi_split_into_sents_(private$kiwi, text, match_option, return_tokens)
    }

    # save_user_dictionarys = function(user_dict_path) {
    #
    # }

  ),

  private = list(
    kiwi = NULL,
    kiwi_builder = NULL,
    user_dic = NULL,

    kiwi_build = function() {
      private$kiwi <- kiwi_builder_build_(private$kiwi_builder)
    },

    num_workers = NULL,
    model_path = NULL,
    build_options = NULL
  )
)
