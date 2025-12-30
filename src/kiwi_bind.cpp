#include <fstream>
#include <iostream>
#include <cstring>
#include <vector>
#include <map>
#include <regex>

#include <cpp11.hpp>
using namespace cpp11;
#include <kiwi/capi.h>
#include <kiwi/Kiwi.h>

static std::map<std::string, int> m = {
  { "URL", KIWI_MATCH_URL },
  { "EMAIL", KIWI_MATCH_EMAIL },
  { "HASHTAG", KIWI_MATCH_HASHTAG },
  { "MENTION", KIWI_MATCH_MENTION },
  { "SERIAL", KIWI_MATCH_SERIAL },
  { "ALL", KIWI_MATCH_ALL },
  { "NORMALIZE_CODA", KIWI_MATCH_NORMALIZE_CODA },
  { "NORMALIZING_CODA", KIWI_MATCH_NORMALIZE_CODA },
  { "ALL_WITH_NORMALIZING", KIWI_MATCH_ALL_WITH_NORMALIZING },
  { "JOIN_NOUN_PREFIX", KIWI_MATCH_JOIN_NOUN_PREFIX },
  { "JOIN_NOUN_SUFFIX", KIWI_MATCH_JOIN_NOUN_SUFFIX },
  { "JOIN_VERB_SUFFIX", KIWI_MATCH_JOIN_VERB_SUFFIX },
  { "JOIN_ADJ_SUFFIX", KIWI_MATCH_JOIN_ADJ_SUFFIX },
  { "JOIN_ADV_SUFFIX", KIWI_MATCH_JOIN_ADV_SUFFIX },
  { "JOIN_V_SUFFIX", KIWI_MATCH_JOIN_V_SUFFIX },
  { "JOIN_AFFIX", KIWI_MATCH_JOIN_AFFIX },
  { "JOIN_NOUN_AFFIX", KIWI_MATCH_JOIN_AFFIX },
  { "SPLIT_COMPLEX", KIWI_MATCH_SPLIT_COMPLEX },
  { "Z_CODA", KIWI_MATCH_Z_CODA },
  { "COMPATIBLE_JAMO", KIWI_MATCH_COMPATIBLE_JAMO },
  { "SPLIT_SAISIOT", KIWI_MATCH_SPLIT_SAISIOT },
  { "MERGE_SAISIOT", KIWI_MATCH_MERGE_SAISIOT },
};

int match_options_(const std::string match_string) {
  if (!m.count(match_string)) {
    throw std::invalid_argument{
      std::string{"Unknown Match Options : "} + match_string
      };
  }
  return m.find(match_string)->second;
}

