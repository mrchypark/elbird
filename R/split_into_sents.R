#' split_into_sents
#'
#' @param text target text.
#' @param return_tokens add tokenized resault.
#' @export
split_into_sents <- function(text, return_tokens = FALSE) {
  if (init_chk_not())
    init()

  return (
    kiwi_split_into_sents_(
      get("kb", envir = .el),
      text,
      1,
      return_tokens
    )
  )
}
