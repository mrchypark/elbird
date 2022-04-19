test_that("add rule works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  if (!model_works("small"))
    get_model("small")

  kw <- kiwi_init_(kiwi_model_path_full("small"), 0, BuildOpt$DEFAULT)
  res1 <- kiwi_analyze_wrap(kw, "했어요! 하잖아요! 할까요?", top_n = 1)
  res2 <- kiwi_analyze_wrap(kw, "했어용! 하잖아용! 할까용?", top_n = 1)

  expect_false(identical(res1[[1]]$Score, res2[[1]]$Score))

  kb <- kiwi_builder_init_(kiwi_model_path_full("small"), 0, BuildOpt$DEFAULT)
  kiwi_builder_add_rule_(kb, "ef", "요$", "용", -2)
  kw <- kiwi_builder_build_(kb)
  res <- kiwi_analyze_wrap(kw, "했어용! 하잖아용! 할까용?")
  expect_false(identical(res1[[1]]$Score, res[[1]]$Score))
})
