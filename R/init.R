init_chk_not <- function() {
  length(ls(envir = .el)) != 1
}

kiwi_init_chk <- function(kb) {
  if (identical(kb, new("externalptr"))) {
    tem <- kiwi_error_()
    kiwi_clear_error_()
    stop(tem)
  }
}

#' @importFrom methods new
init <- function() {
  if (!model_check())
    get_model_file()

  kb <- kiwi_init_(model_path_full(), 0, 0)
  kiwi_init_chk(kb)
  assign("kb", kb, envir = .el)
}
