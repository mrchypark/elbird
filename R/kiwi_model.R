kiwi_model_path <- function() {
  path <- Sys.getenv("ELBIRD_MODEL_HOME")
  if (nzchar(path)) {
    normalizePath(path, mustWork = FALSE)
  } else {
    normalizePath(file.path(system.file("", package = "elbird"), "model"),
                  mustWork = FALSE)
  }
}

#' A simple exported version of kiwi_model_path()
#' Returns the kiwi model path.
#'
#' TODO explain ELBIRD_MODEL_HOME
#'
#' @return path char.
#' @export
model_home <- function() {
  kiwi_model_path()
}

kiwi_model_path_full <- function(size) {
  size <- match.arg(size, c("small", "base", "large"))
  if (size == "base")
    size <- "ModelGenerator"
  file.path(kiwi_model_path(), size)
}

model_exists <- function(size) {
  size <- match.arg(size, c("all","small", "base", "large"))
  if (size == "all") size <- list("small", "base", "large")
  all(sapply(size, function(x) model_exists_one(x)))
}

model_exists_one <- function(size) {
  size <- match.arg(size, c("small", "base", "large"))
  chk_list <- c("combiningRule.txt", "default.dict", "extract.mdl", "sj.knlm", "sj.morph")
  all(sapply(chk_list, function(x) file.exists(file.path(kiwi_model_path_full(size), x))))
}

#' Verifies if model exist
#'
#' @param size model size. default is "all" which is true that all three models must be present.
#' @return bool
#' @export
model_is_set <- function(size = "all") {
  model_exists(size)
}

#' Get kiwi language model file.
#'
#' @param size small, base, large model. default is "base". Also "all" available.
#' @param path path for model files. default is model_home_path().
#' @param clean remove previous model files before get new.
#'
#' @source \url{https://github.com/bab2min/Kiwi/releases}
#'
#' @importFrom utils untar download.file
#' @export
get_model <-
  function(size = "base",
           path = model_home_path(),
           clean = FALSE) {
    size <- match.arg(size, c("all","small", "base", "large"))
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

get_kiwi_models <-
  function(size = "all",
           path = model_home_path(),
           clean = FALSE) {

  size <- match.arg(size, c("all", "small", "base", "large"))

  if (clean)
    kiwi_model_clean(size)

  if (size == "all") size <- list("small", "base", "large")

  lapply(size, function(x) kiwi_model_get(version, x, path))
  invisible()
}

kiwi_model_clean <- function(size = "all") {
  size <- match.arg(size, c("all", "small", "base", "large"))
  lapply(size, function(x) {
    unlink
  })
  cpath <- ifelse(size == "all", kiwi_model_path(), kiwi_model_path_full(size))
  unlink(cpath, recursive = TRUE)
}

#' @importFrom utils download.file
#' @importFrom utils untar
kiwi_model_get <- function(size, path) {
  version <- "v0.11.0"
  size <- match.arg(size, c("small", "base", "large"))
  fnm <- paste0("kiwi_model_", version, "_", size, ".tgz")
  tarurl <-
    paste0(
      "https://github.com/bab2min/Kiwi/releases/download/",
      version,
      "/", fnm
    )
  dir.create(path, showWarnings = FALSE)
  utils::download.file(tarurl, destfile = fnm, quiet = TRUE)
  utils::untar(fnm, exdir = path)
  unlink(fnm)
}
