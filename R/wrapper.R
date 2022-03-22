kiwi_error_wrap <- function() {
  tr <- try(kiwi_error_(), silent = T)
  if (class(tr) != "try-error") {
    kiwi_clear_error_()
    return(tr)
  }
  invisible()
}