int ensure_model_type_option(int options) {
  if ((options & 0x0F00) == 0) {
    options |= KIWI_BUILD_MODEL_TYPE_CONG;
  }
  return options;
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

int readLines(int line_num, char* buffer, void* user) {
  Scanner* scanner = (Scanner*)user;

  if (buffer == nullptr) {
    if (line_num == 0) {
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

class Replacer {
public :
  void init(const std::string pattern, const std::string replacemnet_) {
    std::regex re(pattern);
    this->rep = re;
    this->replacemnet = replacemnet_;
  };
  int size(const char* input) {
    std::string output = std::regex_replace(std::string(input),
                                            this->rep,
                                            this->replacemnet);
    this->res = output;
    return strlen(output.c_str())+1;
  };
  const char* text() {
    return this->res.c_str();
  };

private :
  std::regex rep;
  std::string replacemnet = "";
  std::string res;
};

int ruleprovider(const char* input, int size, char* buffer, void* user) {
  Replacer* rpcr = (Replacer*)user;
  if (buffer == nullptr) {
    return rpcr->size(input);
  }
  strcpy(buffer, rpcr->text());
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

static void _finalizer_kiwi_typo_h(kiwi_typo_h handle) {
  kiwi_typo_close(handle);
}

static void _finalizer_kiwi_morphset_h(kiwi_morphset_h handle) {
  kiwi_morphset_close(handle);
}

static void _finalizer_kiwi_pt_h(kiwi_pretokenized_h handle) {
  kiwi_pt_close(handle);
}

static void _finalizer_kiwi_joiner_h(kiwi_joiner_h handle) {
  kiwi_joiner_close(handle);
}

static void _finalizer_kiwi_swt_h(kiwi_swtokenizer_h handle) {
  kiwi_swt_close(handle);
}

static void _finalizer_noop_typo_h(kiwi_typo_h handle) {
  (void)handle;
}

static SEXP list_element_by_name(const cpp11::list& input, const std::string& name) {
  cpp11::strings names = input.names();
  for (int i = 0; i < names.size(); ++i) {
    if (std::string(names[i]) == name) {
      return input[i];
    }
  }
  return R_NilValue;
}

static kiwi_config_t config_from_list(const cpp11::list& input, kiwi_config_t base) {
  if (SEXP value = list_element_by_name(input, "integrate_allomorph"); value != R_NilValue) {
    base.integrate_allomorph = cpp11::as_cpp<cpp11::decay_t<uint8_t>>(value);
  }
  if (SEXP value = list_element_by_name(input, "cut_off_threshold"); value != R_NilValue) {
    base.cut_off_threshold = cpp11::as_cpp<cpp11::decay_t<float>>(value);
  }
  if (SEXP value = list_element_by_name(input, "unk_form_score_scale"); value != R_NilValue) {
    base.unk_form_score_scale = cpp11::as_cpp<cpp11::decay_t<float>>(value);
  }
  if (SEXP value = list_element_by_name(input, "unk_form_score_bias"); value != R_NilValue) {
    base.unk_form_score_bias = cpp11::as_cpp<cpp11::decay_t<float>>(value);
  }
  if (SEXP value = list_element_by_name(input, "space_penalty"); value != R_NilValue) {
    base.space_penalty = cpp11::as_cpp<cpp11::decay_t<float>>(value);
  }
  if (SEXP value = list_element_by_name(input, "typo_cost_weight"); value != R_NilValue) {
    base.typo_cost_weight = cpp11::as_cpp<cpp11::decay_t<float>>(value);
  }
  if (SEXP value = list_element_by_name(input, "max_unk_form_size"); value != R_NilValue) {
    base.max_unk_form_size = cpp11::as_cpp<cpp11::decay_t<uint32_t>>(value);
  }
  if (SEXP value = list_element_by_name(input, "space_tolerance"); value != R_NilValue) {
    base.space_tolerance = cpp11::as_cpp<cpp11::decay_t<uint32_t>>(value);
  }
  return base;
}

[[cpp11::register]]
SEXP kiwi_builder_init_(const char* model_path, int num_threads, int options, int enabled_dialects = KIWI_DIALECT_STANDARD) {
  int normalized_options = ensure_model_type_option(options);
  kiwi_builder_h kb = kiwi_builder_init(model_path, num_threads, normalized_options, enabled_dialects);
  cpp11::external_pointer<kiwi_builder, _finalizer_kiwi_builder_h> res(kb);
  return res;
}

[[cpp11::register]]
int kiwi_builder_add_word_(SEXP handle_ex, const char* word, const char* pos, float score) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  return kiwi_builder_add_word(handle.get(), word, pos, score);
}

[[cpp11::register]]
int kiwi_builder_add_alias_word_(SEXP handle_ex, const char* alias, const char* pos, float score, const char* orig_word) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  return kiwi_builder_add_alias_word(handle.get(), alias, pos, score, orig_word);
}

[[cpp11::register]]
int kiwi_builder_add_pre_analyzed_word_(
    SEXP handle_ex,
    const char* form,
    const cpp11::data_frame analyzed_r,
    float score) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);

  cpp11::strings morphs_r = analyzed_r["morphs"];
  cpp11::strings pos_r = analyzed_r["pos"];

  const int size = morphs_r.size();

  std::vector<std::string> morphs;
  std::vector<std::string> pos;

  for (int i = 0; i < size; ++i) {
    morphs.push_back(static_cast<std::string>(morphs_r[i]));
    pos.push_back(static_cast<std::string>(pos_r[i]));
  }

  cpp11::integers start = analyzed_r["start"];
  cpp11::integers end = analyzed_r["end"];

  const char* analyzed_morphs[30];
  const char* analyzed_pos[30];
  int positions[61];

  for (int i = 0; i < size; ++i) {
    analyzed_morphs[i] = morphs[i].c_str();
    analyzed_pos[i] =  pos[i].c_str();
    positions[i*2] = int(start[i]);
    positions[i*2+1] = int(end[i]);
  }

  return kiwi_builder_add_pre_analyzed_word(
    handle.get(),
    form,
    size,
    analyzed_morphs,
    analyzed_pos,
    score,
    positions
  );
}

[[cpp11::register]]
int kiwi_builder_add_rule_(
    SEXP handle_ex,
    const char* pos,
    std::string pattern,
    std::string replacement,
    float score) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  Replacer rpcr;
  rpcr.init(pattern, replacement);
  return kiwi_builder_add_rule(handle.get(), pos, ruleprovider, &rpcr, score);
}

