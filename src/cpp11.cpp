// Generated by cpp11: do not edit by hand
// clang-format off


#include "cpp11/declarations.hpp"
#include <R_ext/Visibility.h>

// kiwi_bind.cpp
std::string kiwi_version_();
extern "C" SEXP _elbird_kiwi_version_() {
  BEGIN_CPP11
    return cpp11::as_sexp(kiwi_version_());
  END_CPP11
}
// kiwi_bind.cpp
std::string kiwi_error_();
extern "C" SEXP _elbird_kiwi_error_() {
  BEGIN_CPP11
    return cpp11::as_sexp(kiwi_error_());
  END_CPP11
}
// kiwi_bind.cpp
void kiwi_clear_error_();
extern "C" SEXP _elbird_kiwi_clear_error_() {
  BEGIN_CPP11
    kiwi_clear_error_();
    return R_NilValue;
  END_CPP11
}
// kiwi_bind.cpp
SEXP kiwi_builder_init_(const char* model_path, int num_threads, int options);
extern "C" SEXP _elbird_kiwi_builder_init_(SEXP model_path, SEXP num_threads, SEXP options) {
  BEGIN_CPP11
    return cpp11::as_sexp(kiwi_builder_init_(cpp11::as_cpp<cpp11::decay_t<const char*>>(model_path), cpp11::as_cpp<cpp11::decay_t<int>>(num_threads), cpp11::as_cpp<cpp11::decay_t<int>>(options)));
  END_CPP11
}
// kiwi_bind.cpp
int kiwi_builder_add_word_(SEXP handle_ex, const char* word, const char* pos, float score);
extern "C" SEXP _elbird_kiwi_builder_add_word_(SEXP handle_ex, SEXP word, SEXP pos, SEXP score) {
  BEGIN_CPP11
    return cpp11::as_sexp(kiwi_builder_add_word_(cpp11::as_cpp<cpp11::decay_t<SEXP>>(handle_ex), cpp11::as_cpp<cpp11::decay_t<const char*>>(word), cpp11::as_cpp<cpp11::decay_t<const char*>>(pos), cpp11::as_cpp<cpp11::decay_t<float>>(score)));
  END_CPP11
}
// kiwi_bind.cpp
int kiwi_builder_add_alias_word_(SEXP handle_ex, const char* alias, const char* pos, float score, const char* orig_word);
extern "C" SEXP _elbird_kiwi_builder_add_alias_word_(SEXP handle_ex, SEXP alias, SEXP pos, SEXP score, SEXP orig_word) {
  BEGIN_CPP11
    return cpp11::as_sexp(kiwi_builder_add_alias_word_(cpp11::as_cpp<cpp11::decay_t<SEXP>>(handle_ex), cpp11::as_cpp<cpp11::decay_t<const char*>>(alias), cpp11::as_cpp<cpp11::decay_t<const char*>>(pos), cpp11::as_cpp<cpp11::decay_t<float>>(score), cpp11::as_cpp<cpp11::decay_t<const char*>>(orig_word)));
  END_CPP11
}
// kiwi_bind.cpp
int kiwi_builder_load_dict_(SEXP handle_ex, const char* dict_path);
extern "C" SEXP _elbird_kiwi_builder_load_dict_(SEXP handle_ex, SEXP dict_path) {
  BEGIN_CPP11
    return cpp11::as_sexp(kiwi_builder_load_dict_(cpp11::as_cpp<cpp11::decay_t<SEXP>>(handle_ex), cpp11::as_cpp<cpp11::decay_t<const char*>>(dict_path)));
  END_CPP11
}
// kiwi_bind.cpp
int kiwi_close_(SEXP handle_ex);
extern "C" SEXP _elbird_kiwi_close_(SEXP handle_ex) {
  BEGIN_CPP11
    return cpp11::as_sexp(kiwi_close_(cpp11::as_cpp<cpp11::decay_t<SEXP>>(handle_ex)));
  END_CPP11
}
// kiwi_bind.cpp
SEXP kiwi_builder_build_(SEXP handle_ex);
extern "C" SEXP _elbird_kiwi_builder_build_(SEXP handle_ex) {
  BEGIN_CPP11
    return cpp11::as_sexp(kiwi_builder_build_(cpp11::as_cpp<cpp11::decay_t<SEXP>>(handle_ex)));
  END_CPP11
}
// kiwi_bind.cpp
SEXP kiwi_init_(const char* model_path, int num_threads, int options);
extern "C" SEXP _elbird_kiwi_init_(SEXP model_path, SEXP num_threads, SEXP options) {
  BEGIN_CPP11
    return cpp11::as_sexp(kiwi_init_(cpp11::as_cpp<cpp11::decay_t<const char*>>(model_path), cpp11::as_cpp<cpp11::decay_t<int>>(num_threads), cpp11::as_cpp<cpp11::decay_t<int>>(options)));
  END_CPP11
}
// kiwi_bind.cpp
void kiwi_set_option_(SEXP handle_ex, int option, int value);
extern "C" SEXP _elbird_kiwi_set_option_(SEXP handle_ex, SEXP option, SEXP value) {
  BEGIN_CPP11
    kiwi_set_option_(cpp11::as_cpp<cpp11::decay_t<SEXP>>(handle_ex), cpp11::as_cpp<cpp11::decay_t<int>>(option), cpp11::as_cpp<cpp11::decay_t<int>>(value));
    return R_NilValue;
  END_CPP11
}
// kiwi_bind.cpp
int kiwi_get_option_(SEXP handle_ex, int option);
extern "C" SEXP _elbird_kiwi_get_option_(SEXP handle_ex, SEXP option) {
  BEGIN_CPP11
    return cpp11::as_sexp(kiwi_get_option_(cpp11::as_cpp<cpp11::decay_t<SEXP>>(handle_ex), cpp11::as_cpp<cpp11::decay_t<int>>(option)));
  END_CPP11
}
// kiwi_bind.cpp
SEXP kiwi_analyze_(SEXP handle_ex, const char* text, int top_n, int match_options);
extern "C" SEXP _elbird_kiwi_analyze_(SEXP handle_ex, SEXP text, SEXP top_n, SEXP match_options) {
  BEGIN_CPP11
    return cpp11::as_sexp(kiwi_analyze_(cpp11::as_cpp<cpp11::decay_t<SEXP>>(handle_ex), cpp11::as_cpp<cpp11::decay_t<const char*>>(text), cpp11::as_cpp<cpp11::decay_t<int>>(top_n), cpp11::as_cpp<cpp11::decay_t<int>>(match_options)));
  END_CPP11
}
// kiwi_bind.cpp
SEXP kiwi_split_into_sents_(SEXP handle_ex, const char* text, int match_options, bool return_tokens);
extern "C" SEXP _elbird_kiwi_split_into_sents_(SEXP handle_ex, SEXP text, SEXP match_options, SEXP return_tokens) {
  BEGIN_CPP11
    return cpp11::as_sexp(kiwi_split_into_sents_(cpp11::as_cpp<cpp11::decay_t<SEXP>>(handle_ex), cpp11::as_cpp<cpp11::decay_t<const char*>>(text), cpp11::as_cpp<cpp11::decay_t<int>>(match_options), cpp11::as_cpp<cpp11::decay_t<bool>>(return_tokens)));
  END_CPP11
}

