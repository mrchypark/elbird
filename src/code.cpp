#include <cpp11.hpp>
using namespace cpp11;
#include <kiwi/capi.h>

typedef struct kiwi_s* kiwi_h;
typedef struct kiwi_builder* kiwi_builder_h;
typedef struct kiwi_res* kiwi_res_h;
typedef struct kiwi_ws* kiwi_ws_h;
typedef struct kiwi_ss* kiwi_ss_h;
typedef unsigned short kchar16_t;

[[cpp11::register]]
std::string kiwi_version_() {
  return kiwi_version();
}

[[cpp11::register]]
std::string kiwi_error_() {
  return kiwi_error();
}

[[cpp11::register]]
void kiwi_clear_error_() {
  kiwi_clear_error();
}

static void _finalizer_kiwi_h(kiwi_h handle){
  kiwi_close(handle);
}

[[cpp11::register]]
SEXP kiwi_init_(const char* model_path, int num_threads, int options) {
  kiwi_h kb = kiwi_init(model_path, num_threads, options);
  cpp11::external_pointer<kiwi_s, _finalizer_kiwi_h> res(kb);
  return res;
}

[[cpp11::register]]
SEXP kiwi_analyze_(SEXP handle_ex, const char* text, int top_n, int match_options) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  kiwi_res_h res_h = kiwi_analyze(handle.get(), text, top_n, match_options);

  int resSize = kiwi_res_size(res_h);
  cpp11::writable::list res;

  for (int i = 0; i < resSize; i++) {
    int wlen = kiwi_res_word_num(res_h, i);
    cpp11::writable::list tokens;
    for (int j = 0; j < wlen; j++) {
      cpp11::writable::list TokenInfo;
      TokenInfo.push_back({"form"_nm = kiwi_res_form(res_h, i, j)});
      TokenInfo.push_back({"tag"_nm = kiwi_res_tag(res_h, i, j)});
      TokenInfo.push_back({"start"_nm = kiwi_res_position(res_h, i, j)+1});
      TokenInfo.push_back({"len"_nm = kiwi_res_length(res_h, i, j)});
      tokens.push_back(TokenInfo);
    }
    cpp11::writable::list TokenResult;
    TokenResult.push_back({"Token"_nm = tokens});
    TokenResult.push_back({"Score"_nm = kiwi_res_prob(res_h, i)});
    res.push_back(TokenResult);
  }
  kiwi_res_close(res_h);
  return res;
}
