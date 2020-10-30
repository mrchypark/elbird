#' Add user word dic
#'
#' @param word word
#' @param pos   pos
#' @param score score
#'
#' @export
add_user_word <- function(word, pos, score){
  el <- get("el", envir = .el)
  el$add_user_word(word, pos, score)
  el$prepare()
  assign("el", el, envir = .el)
}

#' @importFrom purrr map
#' @export
analyze <- function(text, top_n = 1) {
  el <- get("el", envir = .el)
  top_n <- as.integer(top_n)
  purrr::map(
    text, ~ el$analyze(.x, top_n)
  ) -> res
  return(res)
}

