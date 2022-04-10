init_chk_not <- function() {
  length(ls(envir = .el)) != 1
}

init <- function(size = "small") {
  if (!kiwi_model_exists(size))
    get_kiwi_models(size)

  kw <- kiwi_init_(kiwi_model_path_full(size), 0, BuildOpt$DEFAULT)
  err <- kiwi_error_wrap()

  if (!is.null(err))
    stop(err)

  assign("kw", kw, envir = .el)
}



