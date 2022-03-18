init_chk_not <- function() {
  length(ls(envir=.el)) != 1
}

init <- function() {
  kb <- kiwi_init(model_path_full())
  assign("kb", kb, envir = .el)
}