[[cpp11::register]]
int kiwi_builder_load_dict_(SEXP handle_ex, const char* dict_path) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  return kiwi_builder_load_dict(handle.get(), dict_path);
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
SEXP kiwi_builder_build_(SEXP handle_ex, SEXP typos_ex = R_NilValue, double typo_cost_threshold = -1.0) {
  cpp11::external_pointer<kiwi_builder> handle(handle_ex);
  kiwi_typo_h typos = nullptr;
  if (typos_ex != R_NilValue) {
    cpp11::external_pointer<kiwi_typo> typo_handle(typos_ex);
    typos = typo_handle.get();
  }
  float threshold = typo_cost_threshold < 0 ? 0.0f : static_cast<float>(typo_cost_threshold);
  kiwi_h kw = kiwi_builder_build(handle.get(), typos, threshold);
  cpp11::external_pointer<kiwi_s, _finalizer_kiwi_h> res(kw);
  return res;
}

[[cpp11::register]]
SEXP kiwi_init_(const char* model_path, int num_threads, int options) {
  int normalized_options = ensure_model_type_option(options);
  kiwi_h kw = kiwi_init(model_path, num_threads, normalized_options);
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
void kiwi_set_option_f_(SEXP handle_ex, int option, double value) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  kiwi_set_option_f(handle.get(), option, static_cast<float>(value));
}

[[cpp11::register]]
double kiwi_get_option_f_(SEXP handle_ex, int option) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  return kiwi_get_option_f(handle.get(), option);
}

[[cpp11::register]]
SEXP kiwi_get_global_config_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  kiwi_config_t config = kiwi_get_global_config(handle.get());
  cpp11::writable::list res;
  res.push_back({"integrate_allomorph"_nm = config.integrate_allomorph});
  res.push_back({"cut_off_threshold"_nm = config.cut_off_threshold});
  res.push_back({"unk_form_score_scale"_nm = config.unk_form_score_scale});
  res.push_back({"unk_form_score_bias"_nm = config.unk_form_score_bias});
  res.push_back({"space_penalty"_nm = config.space_penalty});
  res.push_back({"typo_cost_weight"_nm = config.typo_cost_weight});
  res.push_back({"max_unk_form_size"_nm = config.max_unk_form_size});
  res.push_back({"space_tolerance"_nm = config.space_tolerance});
  return res;
}

[[cpp11::register]]
void kiwi_set_global_config_(SEXP handle_ex, SEXP config_ex) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  kiwi_config_t config = kiwi_get_global_config(handle.get());
  if (config_ex != R_NilValue) {
    cpp11::list config_r(config_ex);
    config = config_from_list(config_r, config);
  }
  kiwi_set_global_config(handle.get(), config);
}

