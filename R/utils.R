init <- function(){
  kiwi <- reticulate::import("kiwipiepy")
  el <- kiwi$Kiwi()
  dict_history <- list()
  dict_history[["word"]] <-
    dplyr::tibble(word = character(),
                  pos = character(),
                  score = integer())
  dict_history[["path"]] <- c()
  assign("kiwi", kiwi, envir = .el)
  assign("el", el, envir = .el)
  assign("elp", 0, envir = .el)
  assign("dict_history", dict_history, envir = .el)
}

init_chk_not <- function(){
  length(ls(envir=.el)) != 4
}
