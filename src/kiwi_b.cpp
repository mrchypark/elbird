#include <cpp11.hpp>
using namespace cpp11;
#include <kiwi/Kiwi.h>

[[cpp11::register]]
std::string kiwi_version_(){
  return KIWI_VERSION_STRING;
}

[[cpp11::register]]
SEXP kiwi_builder_init(std::string model_path, int num_threads, int options) {

}
