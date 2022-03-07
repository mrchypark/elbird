.el <- new.env()

.onLoad <- function(libname, pkgname) {
  set_env()
}

#' @importFrom reticulate conda_create install_miniconda
set_env <- function() {
  if (!check_conda())
    reticulate::install_miniconda()
  if (!check_conda_set())
    reticulate::conda_create("r-Elbird", packages = "python=3.10")
  if (!check_env())
    install_conda_packages()
}

#' @importFrom reticulate conda_version
check_conda <- function() {
  chk <-
    try(reticulate::conda_version(), silent = T)
  return(if (class(chk) == "try-error") F else T)
}

#' @importFrom reticulate conda_install
install_conda_packages <- function() {
  reticulate::conda_install("r-Elbird",
                            pip = TRUE,
                            packages = c("kiwipiepy==0.10.3"))
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
  return(if (class(chk) == "try-error") F else T)
}