[[cpp11::register]]
SEXP kiwi_analyze_(
    SEXP handle_ex,
    const char* text,
    int top_n, std::string match_options,
    const cpp11::data_frame stopwords_r,
    SEXP blocklist_ex = R_NilValue,
    SEXP pretokenized_ex = R_NilValue,
    int open_ending = 0,
    int allowed_dialects = KIWI_DIALECT_STANDARD,
    double dialect_cost = 3.0) {

  std::vector<std::pair<std::string, std::string>> filters;
  cpp11::strings form_r = stopwords_r["form"];
  cpp11::strings tag_r = stopwords_r["tag"];

  for (int i = 0; i < form_r.size(); i++) {
    filters.push_back(std::make_pair(std::string(form_r[i]), std::string(tag_r[i])));
  }

  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  kiwi_analyze_option_t options{};
  options.match_options = match_options_(match_options);
  options.blocklist = nullptr;
  options.open_ending = open_ending;
  options.allowed_dialects = allowed_dialects;
  options.dialect_cost = static_cast<float>(dialect_cost);

  kiwi_pretokenized_h pretokenized = nullptr;
  if (pretokenized_ex != R_NilValue) {
    cpp11::external_pointer<kiwi_pretokenized> pretokenized_handle(pretokenized_ex);
    pretokenized = pretokenized_handle.get();
  }

  if (blocklist_ex != R_NilValue) {
    cpp11::external_pointer<kiwi_morphset> blocklist_handle(blocklist_ex);
    options.blocklist = blocklist_handle.get();
  }

  kiwi_res_h res_h = kiwi_analyze(handle.get(),
                                  text,
                                  top_n,
                                  options,
                                  pretokenized);

  int resSize = kiwi_res_size(res_h);
  cpp11::writable::list res;

  for (int i = 0; i < resSize; i++) {

    int wlen = kiwi_res_word_num(res_h, i);
    cpp11::writable::list tokens;
    for (int j = 0; j < wlen; j++) {
      cpp11::writable::list token;
      bool cont = false;
      auto form_candi = kiwi_res_form(res_h, i, j);
      auto tag_candi = kiwi_res_tag(res_h, i, j);
      for (int i = 0; i < form_r.size(); i++) {
        if (form_r[i] == NA_STRING) {
          if (tag_candi == std::string(tag_r[i])) {
            cont = true;
            break;
          }
        } else {
          if ((form_candi == std::string(form_r[i])) &&
              (tag_candi == std::string(tag_r[i]))) {
            cont = true;
            break;
          }
        };
      };
      if (cont) continue;
      token.push_back({"form"_nm = form_candi});
      token.push_back({"tag"_nm = tag_candi});
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
SEXP kiwi_split_into_sents_(
    SEXP handle_ex,
    const char* text,
    std::string match_options,
    bool return_tokens) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  kiwi_res_h tokenized_res;
  kiwi_res_h *tknptr = &tokenized_res;
  if (!return_tokens) {
    tknptr = nullptr;
  }

  kiwi_ss_h res_h = kiwi_split_into_sents(handle.get(),
                                          text,
                                          match_options_(match_options),
                                          tknptr);

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

[[cpp11::register]]
SEXP kiwi_new_morphset_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  kiwi_morphset_h morphset = kiwi_new_morphset(handle.get());
  cpp11::external_pointer<kiwi_morphset, _finalizer_kiwi_morphset_h> res(morphset, false);
  return res;
}

[[cpp11::register]]
int kiwi_morphset_add_(SEXP handle_ex, const char* form, const char* tag) {
  cpp11::external_pointer<kiwi_morphset> handle(handle_ex);
  return kiwi_morphset_add(handle.get(), form, tag);
}

[[cpp11::register]]
int kiwi_morphset_close_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_morphset> handle(handle_ex);
  return kiwi_morphset_close(handle.get());
}

[[cpp11::register]]
SEXP kiwi_pt_init_() {
  kiwi_pretokenized_h handle = kiwi_pt_init();
  cpp11::external_pointer<kiwi_pretokenized, _finalizer_kiwi_pt_h> res(handle, false);
  return res;
}

[[cpp11::register]]
int kiwi_pt_add_span_(SEXP handle_ex, int begin, int end) {
  cpp11::external_pointer<kiwi_pretokenized> handle(handle_ex);
  return kiwi_pt_add_span(handle.get(), begin, end);
}

[[cpp11::register]]
int kiwi_pt_add_token_to_span_(SEXP handle_ex,
                               int span_id,
                               const char* form,
                               const char* tag,
                               int begin,
                               int end) {
  cpp11::external_pointer<kiwi_pretokenized> handle(handle_ex);
  return kiwi_pt_add_token_to_span(handle.get(), span_id, form, tag, begin, end);
}

[[cpp11::register]]
int kiwi_pt_close_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_pretokenized> handle(handle_ex);
  return kiwi_pt_close(handle.get());
}

