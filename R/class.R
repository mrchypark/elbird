#' kiwi R6 class
#'
#' @importFrom R6 R6Class
Kiwi <- R6::R6Class("Kiwi",
  public = list(
    kiwi = NULL,
    kiwi_builder = NULL,
    user_dic = NULL,
    initialize = function(model_path = model_path_full(), num_threads = 0, options = 1) {
      self$kiwibuilder <- kiwi_builder_init_(model_path, num_threads, options)
      self$kiwi <- kiwi_init_(model_path, num_threads, options)
    },
    init_kiwi = function(val) {
      self$hair <- val
    },
    greet = function() {
      cat(paste0("Hello, my name is ", self$name, ".\n"))
    }
  )
)
