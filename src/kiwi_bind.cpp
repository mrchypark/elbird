#include <fstream>
#include <iostream>
#include <cstring>
#include <vector>

#include <cpp11.hpp>
using namespace cpp11;
#include <kiwi/capi.h>
#include <kiwi/Kiwi.h>

typedef int(*kiwi_receiver_t)(int, kiwi_res_h, void*);
typedef int(*kiwi_builder_replacer_t)(const char*, int, char*, void*);

kiwi::POSTag parse_tag(const char* pos) {
  auto u16 = kiwi::utf8To16(pos);
  transform(u16.begin(), u16.end(), u16.begin(), static_cast<int(*)(int)>(toupper));
  auto ret = kiwi::toPOSTag(u16);
  if (ret == kiwi::POSTag::max) throw std::invalid_argument{ std::string{"Unknown POSTag : "} + pos };
  return ret;
}

class Scanner {
public :
  int init(const char* input) {
    strm.open(input);
    if (!strm.is_open()) {
      return -1;
    }
    return 0;
  };
  bool scan() {
    std::getline(strm, line);
    return !strm.eof();
  };
  void rewind() {
    strm.clear();
    strm.seekg(0, std::ios::beg);
  };
  std::string text() {
    return line;
  };
  int len() {
    return strlen(line.c_str())+1;
  };
  void close() {
    strm.close();
  };

private :
  std::string line = "";
  std::ifstream strm;
};

int readLines(int line, char* buffer, void* input) {
  Scanner* scanner = (Scanner*)input;

  if (buffer == nullptr) {
    if (line == 0) {
      scanner->rewind();
    }

    if (!scanner->scan()) {
      return 0;
    }
    return scanner->len();
  }

  strcpy(buffer, scanner->text().c_str());
  return 0;
}

[[cpp11::register]]
std::string kiwi_version_() {
  return kiwi_version();
}

[[cpp11::register]]
std::string kiwi_error_() {
  if (kiwi_error() == nullptr) return "0";
  return kiwi_error();
}

[[cpp11::register]]
void kiwi_clear_error_() {
  kiwi_clear_error();
}

[[cpp11::register]]
int kiwi_builder_close_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  return kiwi_builder_close(handle.get());
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
bool kiwi_builder_add_pre_analyzed_word_(SEXP handle_ex, const std::string form, const cpp11::list analyzed_r, float score) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  kiwi::KiwiBuilder* kiwi = (kiwi::KiwiBuilder*)handle.get();

  std::vector<std::pair<std::u16string, kiwi::POSTag>> analyzed(analyzed_r.size());
  std::vector<std::pair<size_t, size_t>> positions(analyzed_r.size());

  cpp11::list_of<cpp11::strings> morphs_r(analyzed_r[0]);
  cpp11::list_of<cpp11::strings> pos_r(analyzed_r[1]);
  cpp11::list_of<cpp11::integers> start_r(analyzed_r[2]);
  cpp11::list_of<cpp11::integers> end_r(analyzed_r[3]);

  for (int i = 0; i < morphs_r.size(); ++i) {
    std::cout << morphs_r[i] << std::endl;
    auto morphs = cpp11::as_cpp<char>(morphs_r[i]);
    std::cout << morphs << std::endl;
    auto pos = cpp11::as_cpp<char>(pos_r[i]);
    auto start = cpp11::as_cpp<int>(start_r[i]);
    auto end = cpp11::as_cpp<int>(end_r[i]);

    analyzed[i].first = kiwi::utf8To16(&morphs);
    analyzed[i].second = parse_tag(&pos);
    positions[i].first = start;
    positions[i].first = end;
  }

  return kiwi->addPreAnalyzedWord(kiwi::utf8To16(form), analyzed, positions, score);
}

int kiwi_builder_add_rule_(SEXP handle_ex, const char* pos, kiwi_builder_replacer_t replacer, void* user_data, float score) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  int res_h = kiwi_builder_add_rule(handle.get(), pos, replacer, user_data, score);
  return res_h;
}

[[cpp11::register]]
int kiwi_builder_load_dict_(SEXP handle_ex, const char* dict_path) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  int res_h = kiwi_builder_load_dict(handle.get(), dict_path);
  return res_h;
}

[[cpp11::register]]
int kiwi_close_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  return kiwi_close(handle.get());
}

static void _finalizer_kiwi_h(kiwi_h handle){
  kiwi_close(handle);
}

SEXP we_to_work_res(kiwi_ws_h res_h) {
  int resSize = kiwi_ws_size(res_h);
  cpp11::writable::list res;

  for (int i = 0; i < resSize; i++) {
    cpp11::writable::list word;
    word.push_back({"form"_nm = kiwi_ws_form(res_h, i)});
    word.push_back({"tag_score"_nm = kiwi_ws_freq(res_h, i)});
    word.push_back({"freq"_nm = kiwi_ws_pos_score(res_h, i)});
    word.push_back({"score"_nm = kiwi_ws_score(res_h, i)});
    res.push_back(word);
  }
  return res;
}

[[cpp11::register]]
SEXP kiwi_builder_extract_words_(SEXP handle_ex, const char* input, int min_cnt, int max_word_len, float min_score, float pos_threshold) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  Scanner sc;
  if (sc.init(input) == -1) return R_NilValue;
  kiwi_ws_h res_h = kiwi_builder_extract_words(handle.get(), readLines, &sc, min_cnt, max_word_len, min_score, pos_threshold);
  sc.close();
  auto res = we_to_work_res(res_h);
  kiwi_ws_close(res_h);
  return res;
}

[[cpp11::register]]
int kiwi_builder_extract_add_words_(SEXP handle_ex, const char* input, int min_cnt, int max_word_len, float min_score, float pos_threshold) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  Scanner sc;
  if (sc.init(input) == 0) return 0;
  kiwi_ws_h res_h = kiwi_builder_extract_add_words(handle.get(), readLines, &sc, min_cnt, max_word_len, min_score, pos_threshold);
  sc.close();
  kiwi_ws_close(res_h);
  return 1;
}

[[cpp11::register]]
SEXP kiwi_builder_build_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  kiwi_h kw = kiwi_builder_build(handle.get());
  cpp11::external_pointer<kiwi_s, _finalizer_kiwi_h> res(kw);
  return res;
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
  std::string textr(text);

  for (int i = 0; i < resSize; i++) {
    cpp11::writable::list sent;

    int start = kiwi_ss_begin_position(res_h, i);
    int end = kiwi_ss_end_position(res_h, i);
    sent.push_back({"text"_nm = textr.substr(start, end-start)});
    sent.push_back({"start"_nm = start});
    sent.push_back({"end"_nm = end});

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
