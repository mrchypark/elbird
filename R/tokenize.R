#' tokenize
#'
#' @param text target text.
#'
#' @name tokenize
#' @importFrom purrr map
#' @importFrom tibble tibble
#' @importFrom reticulate iter_next
#' @export
tokenize <- function(text) {
  if (init_chk_not()) init()
  el <- get("el", envir = .el)
  res <- purrr::map(text, ~ el$tokenize(.x))
  return(res)
}

#' @export
#' @rdname tokenize
#' @return a [tibble][tibble::tibble-package]
tokenize_tbl <- function(text) {
  res <- tokenize(text)
  res <- purrr::map(
    res,
    ~ tibble::tibble(
      morph = purrr::map_chr(.x, ~ .x[0]),
      tag = purrr::map_chr(.x, ~ .x[1]),
      start = purrr::map_int(.x, ~ .x[2]),
      end = purrr::map_int(.x, ~ .x[3]),
    )
  )
  return(dplyr::bind_rows(res, .id = "unique"))
}


#' @export
#' @rdname tokenize
tokenize_tidytext <- function(text) {
  res <- tokenize_tbl(text)
  res <- purrr::map(res, ~
                      paste0(.x$morph, "/", .x$tag))
  return(res)
}

#' @export
#' @rdname tokenize
tokenize_tt <- tokenize_tidytext

#' @export
#' @rdname tokenize
tokenize_tidy <- tokenize_tidytext

