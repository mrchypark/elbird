if (!file.exists("../windows/rwinlib-elbird-0.11.1/include/kiwi/capi.h")) {

  if (getRversion() < "3.3.0") setInternet2()
  download.file("https://github.com/mrchypark/rwinlib-elbird/archive/refs/tags/v0.11.1.zip", destfile = "kiwi-release.zip", quiet = TRUE)
  dir.create("../windows", showWarnings = FALSE)
  unzip("kiwi-release.zip", exdir = "../windows")
  unlink("kiwi-release.zip")

}
