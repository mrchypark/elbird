
init_chk_not <- function() {
  length(ls(envir=.el)) != 1
}

#' @importFrom methods new
init <- function() {
  kb <- kiwi_init(model_path_full(), 0, 0)
  if (identical(kb, new("externalptr"))) {
    tem <- kiwi_error()
    kiwi_clear_error()
    stop(tem)
  }

  assign("kb", kb, envir = .el)
}
