#' analyze
#'
#' @param text target text.
#' @param top_n Number of result. default is 3.
#' @name analyze
#' @export
analyze <- function(text, top_n = 3) {
  if (init_chk_not())
    init()

  return(
    kiwi_analyze_(
      get("kb", envir = .el),
      text,
      top_n,
      1
    )
  )
}
