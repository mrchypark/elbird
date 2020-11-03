.el <- new.env()

#' @importFrom reticulate import
#' @importFrom dplyr tibble
.onLoad <- function(libname, pkgname) {
  set_env()
}

#' @importFrom reticulate conda_create
set_env <- function() {
  if (!check_conda_set()) {
    reticulate::conda_create("r-Elbird", packages = "python=3.7")
  }
  if (!check_env()) {
    install_conda_packages()
  }
}

#' @importFrom reticulate conda_install
install_conda_packages <- function() {
  reticulate::conda_install("r-Elbird",
                            pip = TRUE,
                            packages = c("kiwipiepy==0.8.2"))
  cat("\nInstallation complete.\n\n")
}

#' @importFrom reticulate py_module_available
check_env <- function() {
  reticulate::py_module_available("kiwipiepy")
}

#' @importFrom reticulate use_condaenv
check_conda_set <- function() {
  chk <-
    try(reticulate::use_condaenv("r-Elbird", required = TRUE), silent = T)
  return (if (class(chk) == "try-error") F else T)
}


