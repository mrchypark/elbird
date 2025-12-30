test_that("Morphset class works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  if (!model_works("base")) {
    get_model("base")
  }

  kw <- Kiwi$new(model_size = "base")
  morphset <- kw$create_morphset()
  expect_equal(class(morphset), c("Morphset", "R6"))

  # Test adding morphemes
  morphset$add("테스트", "NNG")

  # Test getting morphemes
  morphemes <- morphset$get()
  expect_true(is.data.frame(morphemes))
  expect_true(nrow(morphemes) >= 1)
  expect_true(all(c("form", "tag") %in% names(morphemes)))

  # Test clearing morphemes
  morphset$clear()
  cleared_morphemes <- morphset$get()
  expect_equal(nrow(cleared_morphemes), 0)
})

test_that("Morphset integration with Kiwi works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  if (!model_works("base")) {
    get_model("base")
  }

  kw <- Kiwi$new(model_size = "base")
  morphset <- kw$create_morphset()
  morphset$add("키위", "NNG")
  morphset$add("분석기", "NNG")

  # Test with Kiwi analysis
  result <- kw$analyze("키위 분석기는 좋다", blocklist = morphset)

  expect_true(length(result) > 0)
  expect_true(is.list(result))
})
