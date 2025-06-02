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

    res <- kiwi_analyze_(handle_ex,
                         text,
                         top_n,
                         match_option,
                         sw$get())
    if (length(res) == 0) {
      return(kiwi_error_wrap())
    }
    return(res)
  }
