Stopwords <- R6::R6Class('Stopwords',
  public = list(
    print = function(x, ...) {
      cat("<elbird dictionary> ", sep = "\n")
      cat("  Stopwords ", sep = "\n")
      invisible()
    },

    initialize = function(dict_path = dict_stopwords_path()) {

    },

    set_embad_dict = function() {
      private$stopword_list = set_dict(dict_path)
    },

    get = function() {
      private$stopword_list
    }
  ),

  private = list(
    stopword_list = NULL,
    dict_list = NULL,
    set_dict = function(dict) {
      loaded <- vroom::vroom_lines(dict_path)
    },
    validated = function(data) {
      if (is.vector(data) && is.character(data)) {

      }
    }
  )
)

