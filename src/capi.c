#include <R.h>
#include <Rinternals.h>
#include <kiwi/capi.h>

typedef struct kiwi_s* kiwi_h;
typedef struct kiwi_builder* kiwi_builder_h;
typedef struct kiwi_res* kiwi_res_h;
typedef struct kiwi_ws* kiwi_ws_h;
typedef struct kiwi_ss* kiwi_ss_h;
typedef unsigned short kchar16_t;

typedef int(*kiwi_reader_t)(int, char*, void*);
typedef int(*kiwi_reader_w_t)(int, kchar16_t*, void*);


typedef int(*kiwi_receiver_t)(int, kiwi_res_h, void*);

SEXP kiwi_version_() {
  return mkString(kiwi_version());
}

SEXP kiwi_error_() {
  return mkString(kiwi_error());
}

void kiwi_clear_error_() {
  kiwi_clear_error();
}

static void _finalizer_kiwi_builder_h(SEXP ext){
  if (NULL == R_ExternalPtrAddr(ext))
    return;
  kiwi_builder_h ptr = (kiwi_builder_h) R_ExternalPtrAddr(ext);
  kiwi_builder_close(ptr);
  R_ClearExternalPtr(ext);
}

SEXP kiwi_builder_init_(SEXP model_path, SEXP num_threads, SEXP options) {
  kiwi_builder_h kb = kiwi_builder_init(CHAR(asChar(model_path)), asInteger(num_threads), asInteger(options));
  SEXP res = PROTECT(R_MakeExternalPtr(kb, R_NilValue, R_NilValue));
  R_RegisterCFinalizerEx(res, _finalizer_kiwi_builder_h, TRUE);
  UNPROTECT(1);
  return res;
}

static void _finalizer_kiwi_h(SEXP ext){
  if (NULL == R_ExternalPtrAddr(ext))
    return;
  kiwi_h ptr = (kiwi_h) R_ExternalPtrAddr(ext);
  kiwi_close(ptr);
  R_ClearExternalPtr(ext);
}


SEXP kiwi_init_(SEXP model_path, SEXP num_threads, SEXP options) {
  kiwi_h kb = kiwi_init(CHAR(asChar(model_path)), asInteger(num_threads), asInteger(options));
  SEXP res = PROTECT(R_MakeExternalPtr(kb, R_NilValue, R_NilValue));
  R_RegisterCFinalizerEx(res, _finalizer_kiwi_h, TRUE);
  UNPROTECT(1);
  return res;
}

// https://stackoverflow.com/questions/30279053/how-to-construct-a-named-list-a-sexp-to-be-returned-from-the-c-function-called
// https://stackoverflow.com/questions/7032617/storing-c-objects-in-r
// https://stackoverflow.com/a/38340103
SEXP kiwi_analyze_(SEXP handle, SEXP text, SEXP top_n, SEXP match_options) {

  kiwi_h hd = (kiwi_h)R_ExternalPtrAddr(handle);
  kiwi_res_h resh = kiwi_analyze(hd, CHAR(asChar(text)), asInteger(top_n), asInteger(match_options));

  int resSize = kiwi_res_size(resh);
  SEXP res = PROTECT(allocVector(VECSXP, resSize));

  for (int i = 0; i < resSize; i++) {
    int wlen = kiwi_res_word_num(resh, i);
    SEXP tokens = PROTECT(allocVector(VECSXP, wlen));

    for (int j = 0; j < wlen; j++) {
      SEXP TokenInfo = PROTECT(allocVector(VECSXP, 4));
      SEXP tinms = PROTECT(allocVector(STRSXP, 4));

      SET_STRING_ELT(tinms, 0, mkChar("form"));
      SET_STRING_ELT(tinms, 1, mkChar("tag"));
      SET_STRING_ELT(tinms, 2, mkChar("start"));
      SET_STRING_ELT(tinms, 3, mkChar("len"));

      setAttrib(TokenInfo, R_NamesSymbol, tinms);

      SET_VECTOR_ELT(TokenInfo, 0, mkString(kiwi_res_form(resh, i, j)));
      SET_VECTOR_ELT(TokenInfo, 1, mkString(kiwi_res_tag(resh, i, j)));
      SET_VECTOR_ELT(TokenInfo, 2, ScalarInteger(kiwi_res_position(resh, i, j)+1));
      SET_VECTOR_ELT(TokenInfo, 3, ScalarInteger(kiwi_res_length(resh, i, j)));
      SET_VECTOR_ELT(tokens, j, TokenInfo);
      UNPROTECT(2);
    }
    UNPROTECT(1);

    SEXP TokenResult = PROTECT(allocVector(VECSXP, 2));
    SEXP nms = PROTECT(allocVector(STRSXP, 2));
    SET_STRING_ELT(nms, 0, mkChar("Token"));
    SET_STRING_ELT(nms, 1, mkChar("Score"));
    setAttrib(TokenResult, R_NamesSymbol, nms);

    SET_VECTOR_ELT(TokenResult, 0, tokens);
    SET_VECTOR_ELT(TokenResult, 1, ScalarReal(kiwi_res_prob(resh, i)));
    SET_VECTOR_ELT(res, i, TokenResult);
    UNPROTECT(2);
  }

  UNPROTECT(1);
  kiwi_res_close(resh);
  return res;
}


