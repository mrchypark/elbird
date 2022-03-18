#' @useDynLib elbird kiwi_version_
kiwi_version <- function() .Call(kiwi_version_)

#' @useDynLib elbird kiwi_error_
kiwi_error <- function() .Call(kiwi_error_)

#' @useDynLib elbird kiwi_clear_error_
kiwi_clear_error <- function() .Call(kiwi_clear_error_)

#' @useDynLib elbird kiwi_init_
kiwi_init <- function(model_path, num_threads, options) {
  .Call(kiwi_init_, model_path, num_threads, options)
}

#' @useDynLib elbird kiwi_analyze_
kiwi_analyze <- function(handle, text, top_n, match_options) {
  .Call(kiwi_analyze_, handle, text, top_n, match_options)
}
