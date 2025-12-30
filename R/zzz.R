.onLoad <- function(libname, pkgname) {
  libdir <- file.path(libname, pkgname, "libs")
  arch <- .Platform$r_arch
  if (nzchar(arch)) {
    libdir <- file.path(libdir, sub("^/", "", arch))
  }

  if (.Platform$OS.type == "windows") {
    kiwi_dir <- file.path(libname, pkgname, "kiwilibs")
    if (dir.exists(kiwi_dir)) {
      path_sep <- ";"
      cur_path <- Sys.getenv("PATH", unset = "")
      Sys.setenv(PATH = paste(kiwi_dir, cur_path, sep = path_sep))
    }
  }

  dynlib <- file.path(libdir, paste0(pkgname, .Platform$dynlib.ext))
  if (file.exists(dynlib)) {
    dyn.load(dynlib)
  }
}
