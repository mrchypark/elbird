#' Simple version of analyze function.
#'
#' @param top_n  \code{integer}: Number of result. Default is 3.
#' @inheritParams tokenize
#' @examples
#' \dontrun{
#'   analyze("Test text.")
#'   analyze("Please use Korean.", top_n = 1)
#'   analyze("Test text.", 1, Match$ALL_WITH_NORMALIZING)
#'   analyze("Test text.", stopwords = FALSE)
#'   analyze("Test text.", stopwords = TRUE)
#'   analyze("Test text.", stopwords = "user_dict.txt")
#'   analyze("Test text.", stopwords = Stopwords$new(TRUE))
#' }
#' @export
analyze <-
  function(text,
           top_n = 3,
           match_option = Match$ALL,
           stopwords = FALSE) {
    if (init_chk_not())
      init()

    kiwi_analyze_wrap(
      get("kw", envir = .el),
      text,
      top_n,
      match_option,
      stopwords
    )
  }
