test_that("add words", {
  skip_if_offline()
  get_model("small")
  tem <- kiwi_builder_init_(kiwi_model_path_full("small"), 0, BuildOpt$DEFAULT)

  res <- kiwi_builder_add_pre_analyzed_word_(tem, "팅겼어", anl, 0)
  expect_equal(res, -1)

  kiwi_builder_add_alias_word_(tem, "팅기","vv", -1, "튕기")

  anl <- data.frame(
    morphs = c("팅기", "었", "어"),
    pos = c("vv", "ep", "ef"),
    start = c(0L, 1L, 2L),
    end = c(1L, 2L, 3L)
  )

  res <- kiwi_builder_add_pre_analyzed_word_(tem, "팅겼어", anl, 0)
  expect_equal(res, 0)
  kw <- kiwi_builder_build_(tem)
  res <- kiwi_analyze_wrap(kw, text = "팅겼어...", 1, Match$ALL_WITH_NORMALIZING)
  expect_equal(res[[1]]$Token[[1]]$form, "팅기")
  expect_equal(res[[1]]$Token[[1]]$tag, "VV")
})
