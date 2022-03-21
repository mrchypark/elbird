model_path <- function() {
  path <- Sys.getenv("ELBIRD_KIWI_MODEL_HOME")
  if (nzchar(path)) {
    normalizePath(path, mustWork = FALSE)
  } else {
    normalizePath(
      file.path(system.file("", package = "elbird"), "model"),
      mustWork = FALSE)
  }
}

#' A simple exported version of model_path
#' Returns the kiwi model path.
#'
#' @return path char.
#' @export
kiwi_model_path <- function() {
  model_path()
}

model_path_full <- function() {
  file.path(model_path(), dir(model_path()))
}

model_check <- function() {
  kb <- try(kiwi_init_(model_path_full(), 0, 0), silent = TRUE)
  if (class(kb) == "try-error")
    return(FALSE)
  chk <- try(kiwi_init_chk(kb), silent = TRUE)
  if (class(chk) == "try-error")
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

#' Get kiwi model.
#'
#' @param version model version. default is "v0.11.0"
#' @param size small, base, large model. default is "base".
#' @param path path for model files. default is model_path().
#' @param fresh
#'
#' @source \url{https://github.com/bab2min/Kiwi/releases}
#'
#' @importFrom utils untar download.file
#' @export
get_model <-
  function(version = "v0.11.0",
           size = "base",
           path = model_path(),
           force = FALSE) {
    size <- match.arg(size, c("small","base","large"))
    if (force)
      unlink(path, recursive = TRUE)

    if (model_exists())
      return()

    tarurl <-
      paste0(
        "https://github.com/bab2min/Kiwi/releases/download/",
        version,
        "/kiwi_model_",
        version,
        "_",
        size,
        ".tgz"
      )

    dir.create(path, showWarnings = FALSE)
    utils::download.file(tarurl, destfile = "kiwi-model.tgz", quiet = TRUE)
    utils::untar("kiwi-model.tgz", exdir = path)
    file.rename(file.path(path, dir(path)), file.path(path, "model"))
    unlink("kiwi-model.tgz")
  }
