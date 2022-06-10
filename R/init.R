init_chk_not <- function() {
  length(ls(envir = .el)) != 1
}

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
