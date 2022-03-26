#' analyze
#'
#' @param text target text.
#' @param top_n Number of result. default is 3.
#' @name analyze
#' @export
analyze <- function(text, top_n = 3, match_option = Match$ALL, stopwords = FALSE) {
  if (init_chk_not())
    init()

  sw <- purrr::when(
    stopwords,
    isFALSE(.) ~ "false",  # Stopwords$new(empty = TRUE),
    isTRUE(.) ~ "true", #Stopwords$new(),
    any(class(.) == "Stopwords") ~ .,
    file.exists(.) ~ "path",
    ~ "last"
  )

  kiwi_analyze_(
    get("kb", envir = .el),
    text,
    top_n,
    match_option
    # sw$get()
  ) -> res
}
