dict_path <- function() {
  path <- Sys.getenv("ELBIRD_DICTIONARY_HOME")
  if (nzchar(path)) {
    normalizePath(path, mustWork = FALSE)
  } else {
    normalizePath(file.path(system.file("", package = "elbird"), "dicts"),
                  mustWork = FALSE)
  }
}

dict_stopwords_path <- function() {
  normalizePath(file.path(dict_path(), "stopwords.txt"), mustWork = FALSE)
}

dict_user_path <- function() {
  normalizePath(file.path(dict_path(), "stopwords.txt"), mustWork = FALSE)
}
