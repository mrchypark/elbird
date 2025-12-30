init_chk_not <- function() {
  length(ls(envir = .el)) != 1
}

init <- function(size = "base") {
  if (!kiwi_model_exists(size)) {
    get_kiwi_models(size)
  }

  kw <- Kiwi$new(model_size = size)
  assign("kw", kw, envir = .el)
}