extern "C" {
static const R_CallMethodDef CallEntries[] = {
    {"_elbird_kiwi_analyze_",                (DL_FUNC) &_elbird_kiwi_analyze_,                4},
    {"_elbird_kiwi_builder_add_alias_word_", (DL_FUNC) &_elbird_kiwi_builder_add_alias_word_, 5},
    {"_elbird_kiwi_builder_add_word_",       (DL_FUNC) &_elbird_kiwi_builder_add_word_,       4},
    {"_elbird_kiwi_builder_build_",          (DL_FUNC) &_elbird_kiwi_builder_build_,          1},
    {"_elbird_kiwi_builder_init_",           (DL_FUNC) &_elbird_kiwi_builder_init_,           3},
    {"_elbird_kiwi_builder_load_dict_",      (DL_FUNC) &_elbird_kiwi_builder_load_dict_,      2},
    {"_elbird_kiwi_clear_error_",            (DL_FUNC) &_elbird_kiwi_clear_error_,            0},
    {"_elbird_kiwi_close_",                  (DL_FUNC) &_elbird_kiwi_close_,                  1},
    {"_elbird_kiwi_error_",                  (DL_FUNC) &_elbird_kiwi_error_,                  0},
    {"_elbird_kiwi_get_option_",             (DL_FUNC) &_elbird_kiwi_get_option_,             2},
    {"_elbird_kiwi_init_",                   (DL_FUNC) &_elbird_kiwi_init_,                   3},
    {"_elbird_kiwi_set_option_",             (DL_FUNC) &_elbird_kiwi_set_option_,             3},
    {"_elbird_kiwi_split_into_sents_",       (DL_FUNC) &_elbird_kiwi_split_into_sents_,       4},
    {"_elbird_kiwi_version_",                (DL_FUNC) &_elbird_kiwi_version_,                0},
    {NULL, NULL, 0}
};
}

extern "C" attribute_visible void R_init_elbird(DllInfo* dll){
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
