#' Simple version of tokenizer function.
#'
#' @param text target text.
#' @param match_options
#' @param stopwords
#' @name tokenize
#' @importFrom purrr map
#' @return a list type resault.
#' @export
#' @examples
#'   tokenize("안녕하세요")
tokenize <-
  function(text,
           match_option = Match$ALL,
           stopwords = FALSE) {

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

#' @export
#' @importFrom dplyr bind_rows
#' @rdname tokenize
#' @return a [tibble][tibble::tibble-package]
tokenize_tibble <- function(text) {
  dplyr::bind_rows(tokenize_raw(text), .id = "unique")
}

#' @export
#' @importFrom purrr map
#' @rdname tokenize
tokenize_tidytext <- function(text) {
  purrr::map(tokenize_raw(text), ~ paste0(.x$form, "/", .x$tag))
}


#' @export
#' @rdname tokenize
tokenize_tbl <- tokenize_tibble

#' @export
#' @rdname tokenize
tokenize_tt <- tokenize_tidytext

#' @export
#' @rdname tokenize
tokenize_tidy <- tokenize_tidytext

#' @importFrom purrr map_chr map_int
tokenize_raw <- function(text) {
  res <- tokenize(text)
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
