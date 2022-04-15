kiwi_model_path <- function() {
  path <- Sys.getenv("ELBIRD_MODEL_HOME")
  if (nzchar(path)) {
    normalizePath(path, mustWork = FALSE)
  } else {
    normalizePath(file.path(system.file("", package = "elbird"), "model"),
                  mustWork = FALSE)
  }
}

kiwi_model_path_full <- function(size) {
  size <- match.arg(size, c("small", "base", "large"))
  if (size == "base")
    size <- "ModelGenerator"
  file.path(kiwi_model_path(), size)
}

#' A simple exported version of \code{kiwi_model_path()}
#' Returns the kiwi model path.
#'
#' TODO explain ELBIRD_MODEL_HOME
#'
#' @return \code{character}: file path
#' @examples
#'  model_home()
#' @export
model_home <- function() {
  kiwi_model_path()
}

kiwi_model_exists <- function(size) {
  size <- match.arg(size, c("all", "small", "base", "large"))
  if (size == "all")
    size <- list("small", "base", "large")
  all(sapply(size, function(x)
    kiwi_model_exists_one(x)))
}

kiwi_model_exists_one <- function(size) {
  size <- match.arg(size, c("small", "base", "large"))
  chk_list <-
    c("combiningRule.txt",
      "default.dict",
      "extract.mdl",
      "sj.knlm",
      "sj.morph")
  all(sapply(chk_list, function(x)
    file.exists(file.path(
      kiwi_model_path_full(size), x
    ))))
}

#' Verifies if model files exists.
#'
#' @param size model size. default is "all" which is true that all three models must be present.
#' @return \code{logical} model files exists or not.
#' @examples
#' \dontrun{
#'   get_model("small")
#'   model_exists("small")
#' }
#' @export
model_exists <- function(size = "all") {
  kiwi_model_exists(size)
}

kiwi_model_works <- function(size) {
  size <- match.arg(size, c("all", "small", "base", "large"))
  if (size == "all")
    size <- list("small", "base", "large")
  all(sapply(size, function(x)
    kiwi_model_work_one(x)))
}

kiwi_model_work_one <- function(size) {
  size <- match.arg(size, c("small", "base", "large"))
  if (!kiwi_model_exists_one(size))
    return(FALSE)
  invisible(kiwi_init_(kiwi_model_path_full(size), 1, 1))
  is.null(kiwi_error_wrap())
}

#' Verifies if models work fine.
#'
#' @param size model size. default is "all" which is true that all three models must be present.
#' @return \code{logical} model work or not.
#' @examples
#' \dontrun{
#'   get_model("small")
#'   model_works("small")
#' }
#' @export
model_works <- function(size = "all") {
  kiwi_model_exists(size)
}

#' Get kiwi language model file.
#'
#' @param size "small", "base", "large" model. default is "base". Also "all" available.
#' @param path path for model files. default is [model_home()].
#' @param clean remove previous model files before get new.
#'
#' @source \url{https://github.com/bab2min/Kiwi/releases}
#' @examples
#' \dontrun{
#'   get_model("small")
#' }
#' @export
get_model <-
  function(size = "base",
           path = model_home(),
           clean = FALSE) {
    get_kiwi_models(size, path, clean)
  }

#' @importFrom utils untar download.file
get_kiwi_models <-
  function(size = "all",
           path = kiwi_model_path(),
           clean = FALSE) {
    size <- match.arg(size, c("all", "small", "base", "large"))
    if (clean)
      kiwi_model_clean(size)

    if (size == "all")
      size <- list("small", "base", "large")

    lapply(size, function(x)
      kiwi_model_get(x, path))
    invisible(size)
  }

kiwi_model_clean <- function(size = "all") {
  size <- match.arg(size, c("all", "small", "base", "large"))
  lapply(size, function(x) {
    unlink
  })
  cpath <-
    ifelse(size == "all", kiwi_model_path(), kiwi_model_path_full(size))
  unlink(cpath, recursive = TRUE)
}

#' @importFrom utils download.file
#' @importFrom utils untar
kiwi_model_get <- function(size, path) {
  version <- "v0.11.2"
  size <- match.arg(size, c("small", "base", "large"))
  fnm <- paste0("kiwi_model_", version, "_", size, ".tgz")
  tarurl <-
    paste0("https://github.com/bab2min/Kiwi/releases/download/",
           version,
           "/",
           fnm)
  dir.create(path, showWarnings = FALSE)
  utils::download.file(tarurl, destfile = fnm, quiet = TRUE)
  utils::untar(fnm, exdir = path)
  unlink(fnm)
}
