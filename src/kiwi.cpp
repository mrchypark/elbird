// #include <Rcpp.h>
// using namespace Rcpp;
//
// #include <kiwi/Kiwi.h>
// using namespace kiwi;
//
// RCPP_EXPOSED_AS(Kiwi)
// RCPP_EXPOSED_AS(KiwiBuilder)
// RCPP_EXPOSED_AS(TokenInfo)
// RCPP_EXPOSED_ENUM_NODECL(POSTag)
// RCPP_EXPOSED_ENUM_NODECL(BuildOption)
// RCPP_EXPOSED_ENUM_NODECL(ArchType)
//
// RCPP_MODULE(RcppKiwiEx){
//   Rcpp::class_<Kiwi>("Kiwi")
//   .constructor()
//   .method("ready", &Kiwi::ready);
// }
//
// RCPP_MODULE(RcppKiwiBuilderEx){
//   Rcpp::class_<KiwiBuilder>("KiwiBuilder")
//   .constructor<const std::string&, size_t>()
//   .method("ready", &KiwiBuilder::ready)
//   .method("saveModel", &KiwiBuilder::saveModel)
//   .method("loadDictionary", &KiwiBuilder::loadDictionary)
//   // .method("addWord", &KiwiBuilder::addWord)
//   // .method("build", &KiwiBuilder::build)
//   ;
// }
