version <- "0.22.2"
arch <- Sys.getenv("R_ARCH")
arch <- if (nzchar(arch)) sub("^/", "", arch) else "x64"
win_arch <- if (arch == "x64") "x64" else "Win32"
pkgdir <- Sys.getenv("R_PACKAGE_DIR")
if (!nzchar(pkgdir)) {
  quit(status = 0)
}

src_dll <- file.path("..", "windows", paste0("kiwi_win_", win_arch, "_v", version), "lib", "kiwi.dll")
dest_dir <- file.path(pkgdir, "libs", arch)

if (file.exists(src_dll)) {
  dir.create(dest_dir, showWarnings = FALSE, recursive = TRUE)
  file.copy(src_dll, file.path(dest_dir, "kiwi.dll"), overwrite = TRUE)
}
