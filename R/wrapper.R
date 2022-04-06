kiwi_error_wrap <- function() {
  tr <- kiwi_error_()
  if (tr != "0") {
    kiwi_clear_error_()
    return(tr)
  }
  invisible()
}

kiwi_analyze_wrap <-
  function(handle_ex,
           text,
           top_n = 3,
           match_option = Match$ALL,
           stopwords = FALSE) {

    sw <- purrr::when(
      stopwords,
      isFALSE(.) ~ Stopwords$new(use_system_dict = FALSE),
      isTRUE(.) ~ Stopwords$new(),
      any(class(.) == "Stopwords") ~ .,
      file.exists(.) ~ Stopwords$new(FALSE)$add_from_dict(.),
      ~ Stopwords$new(use_system_dict = FALSE)
    )

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