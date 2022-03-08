#' Add user word to dictionary
#'
#' @param word target word
#' @param pos   pos
#' @param score score
#'
#' @importFrom dplyr bind_rows
#' @export
add_user_word <- function(word, pos, score) {
  if (init_chk_not())
    init()
  dict_history <- get("dict_history", envir = .el)
  dict_history[["word"]] <- dplyr::bind_rows(dict_history[["word"]],
                                             list(
                                               word = word,
                                               pos = pos,
                                               score = score
                                             ))
  assign("dict_history", dict_history, envir = .el)
  latest_el()
}

#' Read user dictionary data
#'
#' @param path dictionary file path.
#'
#' @export
read_user_dict <- function(path) {
  if (init_chk_not())
    init()
  dict_history <- get("dict_history", envir = .el)
  dict_history[["path"]] <- c(dict_history[["path"]], path)
  assign("dict_history", dict_history, envir = .el)
  latest_el()
}

#' Export user dictionary data
#'
#' @param path dictionary
#'
#' @importFrom readr write_tsv
#' @export
export_user_word_to_dictionary <- function(path) {
  if (init_chk_not())
    init()
  dict_history <- get("dict_history", envir = .el)
  readr::write_tsv(dict_history[["word"]], path)
}

#' @importFrom purrr map transpose
latest_el <- function() {
  kiwi <- get("kiwi", envir = .el)
  dict_history <- get("dict_history", envir = .el)
  el <- kiwi$Kiwi()
  if (nrow(dict_history[["word"]]) != 0) {
    purrr::map(purrr::transpose(dict_history[["word"]]),
               ~ el$add_user_word(.x$word,
                                  .x$pos,
                                  .x$score))
  }
  if (length(dict_history[["path"]]) != 0) {
    purrr::map(dict_history[["path"]],
               ~ el$load_user_dictionary(.x))
  }
  assign("el", el, envir = .el)
  assign("elp", 0, envir = .el)
}
