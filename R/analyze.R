#' analyze
#'
#' @param text target text.
#' @param top_n Number of result. default is 1.
#'
#' @name analyze
#' @importFrom purrr map
#' @importFrom tibble tibble
#' @importFrom reticulate iter_next
#' @export
analyze <- function(text, top_n = 1) {
  if (init_chk_not()) init()
  el <- get("el", envir = .el)
  top_n <- as.integer(top_n)
  iter <- el$analyze(text, top_n)
  res <- c()
  while (TRUE) {
    item <- reticulate::iter_next(iter, completed = NA)
    if (is.na(item))
      break
    res <- c(res, list(item[[1]][[1]]))
  }
  return(res)
}

#' @export
#' @rdname analyze
#' @return a [tibble][tibble::tibble-package]
analyze_tbl <- function(text, top_n = 1) {
  res <- analyze(text, top_n = 1)
  res <- purrr::map(
    res,
    ~ tibble::tibble(
      morph = purrr::map_chr(.x, ~ .x[0]),
      tag = purrr::map_chr(.x, ~ .x[1]),
      start = purrr::map_int(.x, ~ .x[2]),
      end = purrr::map_int(.x, ~ .x[3]),
    )
  )
  return(res)
}


#' @export
#' @rdname analyze
analyze_tidytext <- function(text, top_n = 1) {
  res <- analyze_tbl(text, top_n = 1)
  res <- purrr::map(res, ~
                      paste0(.x$morph, "/", .x$tag))
  return(res)
}

#' @export
#' @rdname analyze
analyze_tt <- analyze_tidytext

#' @export
#' @rdname analyze
analyze_tidy <- analyze_tidytext

