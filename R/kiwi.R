#' Kiwi Class
#'
#' @description
#'   Kiwi class is provide method for korean mophological analyze result.
#'
#' @importFrom R6 R6Class
#' @examples
#' \dontrun{
#'   kw <- Kiwi$new()
#'   kw$analyze("test")
#'   kw$tokenize("test")
#'   }
#' @export
Kiwi <- R6::R6Class(
  "Kiwi",
  public = list(
    #' @description print method for `Kiwi` objects
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<kiwi class> ", sep = "\n")
      cat(paste0("  model: ",private$model_size), sep = "\n")
      invisible(self)
    },

    #' @description
    #'   Create a kiwi instance.
    #' @param num_workers \code{int(optional)}: use multi-thread core number. default is 0 which means use all core.
    #' @param model_size \code{char(optional)}: kiwi model select. default is "base". "small", "large" is available.
    #' @param integrate_allomorph \code{bool(optional)}: default is TRUE.
    #' @param load_default_dict \code{bool(optional)}: use defualt dictionary. default is TRUE.
    initialize = function(num_workers = 0,
                          model_size = "base",
                          integrate_allomorph = TRUE,
                          load_default_dict = TRUE) {

      private$num_workers <-  num_workers
      private$model_size <- model_size
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
    #' @param word \code{char(required)}: target word to add.
    #' @param tag \code{Tags(required)}: tag information about word.
    #' @param score \code{num(required)}: score information about word.
    #' @param orig_word \code{char(optional)}: origin word.
    add_user_word = function(word, tag, score, orig_word = "") {
      if (orig_word == "") {
        kiwi_builder_add_word_(private$kiwi_builder, word, check_tag(tag), score)
      } else {
        kiwi_builder_add_alias_word_(private$kiwi_builder, word, check_tag(tag), score, orig_word)
      }
      private$builder_updated <- TRUE
    },

    #' @description
    #'   TODO
    #' @param form \code{char(required)}: target word to add analyzed result.
    #' @param analyzed \code{data.frame(required)}: analyzed result expected.
    #' @param score \code{num(required)}: score information about pre analyzed result.
    add_pre_analyzed_words = function(form, analyzed, score) {
      kiwi_builder_add_pre_analyzed_word_(private$kiwi_builder, form, analyzed, score)
      private$builder_updated <- TRUE
    },

    #' @description
    #'  TODO
    #' @param tag \code{Tags(required)}: target tag to add rules.
    #' @param pattern \code{char(required)}: regular expression.
    #' @param replacement \code{char(required)}: replace text.
    #' @param score \code{num(required)}: score information about rules.
    add_rules = function(tag, pattern, replacement, score) {
      kiwi_builder_add_rule_(private$kiwi_builder, tag, pattern, replacement, score)
      private$builder_updated <- TRUE
    },

    #' @description
    #'   add user dictionary using text file.
    #' @param user_dict_path \code{char(required)}: path of user dictionary file.
    load_user_dictionarys = function(user_dict_path) {
      # TODO validate dict
      # TODO add user dict list for save
      kiwi_builder_load_dict_(private$kiwi_builder, user_dict_path)
      private$builder_updated <- TRUE
    },

    #' @description
    #'   Extract Noun word candidate from texts.
    #' @param input \code{char(required)}: target text data
    #' @param min_cnt \code{int(required)}: minimum count of word in text.
    #' @param max_word_len \code{int(required)}: max word length.
    #' @param min_score \code{num(required)}: minimum score.
    #' @param pos_threshold \code{num(required)}: pos threashold.
    #' @param apply \code{bool(optional)}: apply extracted word as user word dict.
    extract_words =  function(input,
                              min_cnt,
                              max_word_len,
                              min_score,
                              pos_threshold,
                              apply = FALSE) {
      res <- kiwi_builder_extract_words_wrap(private$kiwi_builder,
                                  input,
                                  min_cnt,
                                  max_word_len,
                                  min_score,
                                  pos_threshold,
                                  apply)
      private$builder_updated <- TRUE
      return(res)
    },

    #' @description
    #'   Analyze text to token and tag results.
    #' @param text \code{char(required)}: target text.
    #' @param top_n \code{int(optional)}: number of result. Default is 3.
    #' @param match_option match_option [`Match`]: use Match. Default is Match$ALL
    #' @param stopwords stopwords option. Default is FALSE which is use nothing.
    #'                  If \code{TRUE}, use embaded stopwords dictionany.
    #'                  If \code{char}: path of dictionary txt file, use file.
    #'                  If [`Stopwords`] class, use it.
    #'                  If not valid value, work same as FALSE.
    #' @param blocklist \code{Morphset(optional)}: morpheme set to block from analysis results.
    #' @param pretokenized \code{Pretokenized(optional)}: pretokenized object for guided analysis.
    #' @return \code{list} of result.
    analyze = function(text,
                       top_n = 3,
                       match_option = Match$ALL,
                       stopwords = FALSE,
                       blocklist = NULL,
                       pretokenized = NULL) {
      if (any(private$kiwi_not_ready(), private$builder_updated))
        private$kiwi_build()

      kiwi_analyze_wrap(private$kiwi, text, top_n, match_option, stopwords, blocklist, pretokenized)
    },

    #' @description
    #'   Analyze text to token and pos result just top 1.
    #' @param text \code{char(required)}: target text.
    #' @param match_option match_option [`Match`]: use Match. Default is Match$ALL
    #' @param stopwords stopwords option. Default is FALSE which is use nothing.
    #'                  If \code{TRUE}, use embaded stopwords dictionany.
    #'                  If \code{char}: path of dictionary txt file, use file.
    #'                  If [`Stopwords`] class, use it.
    #'                  If not valid value, work same as FALSE.
    #' @param form \code{char(optional)}: return form. default is "tibble".
    #'                                     "list", "tidytext" is available.
    #' @importFrom purrr map map_chr map_int
    #' @importFrom dplyr bind_rows
    tokenize = function(text,
                        match_option = Match$ALL,
                        stopwords = FALSE,
                        form = "tibble") {
      form <- match.arg(form, c("tibble", "tidytext"))
      res <- purrr::map(
        text,
        ~ self$analyze(
          text = .x,
          top_n = 1,
          match_option = match_option,
          stopwords = stopwords
        )[[1]][1]
      )
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
        return(dplyr::bind_rows(raw, .id = "sent"))
      if (form == "tidytext")
        return(purrr::map(raw, ~ paste0(.x$form, "/", .x$tag)))
    },

    #' @description
    #' Some text may not split sentence by sentence.
    #' split_into_sents works split sentences to sentence by sentence.
    #'
    #' @param text \code{char(required)}: target text.
    #' @param match_option match_option [`Match`]: use Match. Default is Match$ALL
    #' @param return_tokens \code{bool(optional)}: add tokenized resault.
    split_into_sents = function(text,
                                match_option = Match$ALL,
                                return_tokens = FALSE) {
      if (any(private$kiwi_not_ready(), private$builder_updated))
        private$kiwi_build()

      kiwi_split_into_sents_(private$kiwi, text, match_option, return_tokens)
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
    #' @examples
    #' \dontrun{
    #'    kw <- Kiwi$new()
    #'    tidytoken <- kw$get_tidytext_func()
    #'    tidytoken("test")
    #' }
    #' @return \code{function}
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
    #'   Set typo correction settings for the Kiwi instance.
    #' @param enabled \code{bool(optional)}: enable or disable typo correction. Default is TRUE.
    #' @param cost_threshold \code{num(optional)}: cost threshold for typo correction. Default is 2.5.
    #' @param custom_typos \code{list(optional)}: list of custom typo corrections.
    #'   Each element should be a list with 'orig', 'error', and optionally 'cost' fields.
    #' @examples
    #' \dontrun{
    #'   kw <- Kiwi$new()
    #'   # Enable with default settings
    #'   kw$set_typo_correction(TRUE)
    #'   
    #'   # Enable with custom rules
    #'   custom_rules <- list(
    #'     list(orig = "안녕", error = "안뇽", cost = 1.0),
    #'     list(orig = "하세요", error = "하셰요", cost = 1.5)
    #'   )
    #'   kw$set_typo_correction(TRUE, cost_threshold = 3.0, custom_typos = custom_rules)
    #'   
    #'   # Disable typo correction
    #'   kw$set_typo_correction(FALSE)
    #' }
    set_typo_correction = function(enabled = TRUE, cost_threshold = 2.5, custom_typos = NULL) {
      # Validate parameters
      if (!is.logical(enabled) || length(enabled) != 1) {
        stop("'enabled' must be a single logical value")
      }
      
      if (!is.numeric(cost_threshold) || length(cost_threshold) != 1 || cost_threshold < 0) {
        stop("'cost_threshold' must be a single non-negative numeric value")
      }
      
      if (!is.null(custom_typos) && !is.list(custom_typos)) {
        stop("'custom_typos' must be a list or NULL")
      }
      
      if (enabled) {
        # Create typo corrector if custom rules are provided
        if (!is.null(custom_typos)) {
          private$typo_corrector <- kiwi_typo_init_()
          
          # Validate and add custom typo rules
          if (is.list(custom_typos)) {
            added_rules <- 0
            for (i in seq_along(custom_typos)) {
              typo <- custom_typos[[i]]
              
              # Validate typo rule structure
              if (!is.list(typo)) {
                warning(paste0("Skipping typo rule ", i, ": not a list"))
                next
              }
              
              if (!("orig" %in% names(typo)) || !("error" %in% names(typo))) {
                warning(paste0("Skipping typo rule ", i, ": missing 'orig' or 'error' field"))
                next
              }
              
              if (!is.character(typo$orig) || !is.character(typo$error) ||
                  length(typo$orig) != 1 || length(typo$error) != 1) {
                warning(paste0("Skipping typo rule ", i, ": 'orig' and 'error' must be single character strings"))
                next
              }
              
              cost <- if ("cost" %in% names(typo)) {
                if (!is.numeric(typo$cost) || length(typo$cost) != 1 || typo$cost < 0) {
                  warning(paste0("Invalid cost for typo rule ", i, ", using default 1.0"))
                  1.0
                } else {
                  typo$cost
                }
              } else {
                1.0
              }
              
              # Add the typo rule
              result <- kiwi_typo_add_(private$typo_corrector, typo$orig, typo$error, cost)
              if (result == 0) {
                added_rules <- added_rules + 1
              } else {
                warning(paste0("Failed to add typo rule: ", typo$orig, " -> ", typo$error))
              }
            }
            
            if (added_rules == 0) {
              warning("No valid typo rules were added")
            } else {
              message(paste0("Added ", added_rules, " typo correction rules"))
            }
          }
        } else {
          # Enable typo correction with default settings (no custom rules)
          private$typo_corrector <- NULL
        }
      } else {
        # Disable typo correction
        if (!is.null(private$typo_corrector)) {
          # Clean up existing typo corrector
          tryCatch({
            kiwi_typo_close_(private$typo_corrector)
          }, error = function(e) {
            # Handle may already be closed, ignore error
          })
        }
        private$typo_corrector <- NULL
      }
      
      private$typo_enabled <- enabled
      private$typo_cost_threshold <- cost_threshold
      private$builder_updated <- TRUE
      
      invisible(self)
    },

    #' @description
    #'   Get current typo correction settings.
    #' @return \code{list} with typo correction settings
    get_typo_correction_settings = function() {
      list(
        enabled = private$typo_enabled,
        cost_threshold = private$typo_cost_threshold,
        has_custom_rules = !is.null(private$typo_corrector)
      )
    },

    #' @description
    #'   Create a new morpheme set for blocking specific morphemes from analysis.
    #' @return \code{Morphset} object
    create_morphset = function() {
      # Ensure Kiwi instance is built before creating morphset
      if (any(private$kiwi_not_ready(), private$builder_updated))
        private$kiwi_build()
      
      # Create morphset handle using C++ binding
      morphset_handle <- kiwi_new_morphset_(private$kiwi)
      
      # Return new Morphset instance
      return(Morphset$new(morphset_handle))
    },

    #' @description
    #'   Create a new pretokenized object for guided analysis.
    #' @return \code{Pretokenized} object
    create_pretokenized = function() {
      # Create pretokenized handle using C++ binding
      pt_handle <- kiwi_pt_init_()
      
      # Return new Pretokenized instance
      return(Pretokenized$new(pt_handle))
    }

  ),

  private = list(
    kiwi = NULL,
    kiwi_builder = NULL,
    builder_updated = FALSE,

    save_user_dictionary = function(user_dict_path) {

    },

    # # type is user and extracted
    # word_list = tibble::tibble(type = character(),
    #                            word = character(),
    #                            tag = character(),
    #                            score = double(),
    #                            orig_word = character()),
    #
    # pre_analyzed_list = tibble::tibble(
    #                                   form = character(),
    #                                   analyzed = tibble::tibble(
    #                                               morphs = character(),
    #                                               tag = character(),
    #                                               start = integer(),
    #                                               end = integer()
    #                                               ),
    #                                   score = double()
    #                                   ),

    # dict_list = tibble::tibble(dict_name = character(),
    #                            info = character()),

    # history = tibble::tibble(method = character(),
    #                          info = list()),
    #
    # add_history = function(method_, info_) {
    #   private$history <- dplyr::bind_rows(
    #     private$history,
    #     tibble::tibble(method = method_, info = list(info_))
    #   )
    # },

    kiwi_not_ready = function() {
      is.null(private$kiwi)
    },

    kiwi_build = function() {
      # Use new API with typo correction parameters
      # Pass NULL for typos if not enabled or not set
      typos_param <- if (private$typo_enabled && !is.null(private$typo_corrector)) {
        private$typo_corrector
      } else {
        NULL
      }
      
      # Call new kiwi_builder_build_ API with typo correction parameters
      private$kiwi <- kiwi_builder_build_(private$kiwi_builder, 
                                          typos_param, 
                                          private$typo_cost_threshold)
      private$builder_updated <- FALSE
      
      # Check for build errors
      error_msg <- kiwi_error_wrap()
      if (!is.null(error_msg)) {
        stop("Failed to build Kiwi instance: ", error_msg)
      }
    },

    num_workers = NULL,
    model_path = NULL,
    model_size = NULL,
    build_options = NULL,
    typo_corrector = NULL,
    typo_enabled = FALSE,
    typo_cost_threshold = 2.5
  )
)
