version <- "0.22.2"
arch <- if (nzchar(.Platform$r_arch)) sub("^/", "", .Platform$r_arch) else "x64"
win_arch <- if (arch == "x64") "x64" else "Win32"
target_dir <- file.path("..", "windows", paste0("kiwi_win_", win_arch, "_v", version))
header_path <- file.path(target_dir, "include", "kiwi", "capi.h")
lib_dir <- file.path(target_dir, "lib")
static_lib_candidates <- c(
  file.path(lib_dir, "libkiwi_static.a"),
  file.path(lib_dir, "kiwi_static.a"),
  file.path(lib_dir, "kiwi_static.lib"),
  file.path(lib_dir, "libkiwi.a")
)

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

static_lib <- static_lib_candidates[file.exists(static_lib_candidates)][1]
if (is.na(static_lib) || !nzchar(static_lib)) {
  stop(paste0("Expected Kiwi static library not found in ", lib_dir))
}

target_static_lib <- file.path(lib_dir, "libkiwi_static.a")
if (!file.exists(target_static_lib)) {
  if (!file.copy(static_lib, target_static_lib, overwrite = TRUE)) {
    stop(paste0("Failed to prepare static lib at ", target_static_lib))
  }
}
