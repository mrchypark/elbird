model_path <- function() {
  path <- Sys.getenv("ELBIRD_MODEL_HOME")
  if (nzchar(path)) {
    normalizePath(path, mustWork = FALSE)
  } else {
    normalizePath(file.path(system.file("", package = "elbird")), mustWork = FALSE)
  }
}

#' A simple exported version of model_path
#' Returns the kiwi model path.
#' @export
kiwi_model_path <- function() {
  model_path()
}

check_model <- function() {
  if (!dir.exists(install_path())) {
    return(FALSE)
  }

  return(TRUE)
}

#' Verifies if model exist
#'
#' @export
model_exist <- function() {
  check_model()
}

get_model_file <-function() {

}