[[cpp11::register]]
SEXP kiwi_typo_init_() {
  kiwi_typo_h handle = kiwi_typo_init();
  cpp11::external_pointer<kiwi_typo, _finalizer_kiwi_typo_h> res(handle, false);
  return res;
}

[[cpp11::register]]
SEXP kiwi_typo_get_basic_() {
  kiwi_typo_h handle = kiwi_typo_get_basic();
  cpp11::external_pointer<kiwi_typo, _finalizer_noop_typo_h> res(handle);
  return res;
}

[[cpp11::register]]
SEXP kiwi_typo_get_default_(int typo_set) {
  kiwi_typo_h handle = kiwi_typo_get_default(typo_set);
  cpp11::external_pointer<kiwi_typo, _finalizer_noop_typo_h> res(handle);
  return res;
}

[[cpp11::register]]
int kiwi_typo_add_(SEXP handle_ex,
                   const cpp11::strings orig,
                   const cpp11::strings error,
                   double cost,
                   int condition = 0) {
  cpp11::external_pointer<kiwi_typo> handle(handle_ex);
  int orig_size = orig.size();
  int error_size = error.size();
  if (orig_size <= 0 || error_size <= 0) {
    return KIWIERR_FAIL;
  }
  std::vector<std::string> orig_strings;
  std::vector<std::string> error_strings;
  orig_strings.reserve(orig_size);
  error_strings.reserve(error_size);
  for (int i = 0; i < orig_size; ++i) {
    orig_strings.push_back(static_cast<std::string>(orig[i]));
  }
  for (int i = 0; i < error_size; ++i) {
    error_strings.push_back(static_cast<std::string>(error[i]));
  }
  std::vector<const char*> orig_ptrs;
  std::vector<const char*> error_ptrs;
  orig_ptrs.reserve(orig_size);
  error_ptrs.reserve(error_size);
  for (int i = 0; i < orig_size; ++i) {
    orig_ptrs.push_back(orig_strings[i].c_str());
  }
  for (int i = 0; i < error_size; ++i) {
    error_ptrs.push_back(error_strings[i].c_str());
  }
  return kiwi_typo_add(handle.get(),
                       orig_ptrs.data(),
                       orig_size,
                       error_ptrs.data(),
                       error_size,
                       static_cast<float>(cost),
                       condition);
}

[[cpp11::register]]
SEXP kiwi_typo_copy_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_typo> handle(handle_ex);
  kiwi_typo_h copy = kiwi_typo_copy(handle.get());
  cpp11::external_pointer<kiwi_typo, _finalizer_kiwi_typo_h> res(copy, false);
  return res;
}

[[cpp11::register]]
int kiwi_typo_update_(SEXP handle_ex, SEXP src_ex) {
  cpp11::external_pointer<kiwi_typo> handle(handle_ex);
  cpp11::external_pointer<kiwi_typo> src(src_ex);
  return kiwi_typo_update(handle.get(), src.get());
}

[[cpp11::register]]
int kiwi_typo_scale_cost_(SEXP handle_ex, double scale) {
  cpp11::external_pointer<kiwi_typo> handle(handle_ex);
  return kiwi_typo_scale_cost(handle.get(), static_cast<float>(scale));
}

[[cpp11::register]]
int kiwi_typo_set_continual_typo_cost_(SEXP handle_ex, double threshold) {
  cpp11::external_pointer<kiwi_typo> handle(handle_ex);
  return kiwi_typo_set_continual_typo_cost(handle.get(), static_cast<float>(threshold));
}

[[cpp11::register]]
int kiwi_typo_set_lengthening_typo_cost_(SEXP handle_ex, double threshold) {
  cpp11::external_pointer<kiwi_typo> handle(handle_ex);
  return kiwi_typo_set_lengthening_typo_cost(handle.get(), static_cast<float>(threshold));
}

[[cpp11::register]]
int kiwi_typo_close_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_typo> handle(handle_ex);
  return kiwi_typo_close(handle.get());
}

