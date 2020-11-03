#' Extract unregistered words from corpus provided user.
#'
#' @param word target word
#' @param pos   pos
#' @param score score
#'
#' @export
extract_words <- function(reader,
                          min_cnt = 10,
                          max_word_len = 10,
                          min_score = 0.25) {
  if (init_chk_not())
    init()

}


#' Extract unregistered words from corpus provided user.
#'
#' @param word target word
#' @param pos   pos
#' @param score score
#'
#' @export
extract_filter_words <- function(reader,
                                 min_cnt = 10,
                                 max_word_len = 10,
                                 min_score = 0.25,
                                 pos_score = -3) {
  if (init_chk_not())
    init()

}

#' Extract unregistered words from corpus provided user.
#'
#' @param word target word
#' @param pos   pos
#' @param score score
#'
#' @export
extract_add_words <- function(reader,
                              min_cnt = 10,
                              max_word_len = 10,
                              min_score = 0.25,
                              pos_score = -3) {
  if (init_chk_not())
    init()

}
