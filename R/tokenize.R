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
#' @importFrom purrr map
#' @returns list type of result.
#' @export
#' @examples
#' \dontrun{
#'   tokenize("Test text.")
#'   tokenize("Please use Korean.", Match$ALL_WITH_NORMALIZING)
#'   
#'   # New features with Kiwi v0.21.0
#'   kw <- Kiwi$new()
#'   morphset <- kw$create_morphset()
#'   tokenize("Test text.", blocklist = morphset)
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
                     pretokenized = NULL) {
  dplyr::bind_rows(tokenize_raw(text, match_option, stopwords, blocklist, pretokenized), .id = "sent")
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
                              pretokenized = NULL) {
  purrr::map(tokenize_raw(text, match_option, stopwords, blocklist, pretokenized),
             ~ paste0(.x$form, "/", .x$tag))
}

#' @rdname tokenize
#' @export
tokenize_tidy <- tokenize_tt <- tokenize_tidytext

#' @importFrom purrr map_chr map_int
tokenize_raw <- function(text, match_option, stopwords, blocklist = NULL, pretokenized = NULL) {
  purrr::map(
    purrr::map(
      text,
      ~ analyze(
        text = .x,
        top_n = 1,
        match_option = match_option,
        stopwords = stopwords,
        blocklist = blocklist,
        pretokenized = pretokenized
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
