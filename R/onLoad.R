.el <- new.env()

#' @importFrom reticulate import
.onLoad <- function(libname, pkgname) {
  envnm <- "r-Elbird"
  set_env()
  pak <- reticulate::import("kiwipiepy")
  el <- pak$Kiwi()
  el$prepare()
  assign("el", el, envir = .el)
}

#' @export
#' @importFrom reticulate import import_builtins py_module_available use_condaenv conda_create conda_install conda_list
install_conda_packages <- function() {
  reticulate::conda_install("r-Elbird",
                            pip = TRUE,
                            packages = c("kiwipiepy==0.8.2"))
  cat("\nInstallation complete.\n\n")
}
#' @export
check_env <- function() {
  reticulate::py_module_available("kiwipiepy")
}
#' @export
check_conda_set <- function() {
  envnm <- "r-Elbird"
  chk <- try(reticulate::use_condaenv(envnm, required = TRUE), silent = T)
  if (class(chk) == "try-error") {
    res <- F
  } else {
    res <- T
  }
  return(res)
}

#' @importFrom reticulate conda_create
#' @export
set_env <- function() {
  if (!check_conda_set()) {
    reticulate::conda_create("r-Elbird", packages = "python=3.7")
  }
  if (!check_env()) {
    install_conda_packages()
  }
}
