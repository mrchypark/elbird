#include <cpp11.hpp>
using namespace cpp11;
#include <kiwi/capi.h>
#include <kiwi/Kiwi.h>

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
  kiwi_h kw = kiwi_init(model_path, num_threads, options);
  cpp11::external_pointer<kiwi_s, _finalizer_kiwi_h> res(kw);
  return res;
}

[[cpp11::register]]
void kiwi_set_option_(SEXP handle_ex, int option, int value) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  kiwi_set_option(handle.get(), option, value);
}

[[cpp11::register]]
int kiwi_get_option_(SEXP handle_ex, int option) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  return kiwi_get_option(handle.get(), option);
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
      cpp11::writable::list token;
      token.push_back({"form"_nm = kiwi_res_form(res_h, i, j)});
      token.push_back({"tag"_nm = kiwi_res_tag(res_h, i, j)});
      token.push_back({"start"_nm = kiwi_res_position(res_h, i, j)+1});
      token.push_back({"len"_nm = kiwi_res_length(res_h, i, j)});
      tokens.push_back(token);
    }

    cpp11::writable::list TokenResult;
    TokenResult.push_back({"Token"_nm = tokens});
    TokenResult.push_back({"Score"_nm = kiwi_res_prob(res_h, i)});
    res.push_back(TokenResult);
  }
  kiwi_res_close(res_h);
  return res;
}

[[cpp11::register]]
SEXP kiwi_split_into_sents_(SEXP handle_ex, const char* text, int match_options, bool return_tokens) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  kiwi_res_h tokenized_res;
  kiwi_res_h *tknptr = &tokenized_res;
  if (!return_tokens) {
    tknptr = NULL;
  }

  kiwi_ss_h res_h = kiwi_split_into_sents(handle.get(), text, match_options, tknptr);

  int resSize = kiwi_ss_size(res_h);
  cpp11::writable::list res;
  std::string textr = text;

  for (int i = 0; i < resSize; i++) {
    cpp11::writable::list sent;
    sent.push_back({"text"_nm = textr.substr(kiwi_ss_begin_position(res_h, i), kiwi_ss_end_position(res_h, i))});

    cpp11::writable::list tkns;
    if (return_tokens) {
      int wlen = kiwi_res_word_num(tokenized_res, 0);
      for (int j = 0; j < wlen; j++) {
        cpp11::writable::list token;
        token.push_back({"form"_nm = kiwi_res_form(tokenized_res, 0, j)});
        token.push_back({"tag"_nm = kiwi_res_tag(tokenized_res, 0, j)});
        token.push_back({"start"_nm = kiwi_res_position(tokenized_res, 0, j)+1});
        token.push_back({"len"_nm = kiwi_res_length(tokenized_res, 0, j)});
        if (kiwi_res_sent_position(tokenized_res, 0, j) == i) {
          tkns.push_back(token);
        }
      }
    }
    sent.push_back({"tokens"_nm = tkns});
    res.push_back(sent);
  }
  kiwi_ss_close(res_h);
  return res;
}

static void _finalizer_kiwi_builder_h(kiwi_builder_h handle){
  kiwi_builder_close(handle);
}

[[cpp11::register]]
SEXP kiwi_builder_init_(const char* model_path, int num_threads, int options) {
  kiwi_builder_h kb = kiwi_builder_init(model_path, num_threads, options);
  cpp11::external_pointer<kiwi_builder, _finalizer_kiwi_builder_h> res(kb);
  return res;
}

[[cpp11::register]]
int kiwi_builder_add_word_(SEXP handle_ex, const char* word, const char* pos, float score) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  int res_h = kiwi_builder_add_word(handle.get(), word, pos, score);
  return res_h;
}

[[cpp11::register]]
int kiwi_builder_add_alias_word_(SEXP handle_ex, const char* alias, const char* pos, float score, const char* orig_word) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  int res_h = kiwi_builder_add_alias_word(handle.get(), alias, pos, score, orig_word);
  return res_h;
}

[[cpp11::register]]
int kiwi_builder_load_dict_(SEXP handle_ex, const char* dict_path) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  int res_h = kiwi_builder_load_dict(handle.get(), dict_path);
  return res_h;
}


[[cpp11::register]]
SEXP kiwi_builder_build_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  kiwi_h kw = kiwi_builder_build(handle.get());
  cpp11::external_pointer<kiwi_s, _finalizer_kiwi_h> res(kw);
  return res;
}