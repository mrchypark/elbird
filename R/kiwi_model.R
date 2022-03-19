model_path <- function() {
  path <- Sys.getenv("ELBIRD_MODEL_HOME")
  if (nzchar(path)) {
    normalizePath(path, mustWork = FALSE)
  } else {
    normalizePath(
      file.path(system.file("", package = "elbird")),
      mustWork = FALSE)
  }
}

#' A simple exported version of model_path
#' Returns the kiwi model path.
#'
#' @return path char.
#' @export
kiwi_model_path <- function() {
  model_path_full()
}

model_path_full <- function() {
  file.path(model_path(), "ModelGenerator")
}

model_exists <- function() {
  if (!dir.exists(model_path_full()))
    return(FALSE)

  if (!length(list.files(model_path_full())) > 0)
    return(FALSE)

  return(TRUE)
}

#' Verifies if model exist
#'
#' @return bool
#' @export
model_is_set <- function() {
  model_exists()
}

#' @importFrom utils untar download.file
get_model_file <-
  function(version = "v0.10.3",
           path = model_path(),
           force = FALSE) {
    if (force)
      unlink(path, recursive = TRUE)

    tarurl <-
      paste0(
        "https://github.com/bab2min/Kiwi/releases/download/",
        version,
        "/kiwi_model_",
        version,
        ".tgz"
      )
    utils::download.file(tarurl, destfile = "kiwi-model.tgz", quiet = TRUE)
    dir.create(path, showWarnings = FALSE)
    utils::untar("kiwi-model.tgz", exdir = path)
    unlink("kiwi-model.tgz")
  }
