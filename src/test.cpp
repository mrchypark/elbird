#include <Rcpp.h>

#include <kiwi/Kiwi.h>
using namespace kiwi;

RCPP_MODULE(kb_module){
  using namespace Rcpp;

  class_< Kiwi >("kiwi")
    .constructor()
    .method("getNumThreads", &Kiwi::getNumThreads)
  ;
}
