#' analyze
#'
#' @param text target text.
#' @param top_n Number of result. default is 3.
#'
#' @name analyze
#' @importFrom purrr map
#' @importFrom tibble tibble
#' @importFrom reticulate iter_next
#' @export
analyze <- function(text, top_n = 3) {
  if (init_chk_not()) init()
  el <- get("el", envir = .el)
  top_n <- as.integer(top_n)
  iter <- el$analyze(text, top_n)
  if (is.list(iter)){
    res <- iter
  } else {
    res <- c()
    while (TRUE) {
      item <- reticulate::iter_next(iter, completed = NA)
      if (is.na(item))
        break
      res <- c(res, item)
    }
  }
  return(res)
}

