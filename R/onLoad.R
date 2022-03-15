.el <- new.env()

.onAttach <- function(libname, pkgname) {

}

.onLoad <- function(libname, pkgname) {
  if (!model_exists())
    get_model_file()
}

.onUnload <- function(libpath) {

}
