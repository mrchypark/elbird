#include <cpp11.hpp>
using namespace cpp11;

#include <kiwi/Kiwi.h>

[[cpp11::register]]
SEXP r_kiwi() {
  auto kb = new kiwi::KiwiBuilder();
  cpp11::external_pointer<kiwi::KiwiBuilder> res(kb);
  return res;
}
