version <- "0.22.2"
arch <- if (nzchar(.Platform$r_arch)) sub("^/", "", .Platform$r_arch) else "x64"
win_arch <- if (arch == "x64") "x64" else "Win32"
target_dir <- file.path("..", "windows", paste0("kiwi_win_", win_arch, "_v", version))
header_path <- file.path(target_dir, "include", "kiwi", "capi.h")
dll_path <- file.path(target_dir, "lib", "kiwi.dll")
inst_libs_dir <- file.path("..", "inst", "libs", win_arch)

if (!file.exists(header_path)) {
  if (getRversion() < "3.3.0") setInternet2()
  download.file(
    paste0(
      "https://github.com/bab2min/Kiwi/releases/download/v",
      version,
      "/kiwi_win_",
      win_arch,
      "_v",
      version,
      ".zip"
    ),
    destfile = "kiwi-release.zip",
    quiet = TRUE
  )
  dir.create(target_dir, showWarnings = FALSE, recursive = TRUE)
  unzip("kiwi-release.zip", exdir = target_dir)
  unlink("kiwi-release.zip")
}

if (file.exists(dll_path)) {
  dir.create(inst_libs_dir, showWarnings = FALSE, recursive = TRUE)
  file.copy(dll_path, file.path(inst_libs_dir, "kiwi.dll"), overwrite = TRUE)
} else {
  stop(paste0("Expected Kiwi DLL not found at ", dll_path))
}
