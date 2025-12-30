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
#' @param normalize_coda \code{bool(optional)}: apply coda normalization. Default is FALSE.
#' @param typos \code{bool(optional)}: enable typo correction. Default is NULL (keep current).
#' @param typo_cost_threshold \code{num(optional)}: typo correction cost threshold. Default is 2.5.
#' @param open_ending \code{bool(optional)}: keep sentence open after last morpheme. Default is FALSE.
#' @param allowed_dialects \code{Dialect(optional)}: allowed dialects for analysis. Default is Dialect$STANDARD.
#' @param dialect_cost \code{num(optional)}: cost added to dialect morphemes. Default is 3.0.
#' @examples
#' \dontrun{
#' analyze("Test text.")
#' analyze("Please use Korean.", top_n = 1)
#' analyze("Test text.", 1, Match$ALL_WITH_NORMALIZING)
#' analyze("Test text.", stopwords = FALSE)
#' analyze("Test text.", stopwords = TRUE)
#' analyze("Test text.", stopwords = "user_dict.txt")
#' analyze("Test text.", stopwords = Stopwords$new(TRUE))
#'
#' # New features with Kiwi v0.21.0
#' kw <- Kiwi$new()
#' morphset <- kw$create_morphset()
#' analyze("Test text.", blocklist = morphset)
#' }
#' @export
analyze <-
  function(text,
           top_n = 3,
           match_option = Match$ALL,
           stopwords = FALSE,
           blocklist = NULL,
           pretokenized = NULL,
           normalize_coda = FALSE,
           typos = NULL,
           typo_cost_threshold = 2.5,
           open_ending = FALSE,
           allowed_dialects = Dialect$STANDARD,
           dialect_cost = 3.0) {
    if (init_chk_not()) {
      init()
    }
    kw <- get("kw", envir = .el)
    kw$analyze(
      text = text,
      top_n = top_n,
      match_option = match_option,
      stopwords = stopwords,
      blocklist = blocklist,
      pretokenized = pretokenized,
      normalize_coda = normalize_coda,
      typos = typos,
      typo_cost_threshold = typo_cost_threshold,
      open_ending = open_ending,
      allowed_dialects = allowed_dialects,
      dialect_cost = dialect_cost
    )
  }
