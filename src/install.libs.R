version <- "0.22.2"
arch <- Sys.getenv("R_ARCH")
arch <- if (nzchar(arch)) sub("^/", "", arch) else ""
pkgdir <- Sys.getenv("R_PACKAGE_DIR")
if (!nzchar(pkgdir)) {
  quit(status = 0)
}

sysname <- Sys.info()[["sysname"]]
if (!is.na(sysname) && sysname == "Windows" && !nzchar(arch)) {
  arch <- "x64"
}

dest_dir <- if (nzchar(arch)) file.path(pkgdir, "libs", arch) else file.path(pkgdir, "libs")
dir.create(dest_dir, showWarnings = FALSE, recursive = TRUE)

dyn_ext <- .Platform$dynlib.ext
if (nzchar(dyn_ext)) {
  dynlibs <- list.files(".", pattern = paste0("\\", dyn_ext, "$"), full.names = TRUE)
  if (length(dynlibs) > 0) {
    file.copy(dynlibs, dest_dir, overwrite = TRUE)
  }
}
if (!is.na(sysname) && sysname == "Windows") {
  win_arch <- if (arch == "x64") "x64" else "Win32"
  src_dll <- file.path("..", "windows", paste0("kiwi_win_", win_arch, "_v", version), "lib", "kiwi.dll")
  if (file.exists(src_dll)) {
    kiwi_dir <- file.path(pkgdir, "kiwilibs")
    dir.create(kiwi_dir, showWarnings = FALSE, recursive = TRUE)
    file.copy(src_dll, file.path(kiwi_dir, "kiwi.dll"), overwrite = TRUE)
  }
} else if (!is.na(sysname) && sysname == "Linux") {
  lib_dir <- file.path("..", "kiwilibs", "libs")
  if (dir.exists(lib_dir)) {
    so_files <- list.files(lib_dir, pattern = "^libkiwi\\.so", full.names = TRUE)
    if (length(so_files) > 0) {
      file.copy(so_files, dest_dir, overwrite = TRUE)
      so_targets <- list.files(dest_dir, pattern = "^libkiwi\\.so", full.names = TRUE)
      if (length(so_targets) > 0 && !file.exists(file.path(dest_dir, "libkiwi.so.0"))) {
        file.symlink(basename(so_targets[1]), file.path(dest_dir, "libkiwi.so.0"))
      }
    }
  }
}