[[cpp11::register]]
SEXP kiwi_new_joiner_(SEXP handle_ex, int lm_search) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  kiwi_joiner_h joiner = kiwi_new_joiner(handle.get(), lm_search);
  cpp11::external_pointer<kiwi_joiner, _finalizer_kiwi_joiner_h> res(joiner, false);
  return res;
}

[[cpp11::register]]
int kiwi_joiner_add_(SEXP handle_ex, const char* form, const char* tag, int option) {
  cpp11::external_pointer<kiwi_joiner> handle(handle_ex);
  return kiwi_joiner_add(handle.get(), form, tag, option);
}

[[cpp11::register]]
std::string kiwi_joiner_get_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_joiner> handle(handle_ex);
  const char* res = kiwi_joiner_get(handle.get());
  if (!res) {
    return "";
  }
  return res;
}

[[cpp11::register]]
int kiwi_joiner_close_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_joiner> handle(handle_ex);
  return kiwi_joiner_close(handle.get());
}

[[cpp11::register]]
SEXP kiwi_swt_init_(const char* path, SEXP kiwi_ex) {
  cpp11::external_pointer<kiwi_s> kiwi_handle(kiwi_ex);
  kiwi_swtokenizer_h handle = kiwi_swt_init(path, kiwi_handle.get());
  cpp11::external_pointer<kiwi_swtokenizer, _finalizer_kiwi_swt_h> res(handle, false);
  return res;
}

[[cpp11::register]]
SEXP kiwi_swt_encode_(SEXP handle_ex, const char* text, int text_size = -1, bool return_offsets = true) {
  cpp11::external_pointer<kiwi_swtokenizer> handle(handle_ex);
  int token_size = kiwi_swt_encode(handle.get(), text, text_size, nullptr, 0, nullptr, 0);
  if (token_size < 0) {
    return R_NilValue;
  }
  cpp11::writable::integers token_ids(token_size);
  std::vector<int> offsets_vec;
  int* offsets_ptr = nullptr;
  int offsets_buf_size = 0;
  if (return_offsets) {
    offsets_vec.assign(token_size * 2, 0);
    offsets_ptr = offsets_vec.data();
    offsets_buf_size = static_cast<int>(offsets_vec.size());
  }
  int result = kiwi_swt_encode(handle.get(),
                               text,
                               text_size,
                               INTEGER(token_ids),
                               token_size,
                               offsets_ptr,
                               offsets_buf_size);
  if (result < 0) {
    return R_NilValue;
  }
  if (!return_offsets) {
    return token_ids;
  }
  cpp11::writable::integers offsets(token_size * 2);
  for (int i = 0; i < token_size; ++i) {
    offsets[i] = offsets_vec[i * 2];
    offsets[i + token_size] = offsets_vec[i * 2 + 1];
  }
  offsets.attr("dim") = cpp11::writable::integers({token_size, 2});
  offsets.attr("dimnames") = cpp11::writable::list({R_NilValue, cpp11::writable::strings({"start", "end"})});
  cpp11::writable::list res;
  res.push_back({"token_ids"_nm = token_ids});
  res.push_back({"offsets"_nm = offsets});
  return res;
}

[[cpp11::register]]
std::string kiwi_swt_decode_(SEXP handle_ex, const cpp11::integers token_ids) {
  cpp11::external_pointer<kiwi_swtokenizer> handle(handle_ex);
  int token_size = token_ids.size();
  if (token_size == 0) {
    return "";
  }
  int text_size = kiwi_swt_decode(handle.get(), INTEGER(token_ids), token_size, nullptr, 0);
  if (text_size < 0) {
    return "";
  }
  std::string text;
  text.resize(text_size);
  int result = kiwi_swt_decode(handle.get(), INTEGER(token_ids), token_size, text.data(), text_size);
  if (result < 0) {
    return "";
  }
  return text;
}

[[cpp11::register]]
int kiwi_swt_close_(SEXP handle_ex) {
  cpp11::external_pointer<kiwi_swtokenizer> handle(handle_ex);
  return kiwi_swt_close(handle.get());
}

[[cpp11::register]]
std::string kiwi_tag_to_string_(SEXP handle_ex, int tag_id) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  const char* res = kiwi_tag_to_string(handle.get(), static_cast<uint8_t>(tag_id));
  if (!res) {
    return "";
  }
  return res;
}

