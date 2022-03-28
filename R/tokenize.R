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
#' @importFrom purrr map
#' @return a list type resault.
#' @export
#' @examples
#'   tokenize("Test text.")
#'   tokenize("Please use Korean.", Match$ALL_WITH_NORMALIZING)
tokenize <-
  function(text,
           match_option = Match$ALL,
           stopwords = TRUE) {
    return(purrr::map(
      text,
      ~ analyze(
        text = .x,
        top_n = 1,
        match_option = match_option,
        stopwords = stopwords
      )[[1]][1]
    ))
  }

#' Tokenize funtion whit return tibble form
#'
#' Please check [tokenize()] docs.
#'
#' @export
#' @importFrom dplyr bind_rows
#' @rdname tokenize_tibble
#' @return a [tibble][tibble::tibble-package]
tokenize_tibble <- function(text,
                            match_option = Match$ALL,
                            stopwords = FALSE) {
  dplyr::bind_rows(tokenize_raw(text, match_option, stopwords), .id = "unique")
}

#' Tokenize funtion whit return list form to use tidytext
#'
#' Please check [tokenize()] docs.
#'
#' @export
#' @importFrom purrr map
#' @rdname tokenize_tidytext
#' @return a list can use with [unnest_tokens][tidytext::tidytext-package].
tokenize_tidytext <- function(text,
                              match_option = Match$ALL,
                              stopwords = FALSE) {
  purrr::map(tokenize_raw(text, match_option, stopwords),
             ~ paste0(.x$form, "/", .x$tag))
}


#' @export
#' @rdname tokenize_tibble
tokenize_tbl <- tokenize_tibble

#' @export
#' @rdname tokenize_tidytext
tokenize_tt <- tokenize_tidytext

#' @export
#' @rdname tokenize_tidytext
tokenize_tidy <- tokenize_tidytext

#' @importFrom purrr map_chr map_int
tokenize_raw <- function(text, match_option, stopwords) {
  res <- tokenize(text, match_option, stopwords)
  purrr::map(
    res,
    ~ tibble::tibble(
      form = purrr::map_chr(.x$Token, ~ .x$form),
      tag = purrr::map_chr(.x$Token, ~ .x$tag),
      start = purrr::map_int(.x$Token, ~ .x$start),
      len = purrr::map_int(.x$Token, ~ .x$len),
    )
  )
}
