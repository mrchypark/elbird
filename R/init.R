init_chk_not <- function() {
  length(ls(envir=.el)) != 2
}

init <- function() {
  kb <- Kiwi_Builder(model_path_full())
  el <- Kiwi_Builder_build(kb)
  assign("kb", kb, envir = .el)
  assign("el", el, envir = .el)
}
