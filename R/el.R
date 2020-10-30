#' Add user word dic
#'
#' @param word word
#' @param pos   pos
#' @param score score
#'
#' @export
add_user_word <- function(word, pos, score) {
  el <- get("el", envir = .el)
  el$add_user_word(word, pos, score)
  assign("el", el, envir = .el)
}

#' analyze
#'
#' @param text target text.
#' @param top_n Number of result. default is 1.
#'
#' @name analyze
#' @importFrom purrr map
#' @export
analyze <- function(text, top_n = 1) {
  el <- get("el", envir = .el)
  el$prepare()
  top_n <- as.integer(top_n)
  res <- purrr::map(
    text, ~ el$async_analyze(.x, top_n)()[[1]][[1]]
  )
  return(res)
}

#' @export
#' @rdname analyze
#' @return a [tibble][tibble::tibble-package]
analyze_tbl <- function(text, top_n = 1) {
  res <- analyze(text, top_n = 1)
  res <- purrr::map(
    res, ~ tibble(
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
  res <- purrr::map(
    res, ~
    paste0(.x$morph, "/", .x$tag)
  )
  return(res)
}


#' @export
#' @rdname analyze
analyze_tt <- analyze_tidytext
