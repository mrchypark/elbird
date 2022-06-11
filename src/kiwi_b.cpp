#include <cpp11.hpp>
using namespace cpp11;
#include <kiwi/Kiwi.h>

[[cpp11::register]]
std::string kiwi_version(){
  return KIWI_VERSION_STRING;
}
