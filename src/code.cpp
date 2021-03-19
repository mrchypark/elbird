#include "cpp11.hpp"
using namespace cpp11;

#include "core/Kiwi.h"

using namespace std;
using namespace kiwi;

[[cpp11::register]]
const char* kiwi_version()
{
  return Kiwi::getVersion();
}
