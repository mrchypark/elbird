#' Elbird enums
#'
#' @name enums
#' @importFrom matchr Enum
#' @export
#' @keywords internal
Tags <- matchr::Enum("tag",
  unknown = "UN",
  nng = "NNG", nnp = "NNP", nnb = "NNB",
  vv = "VV", va = "VA",
  mag = "MAG",
  nr = "NR", np = "NP",
  vx = "VX",
  mm = "MM", maj = "MAJ",
  ic = "IC",
  xpn = "XPN", xsn = "XSN", xsv = "XSV", xsa = "XSA", xr = "XR",
  vcp = "VCP", vcn = "VCN",
  sf = "SF", sp = "SP", ss = "SS", se = "SE", so = "SO", sw = "SW",
  sl = "SL", sh = "SH", sn = "SN",

  w_url = "W_URL", w_email = "W_EMAIL",
  w_mention = "W_MENTION", w_hashtag = "W_HASHTAG",

  jks = "JKS", jkc = "JKC", jkg = "JKG", jko = "JKO",
  jkb = "JKB", jkv = "JKV", jkq = "JKQ", jx = "JX", jc = "JC",

  ep = "EP", ef = "EF", ec = "EC", etn = "ETN", etm = "ETM"
)

check_tag <- function(tag_candidate_char) {
  if (!is_tag(tag_candidate_char))
    stop(paste0(tag_candidate_char, " is not in tag list. Check Tags."))
  Tags[tolower(tag_candidate_char)][[1]][1]
}

to_tag <- function(tag_candidate_char) {
  if (!is_tag(tag_candidate_char))
    stop(paste0(tag_candidate_char, " is not in tag list. Check Tags."))
  Tags[tolower(tag_candidate_char)][[1]]
}

is_tag <- function(tag_candidate_char) {
  !is.null(Tags[tolower(tag_candidate_char)][[1]])
}

build_options <- matchr::Enum("buildOptions",
  INTEGRATE_ALLOMORPH = 1L,
  LOAD_DEFAULT_DICT = 2L,
  DEFAULT = 3L
)

#' @rdname enums
#' @export
Match <- matchr::Enum("Match",
  URL = "URL",
  EMAIL = "EMAIL",
  HASHTAG = "HASHTAG",
  MENTION = "MENTION",
  ALL = "ALL",

  NORMALIZING_CODA = "NORMALIZING_CODA",
  ALL_WITH_NORMALIZING = "ALL_WITH_NORMALIZING",

  JOIN_NOUN_PREFIX = "JOIN_NOUN_PREFIX",
  JOIN_NOUN_SUFFIX = "JOIN_NOUN_SUFFIX",
  JOIN_VERB_SUFFIX = "JOIN_VERB_SUFFIX",
  JOIN_ADJ_SUFFIX = "JOIN_ADJ_SUFFIX",

  JOIN_V_SUFFIX  = "JOIN_V_SUFFIX",
  JOIN_NOUN_AFFIX = "JOIN_V_SUFFIX"
)