[[cpp11::register]]
std::string kiwi_get_script_name_(int script) {
  const char* res = kiwi_get_script_name(static_cast<uint8_t>(script));
  if (!res) {
    return "";
  }
  return res;
}

[[cpp11::register]]
SEXP kiwi_find_morphemes_(SEXP handle_ex,
                          const char* form,
                          SEXP tag_ex = R_NilValue,
                          int sense_id = -1,
                          int max_count = 256) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  const char* tag = nullptr;
  std::string tag_string;
  if (tag_ex != R_NilValue) {
    cpp11::strings tag_r(tag_ex);
    if (tag_r.size() > 0) {
      tag_string = static_cast<std::string>(tag_r[0]);
      tag = tag_string.c_str();
    }
  }
  if (max_count <= 0) {
    max_count = 256;
  }
  std::vector<unsigned int> ids(static_cast<size_t>(max_count));
  int count = kiwi_find_morphemes(handle.get(), form, tag, sense_id, ids.data(), max_count);
  if (count < 0) {
    return cpp11::writable::integers();
  }
  cpp11::writable::integers res(count);
  for (int i = 0; i < count; ++i) {
    res[i] = static_cast<int>(ids[i]);
  }
  return res;
}

[[cpp11::register]]
SEXP kiwi_find_morphemes_with_prefix_(SEXP handle_ex,
                                      const char* form_prefix,
                                      SEXP tag_ex = R_NilValue,
                                      int sense_id = -1,
                                      int max_count = 256) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  const char* tag = nullptr;
  std::string tag_string;
  if (tag_ex != R_NilValue) {
    cpp11::strings tag_r(tag_ex);
    if (tag_r.size() > 0) {
      tag_string = static_cast<std::string>(tag_r[0]);
      tag = tag_string.c_str();
    }
  }
  if (max_count <= 0) {
    max_count = 256;
  }
  std::vector<unsigned int> ids(static_cast<size_t>(max_count));
  int count = kiwi_find_morphemes_with_prefix(handle.get(), form_prefix, tag, sense_id, ids.data(), max_count);
  if (count < 0) {
    return cpp11::writable::integers();
  }
  cpp11::writable::integers res(count);
  for (int i = 0; i < count; ++i) {
    res[i] = static_cast<int>(ids[i]);
  }
  return res;
}

[[cpp11::register]]
SEXP kiwi_get_morpheme_info_(SEXP handle_ex, unsigned int morph_id) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  kiwi_morpheme_t info = kiwi_get_morpheme_info(handle.get(), morph_id);
  cpp11::writable::list res;
  res.push_back({"tag"_nm = static_cast<int>(info.tag)});
  res.push_back({"sense_id"_nm = static_cast<int>(info.sense_id)});
  res.push_back({"user_score"_nm = info.user_score});
  res.push_back({"lm_morpheme_id"_nm = static_cast<int>(info.lm_morpheme_id)});
  res.push_back({"orig_morpheme_id"_nm = static_cast<int>(info.orig_morpheme_id)});
  res.push_back({"dialect"_nm = static_cast<int>(info.dialect)});
  return res;
}

[[cpp11::register]]
std::string kiwi_get_morpheme_form_(SEXP handle_ex, unsigned int morph_id) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  const char* form = kiwi_get_morpheme_form(handle.get(), morph_id);
  if (!form) {
    return "";
  }
  std::string res(form);
  kiwi_free_morpheme_form(form);
  return res;
}

static cpp11::writable::list similarity_pairs_to_df(const kiwi_similarity_pair_t* data, int size) {
  cpp11::writable::integers ids(size);
  cpp11::writable::doubles scores(size);
  for (int i = 0; i < size; ++i) {
    ids[i] = static_cast<int>(data[i].id);
    scores[i] = static_cast<double>(data[i].score);
  }
  cpp11::writable::list res;
  res.push_back({"id"_nm = ids});
  res.push_back({"score"_nm = scores});
  res.attr("class") = "data.frame";
  res.attr("row.names") = cpp11::writable::integers({NA_INTEGER, -size});
  return res;
}

