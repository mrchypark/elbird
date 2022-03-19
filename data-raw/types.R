## code to prepare `types` dataset goes here
# https://stackoverflow.com/a/44152358
Enum <- function(...) {

  ## EDIT: use solution provided in comments to capture the arguments
  values <- sapply(match.call(expand.dots = TRUE)[-1L], deparse)

  stopifnot(identical(unique(values), values))

  res <- setNames(seq_along(values)-1, values)
  res <- as.environment(as.list(res))
  lockEnvironment(res, bindings = TRUE)
  res
}

pos_tag <- Enum(
  unknown, # 미설정
  nng, nnp, nnb,
  vv, va,
  mag,
  nr, np,
  vx,
  mm, maj,
  ic,
  xpn, xsn, xsv, xsa, xr,
  vcp, vcn,
  sf, sp, ss, se, so, sw,
  sl, sh, sn,
  w_url, w_email, w_mention, w_hashtag,
  jks, jkc, jkg, jko, jkb, jkv, jkq, jx, jc,
  ep, ef, ec, etn, etm,
  p, # 분할된 동사/형용사를 나타내는데 사용됨
  max # POSTag의 총 개수를 나타내는 용도
)

usethis::use_data(pos_tag, overwrite = TRUE)

cond_vowel <- Enum(
    none, # 조건이 설정되지 않음
    any, # 자음, 모음 여부와 상관 없이 등장 가능
    vowel, # 선행 형태소가 받침이 없는 경우만 등장 가능
    vocalic, # 선행 형태소가 받침이 없거나 ㄹ받침인 경우만 등장 가능
    vocalic_h, # 선행 형태소가 받침이 없거나 ㄹ, ㅎ 받침인 경우만 등장 가능
    non_vowel, # `vowel`의 부정
    non_vocalic, # `vocalic`의 부정
    non_vocalic_h # `vocalic_h`의 부정
)

usethis::use_data(cond_vowel, overwrite = TRUE)

cond_polarity <- Enum(
    none, # 조건이 설정되지 않음
    positive, # 선행 형태소가 양성(ㅏ,ㅑ,ㅗ)인 경우만 등장 가능
    negative # 선행 형태소가 음성(그 외)인 경우만 등장 가능
)

usethis::use_data(cond_polarity, overwrite = TRUE)

