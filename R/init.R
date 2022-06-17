init_chk_not <- function() {
  length(ls(envir = .el)) != 1
}

#' Initialize model for function api
#'
#' @param num_workers \code{int(optional)}: use multi-thread core number. default is 0 which means use all core.
#' @param model_size \code{char(optional)}: kiwi model select. default is "base". "small", "large" is available.
#' @param integrate_allomorph \code{bool(optional)}: default is TRUE.
#' @param load_default_dict \code{bool(optional)}: use defualt dictionary. default is TRUE.
#' @export
init <- function(num_workers = 0,
                 model_size = "base",
                 integrate_allomorph = TRUE,
                 load_default_dict = TRUE) {
  kw <- Kiwi$new(
    num_workers,
    model_size,
    integrate_allomorph,
    load_default_dict
  )

  assign("kw", kw, envir = .el)
}