[[cpp11::register]]
SEXP kiwi_cong_most_similar_words_(SEXP handle_ex, unsigned int morph_id, int top_n = 10) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  if (top_n <= 0) {
    return similarity_pairs_to_df(nullptr, 0);
  }
  std::vector<kiwi_similarity_pair_t> output(static_cast<size_t>(top_n));
  int count = kiwi_cong_most_similar_words(handle.get(), morph_id, output.data(), top_n);
  if (count < 0) {
    return similarity_pairs_to_df(nullptr, 0);
  }
  return similarity_pairs_to_df(output.data(), count);
}

[[cpp11::register]]
double kiwi_cong_similarity_(SEXP handle_ex, unsigned int morph_id1, unsigned int morph_id2) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  return kiwi_cong_similarity(handle.get(), morph_id1, morph_id2);
}

[[cpp11::register]]
SEXP kiwi_cong_most_similar_contexts_(SEXP handle_ex, unsigned int context_id, int top_n = 10) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  if (top_n <= 0) {
    return similarity_pairs_to_df(nullptr, 0);
  }
  std::vector<kiwi_similarity_pair_t> output(static_cast<size_t>(top_n));
  int count = kiwi_cong_most_similar_contexts(handle.get(), context_id, output.data(), top_n);
  if (count < 0) {
    return similarity_pairs_to_df(nullptr, 0);
  }
  return similarity_pairs_to_df(output.data(), count);
}

[[cpp11::register]]
double kiwi_cong_context_similarity_(SEXP handle_ex, unsigned int context_id1, unsigned int context_id2) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  return kiwi_cong_context_similarity(handle.get(), context_id1, context_id2);
}

[[cpp11::register]]
SEXP kiwi_cong_predict_words_from_context_(SEXP handle_ex, unsigned int context_id, int top_n = 10) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  if (top_n <= 0) {
    return similarity_pairs_to_df(nullptr, 0);
  }
  std::vector<kiwi_similarity_pair_t> output(static_cast<size_t>(top_n));
  int count = kiwi_cong_predict_words_from_context(handle.get(), context_id, output.data(), top_n);
  if (count < 0) {
    return similarity_pairs_to_df(nullptr, 0);
  }
  return similarity_pairs_to_df(output.data(), count);
}

[[cpp11::register]]
SEXP kiwi_cong_predict_words_from_context_diff_(SEXP handle_ex,
                                                unsigned int context_id,
                                                unsigned int bg_context_id,
                                                double weight,
                                                int top_n = 10) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  if (top_n <= 0) {
    return similarity_pairs_to_df(nullptr, 0);
  }
  std::vector<kiwi_similarity_pair_t> output(static_cast<size_t>(top_n));
  int count = kiwi_cong_predict_words_from_context_diff(handle.get(),
                                                        context_id,
                                                        bg_context_id,
                                                        static_cast<float>(weight),
                                                        output.data(),
                                                        top_n);
  if (count < 0) {
    return similarity_pairs_to_df(nullptr, 0);
  }
  return similarity_pairs_to_df(output.data(), count);
}

[[cpp11::register]]
unsigned int kiwi_cong_to_context_id_(SEXP handle_ex, const cpp11::integers morph_ids) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  int size = morph_ids.size();
  if (size == 0) {
    return 0;
  }
  std::vector<unsigned int> ids(static_cast<size_t>(size));
  for (int i = 0; i < size; ++i) {
    ids[i] = static_cast<unsigned int>(morph_ids[i]);
  }
  return kiwi_cong_to_context_id(handle.get(), ids.data(), size);
}

[[cpp11::register]]
SEXP kiwi_cong_from_context_id_(SEXP handle_ex, unsigned int context_id, int max_size = 16) {
  cpp11::external_pointer<kiwi_s> handle(handle_ex);
  if (max_size <= 0) {
    max_size = 16;
  }
  std::vector<unsigned int> ids(static_cast<size_t>(max_size));
  int count = kiwi_cong_from_context_id(handle.get(), context_id, ids.data(), max_size);
  if (count < 0) {
    return cpp11::writable::integers();
  }
  cpp11::writable::integers res(count);
  for (int i = 0; i < count; ++i) {
    res[i] = static_cast<int>(ids[i]);
  }
  return res;
}
