#' Split Sentences
#'
#' Some text may not split sentence by sentence.
#' split_into_sents works split sentences to sentence by sentence.
#'
#' @param text target text.
#' @param return_tokens add tokenized resault.
#' @examples
#' \dontrun{
#'  split_into_sents("text")
#'  split_into_sents("text", return_tokens = TRUE)
#' }
#' @export
split_into_sents <- function(text, return_tokens = FALSE) {
  if (init_chk_not())
    init()

  return(
    kiwi_split_into_sents_(
      get("kw", envir = .el),
      text,
      Match$ALL_WITH_NORMALIZING,
      return_tokens
    )
  )
}
