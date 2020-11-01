#' analyze
#'
#' @param text target text.
#' @param top_n Number of result. default is 1.
#'
#' @name analyze
#' @importFrom purrr map
#' @export
analyze <- function(text, top_n = 1) {
  if(init_chk_not()) init()
  el <- get("el", envir = .el)
  elp <- get("elp", envir = .el)
  if (elp == 0) {
    el$prepare()
    assign("elp", 1, envir = .el)
  }
  top_n <- as.integer(top_n)
  res <- purrr::map(text, ~ el$async_analyze(.x, top_n)()[[1]][[1]])
  return(res)
}

#' @export
#' @rdname analyze
#' @return a [tibble][tibble::tibble-package]
analyze_tbl <- function(text, top_n = 1) {
  res <- analyze(text, top_n = 1)
  res <- purrr::map(
    res,
    ~ tibble(
      morph = purrr::map_chr(.x, ~ .x[[1]]),
      tag = purrr::map_chr(.x, ~ .x[[2]]),
      start = purrr::map_int(.x, ~ .x[[3]]),
      end = purrr::map_int(.x, ~ .x[[4]]),
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

