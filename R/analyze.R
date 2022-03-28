#' analyze
#'
#' @param text  \code{character}: target text.
#' @param top_n  \code{integer}: Number of result. Default is 3.
#' @param match_option [`Match`]: use Match. Default is Match$ALL
#' @param stopwords stopword option. Default is FALSE.
#'                  If TRUE, use embaded stopwords dictionany.
#'                  If char: path of dictionary txt file, use file.
#'                  If [`Stopwords`] class, use it.
#' @name analyze
#' @examples
#'   analyze("안녕하세요")
#'   analyze("안녕하세요", 1)
#'   analyze("안녕하세요", 1, Match$ALL_WITH_NORMALIZING)
#'   analyze("안녕하세요", stopwords = FALSE)
#'   analyze("안녕하세요", stopwords = TRUE)
#'   analyze("안녕하세요", stopwords = "user_dict.txt")
#'   analyze("안녕하세요", stopwords = "user_dict.txt")
#'   analyze("안녕하세요", stopwords = Stopwords$new(TRUE))
#'   analyze("안녕하세요", stopwords = Stopwords$new(TRUE)$add("test","NNP"))
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
