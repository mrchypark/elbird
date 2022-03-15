// #include <cpp11.hpp>
// #include <kiwi/Kiwi.h>
//
// [[cpp11::register]]
// SEXP kiwi_builder(std::string modelPath) {
//   auto kb = new kiwi::KiwiBuilder(modelPath = modelPath);
//   cpp11::external_pointer<kiwi::KiwiBuilder> res(kb);
//   return res;
// }
//
// [[cpp11::register]]
// bool kiwi_builder_ready(SEXP kbe) {
//   auto kb = (kiwi::KiwiBuilder)kbe;
//   return kb->ready();
// }


#include <Rcpp.h>
#include <kiwi/Kiwi.h>
using namespace kiwi;

RCPP_MODULE(RcppKiwiEx){
  Rcpp::class_<Kiwi>("Kiwi")
  .constructor()
  .method("ready", &Kiwi::ready);
}
