#' Simple version of tokenizer function.
#'
#' @param text target text.
#' @param match_option [`Match`]: use Match. Default is Match$ALL
#' @param stopwords stopwords option. Default is TRUE which is
#'                  to use embaded stopwords dictionany.
#'                  If FALSE, use not embaded stopwords dictionany.
#'                  If char: path of dictionary txt file, use file.
#'                  If [`Stopwords`] class, use it.
#'                  If not valid value, work same as FALSE.
#'                  Check [analyze()] how to use stopwords param.
#' @param blocklist \code{Morphset(optional)}: morpheme set to block from analysis results. Default is NULL.
#' @param pretokenized \code{Pretokenized(optional)}: pretokenized object for guided analysis. Default is NULL.
#' @param normalize_coda \code{bool(optional)}: apply coda normalization. Default is FALSE.
#' @param typos \code{bool(optional)}: enable typo correction. Default is NULL (keep current).
#' @param typo_cost_threshold \code{num(optional)}: typo correction cost threshold. Default is 2.5.
#' @param open_ending \code{bool(optional)}: keep sentence open after last morpheme. Default is FALSE.
#' @param allowed_dialects \code{Dialect(optional)}: allowed dialects for analysis. Default is Dialect$STANDARD.
#' @param dialect_cost \code{num(optional)}: cost added to dialect morphemes. Default is 3.0.
#' @importFrom purrr map
#' @returns list type of result.
#' @export
#' @examples
#' \dontrun{
#' tokenize("Test text.")
#' tokenize("Please use Korean.", Match$ALL_WITH_NORMALIZING)
#'
#' # New features with Kiwi v0.21.0
#' kw <- Kiwi$new()
#' morphset <- kw$create_morphset()
#' tokenize("Test text.", blocklist = morphset)
#' }
#' @name tokenize
NULL

#' @rdname tokenize
#' @export
#' @importFrom dplyr bind_rows
tokenize <- function(text,
                     match_option = Match$ALL,
                     stopwords = TRUE,
                     blocklist = NULL,
                     pretokenized = NULL,
                     normalize_coda = FALSE,
                     typos = NULL,
                     typo_cost_threshold = 2.5,
                     open_ending = FALSE,
                     allowed_dialects = Dialect$STANDARD,
                     dialect_cost = 3.0) {
  dplyr::bind_rows(
    tokenize_raw(
      text,
      match_option,
      stopwords,
      blocklist,
      pretokenized,
      normalize_coda,
      typos,
      typo_cost_threshold,
      open_ending,
      allowed_dialects,
      dialect_cost
    ),
    .id = "sent"
  )
}

#' @rdname tokenize
#' @export
tokenize_tbl <- tokenize

#' @rdname tokenize
#' @export
#' @importFrom purrr map
tokenize_tidytext <- function(text,
                              match_option = Match$ALL,
                              stopwords = TRUE,
                              blocklist = NULL,
                              pretokenized = NULL,
                              normalize_coda = FALSE,
                              typos = NULL,
                              typo_cost_threshold = 2.5,
                              open_ending = FALSE,
                              allowed_dialects = Dialect$STANDARD,
                              dialect_cost = 3.0) {
  purrr::map(
    tokenize_raw(
      text,
      match_option,
      stopwords,
      blocklist,
      pretokenized,
      normalize_coda,
      typos,
      typo_cost_threshold,
      open_ending,
      allowed_dialects,
      dialect_cost
    ),
    ~ paste0(.x$form, "/", .x$tag)
  )
}

#' @rdname tokenize
#' @export
tokenize_tidy <- tokenize_tt <- tokenize_tidytext

#' @importFrom purrr map_chr map_int
tokenize_raw <- function(text,
                         match_option,
                         stopwords,
                         blocklist = NULL,
                         pretokenized = NULL,
                         normalize_coda = FALSE,
                         typos = NULL,
                         typo_cost_threshold = 2.5,
                         open_ending = FALSE,
                         allowed_dialects = Dialect$STANDARD,
                         dialect_cost = 3.0) {
  if (is.null(text)) {
    stop("text cannot be NULL")
  }
  if (!is.character(text)) {
    stop("text must be character")
  }
  match_option <- normalize_match_option(match_option, normalize_coda)
  purrr::map(
    purrr::map(
      text,
      ~ analyze(
        text = .x,
        top_n = 1,
        match_option = match_option,
        stopwords = stopwords,
        blocklist = blocklist,
        pretokenized = pretokenized,
        typos = typos,
        typo_cost_threshold = typo_cost_threshold,
        open_ending = open_ending,
        allowed_dialects = allowed_dialects,
        dialect_cost = dialect_cost
      )[[1]][1]
    ),
    ~ tibble::tibble(
      form = purrr::map_chr(.x$Token, ~ .x$form),
      tag = purrr::map_chr(.x$Token, ~ .x$tag),
      start = purrr::map_int(.x$Token, ~ .x$start),
      len = purrr::map_int(.x$Token, ~ .x$len),
    )
  )
}
