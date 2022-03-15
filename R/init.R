init_check <- function() {
  length(ls(envir=.el)) > 0
}

init <- function() {
  kb <- kiwi_builder(file.path(model_path(), "ModelGenerator"))
}
