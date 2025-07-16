#' Simple version of analyze function.
#'
#' @param text target text.
#' @param top_n  \code{integer}: Number of result. Default is 3.
#' @param match_option [`Match`]: use Match. Default is Match$ALL
#' @param stopwords stopwords option. Default is FALSE which is use nothing.
#'                  If \code{TRUE}, use embaded stopwords dictionany.
#'                  If \code{char}: path of dictionary txt file, use file.
#'                  If [`Stopwords`] class, use it.
#'                  If not valid value, work same as FALSE.
#' @param blocklist \code{Morphset(optional)}: morpheme set to block from analysis results. Default is NULL.
#' @param pretokenized \code{Pretokenized(optional)}: pretokenized object for guided analysis. Default is NULL.
#' @examples
#' \dontrun{
#'   analyze("Test text.")
#'   analyze("Please use Korean.", top_n = 1)
#'   analyze("Test text.", 1, Match$ALL_WITH_NORMALIZING)
#'   analyze("Test text.", stopwords = FALSE)
#'   analyze("Test text.", stopwords = TRUE)
#'   analyze("Test text.", stopwords = "user_dict.txt")
#'   analyze("Test text.", stopwords = Stopwords$new(TRUE))
#'   
#'   # New features with Kiwi v0.21.0
#'   kw <- Kiwi$new()
#'   morphset <- kw$create_morphset()
#'   analyze("Test text.", blocklist = morphset)
#' }
#' @export
analyze <-
  function(text,
           top_n = 3,
           match_option = Match$ALL,
           stopwords = FALSE,
           blocklist = NULL,
           pretokenized = NULL) {
    if (init_chk_not())
      init()

    kiwi_analyze_wrap(
      get("kw", envir = .el),
      text,
      top_n,
      match_option,
      stopwords,
      blocklist,
      pretokenized
    )
  }
