kiwi_error_wrap <- function() {
  tr <- kiwi_error_()
  if (tr != "0") {
    kiwi_clear_error_()
    return(tr)
  }
  invisible(NULL)
}

kiwi_builder_extract_words_wrap <-
  function(handle_ex,
           input,
           min_cnt,
           max_word_len,
           min_score,
           pos_threshold,
           apply) {
    ext_func <- kiwi_builder_extract_words_
    if (apply) {
      ext_func <- kiwi_builder_extract_add_words_
    }
    purrr::map_dfr(
      ext_func(handle_ex,
               input,
               min_cnt,
               max_word_len,
               min_score,
               pos_threshold)
      , ~ tibble::tibble(
      form = .x$form,
      tag_score = .x$tag_score,
      freq = .x$freq,
      score = .x$score
    ))
  }

kiwi_analyze_wrap <-
  function(handle_ex,
           text,
           top_n = 3,
           match_option = Match$ALL,
           stopwords = FALSE) {
    if (isFALSE(stopwords)) {
      sw <- Stopwords$new(use_system_dict = FALSE)
    } else if (isTRUE(stopwords)) {
      sw <- Stopwords$new()
    } else if (any(class(stopwords) == "Stopwords")) {
      sw <- stopwords
    } else if (is.character(stopwords) && length(stopwords) == 1 && file.exists(stopwords)) {
      sw <- Stopwords$new(FALSE)$add_from_dict(stopwords)
    } else {
      sw <- Stopwords$new(use_system_dict = FALSE)
    }

    # Convert blocklist and pretokenized to appropriate format for C++ binding
    blocklist_ex <- NULL
    pretokenized_ex <- NULL
    
    if (!is.null(blocklist)) {
      # Assume blocklist is a Morphset R6 object with get_handle() method
      if (inherits(blocklist, "Morphset")) {
        blocklist_ex <- blocklist$get_handle()
      } else {
        warning("blocklist must be a Morphset object, ignoring")
      }
    }
    
    if (!is.null(pretokenized)) {
      # Assume pretokenized is a Pretokenized R6 object with get_handle() method
      if (inherits(pretokenized, "Pretokenized")) {
        pretokenized_ex <- pretokenized$get_handle()
      } else {
        warning("pretokenized must be a Pretokenized object, ignoring")
      }
    }

    res <- kiwi_analyze_(handle_ex,
                         text,
                         top_n,
                         match_option,
                         sw$get(),
                         blocklist_ex,
                         pretokenized_ex)
    if (length(res) == 0) {
      return(kiwi_error_wrap())
    }
    return(res)
  }
