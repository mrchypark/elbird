#' analyze
#'
#' @param text target text.
#' @param top_n Number of result. default is 3.
#' @param match_option use Match.
#' @param stopwords
#' @name analyze
#' @export
analyze <-
  function(text,
           top_n = 3,
           match_option = Match$ALL,
           stopwords = FALSE) {
    if (init_chk_not())
      init()

    sw <- purrr::when(
      stopwords,
      isFALSE(.) ~ Stopwords$new(use_system_dict = FALSE),
      isTRUE(.) ~ Stopwords$new(),
      any(class(.) == "Stopwords") ~ .,
      file.exists(.) ~ Stopwords$new()$add_from_dict(.),
      ~ Stopwords$new(use_system_dict = FALSE)
    )

    kiwi_analyze_(get("kb", envir = .el),
                  text,
                  top_n,
                  match_option,
                  sw$get()) -> res
  }
