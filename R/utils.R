kiwi_ready <- function() {
  if (init_chk_not()) init()
  el <- get("el", envir = .el)
  Kiwi_ready(el)
}
