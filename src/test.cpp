#include "cpp11.hpp"
#include <kiwi/Kiwi.h>
#include <kiwi/capi.h>

using namespace cpp11;
using namespace kiwi;

[[cpp11::register]]
String kiwi_version() {
  String ver = kiwi_version();
  return ver;
}
