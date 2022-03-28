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

    kiwi_analyze_wrap(
      get("kb", envir = .el),
      text,
      top_n,
      match_option,
      stopwords
    )
  }
