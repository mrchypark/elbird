#' Tag list
#'
#' Tags contains tag list for elbird.
#'
#' @source \url{https://github.com/bab2min/Kiwi}
#' @examples
#'  \dontrun{
#'   Tags
#'   Tags$nnp
#'  }
#' @importFrom matchr Enum
#' @export
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
  Tags[tolower(tag_candidate_char)][[1]][[1]]
}

is_tag <- function(tag_candidate_char) {
  if (is.null(tag_candidate_char)) return(FALSE)
  !is.null(Tags[tolower(tag_candidate_char)][[1]])
}


#' Analyze Match Options.
#'
#' ALL option contains URL, EMAIL, HASHTAG, MENTION.
#'
#' @examples
#' \dontrun{
#'  Match
#'  Match$ALL
#' }
#' @export
Match <- matchr::Enum("match",
  URL = "URL",
  EMAIL = "EMAIL",
  HASHTAG = "HASHTAG",
  MENTION = "MENTION",
  SERIAL = "SERIAL",
  ALL = "ALL",

  NORMALIZE_CODA = "NORMALIZE_CODA",
  NORMALIZING_CODA = "NORMALIZING_CODA",
  ALL_WITH_NORMALIZING = "ALL_WITH_NORMALIZING",

  JOIN_NOUN_PREFIX = "JOIN_NOUN_PREFIX",
  JOIN_NOUN_SUFFIX = "JOIN_NOUN_SUFFIX",
  JOIN_VERB_SUFFIX = "JOIN_VERB_SUFFIX",
  JOIN_ADJ_SUFFIX = "JOIN_ADJ_SUFFIX",
  JOIN_ADV_SUFFIX = "JOIN_ADV_SUFFIX",

  JOIN_V_SUFFIX  = "JOIN_V_SUFFIX",
  JOIN_AFFIX = "JOIN_AFFIX",
  JOIN_NOUN_AFFIX = "JOIN_NOUN_AFFIX",

  SPLIT_COMPLEX = "SPLIT_COMPLEX",
  Z_CODA = "Z_CODA",
  COMPATIBLE_JAMO = "COMPATIBLE_JAMO",
  SPLIT_SAISIOT = "SPLIT_SAISIOT",
  MERGE_SAISIOT = "MERGE_SAISIOT"
)

Dialect <- matchr::Enum("dialect",
  STANDARD = 0L,
  GYEONGGI = 1L,
  CHUNGCHEONG = 2L,
  GANGWON = 4L,
  GYEONGSANG = 8L,
  JEOLLA = 16L,
  JEJU = 32L,
  HWANGHAE = 64L,
  HAMGYEONG = 128L,
  PYEONGAN = 256L,
  ARCHAIC = 512L,
  ALL = 1023L
)

TypoSet <- matchr::Enum("typoset",
  WITHOUT_TYPO = 0L,
  BASIC_TYPO_SET = 1L,
  CONTINUAL_TYPO_SET = 2L,
  BASIC_TYPO_SET_WITH_CONTINUAL = 3L,
  LENGTHENING_TYPO_SET = 4L,
  BASIC_TYPO_SET_WITH_CONTINUAL_AND_LENGTHENING = 5L
)

BuildOpt <- matchr::Enum("buildOpt",
                         INTEGRATE_ALLOMORPH = 1L,
                         LOAD_DEFAULT_DICT = 2L,
                         LOAD_TYPO_DICT = 4L,
                         LOAD_MULTI_DICT = 8L,
                         DEFAULT = 15L,
                         MODEL_TYPE_DEFAULT = 0x0000L,
                         MODEL_TYPE_LARGEST = 0x0100L,
                         MODEL_TYPE_KNLM = 0x0200L,
                         MODEL_TYPE_SBG = 0x0300L,
                         MODEL_TYPE_CONG = 0x0400L,
                         MODEL_TYPE_CONG_GLOBAL = 0x0500L
)

normalize_match_option <- function(match_option, normalize_coda) {
  if (!isTRUE(normalize_coda)) {
    return(match_option)
  }
  if (identical(match_option, Match$ALL)) {
    return(Match$ALL_WITH_NORMALIZING)
  }
  if (identical(match_option, Match$ALL_WITH_NORMALIZING) ||
      identical(match_option, Match$NORMALIZE_CODA)) {
    return(match_option)
  }
  match_option
}
