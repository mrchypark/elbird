#' analyze
#'
#' @param text target text.
#' @param top_n Number of result. default is 3.
#' @name analyze
#' @export
analyze <- function(text, top_n = 3) {
  if (init_chk_not()) init()
  kb <- get("kb", envir = .el)
  top_n <- as.integer(top_n)
  return(kiwi_analyze(kb, text, top_n, 1))
}
