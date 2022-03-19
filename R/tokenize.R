#' Simple version of tokenizer function.
#'
#' @param text target text.
#' @name tokenize
#' @importFrom purrr map
#' @return a list type resault.
#' @export
tokenize <- function(text) {
  if (init_chk_not())
    init()

  return(purrr::map(
    text,
    ~ kiwi_analyze_(get("kb", envir = .el), .x, 1, 1)[[1]][1]
    )
  )
}

#' @export
#' @importFrom dplyr bind_rows
#' @rdname tokenize
#' @return a [tibble][tibble::tibble-package]
tokenize_tibble <- function(text) {
  res <- tokenize_raw(text)
  return(dplyr::bind_rows(res, .id = "unique"))
}

#' @export
#' @importFrom purrr map
#' @rdname tokenize
tokenize_tidytext <- function(text) {
  res <- tokenize_raw(text)
  purrr::map(res, ~ paste0(.x$form, "/", .x$tag))
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
