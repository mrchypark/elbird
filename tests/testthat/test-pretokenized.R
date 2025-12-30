test_that("Pretokenized class works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  
  # Test Pretokenized creation
  pretok <- Pretokenized$new()
  expect_equal(class(pretok), c("Pretokenized", "R6"))
  
  # Test adding pretokenized words
  pretok$add("안녕하세요", list(
    list(form = "안녕", tag = "IC", start = 0, end = 2),
    list(form = "하", tag = "XSV", start = 2, end = 3),
    list(form = "세요", tag = "EP", start = 3, end = 5)
  ))
  
  # Test getting pretokenized words
  words <- pretok$get()
  expect_true(is.list(words))
  expect_true(length(words) >= 1)
  
  # Test clearing pretokenized words
  pretok$clear()
  cleared_words <- pretok$get()
  expect_equal(length(cleared_words), 0)
})

test_that("Pretokenized integration with Kiwi works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  
  if (!model_works("small"))
    get_model("small")
  
  # Create pretokenized with custom analysis
  pretok <- Pretokenized$new()
  pretok$add("안녕하세요", list(
    list(form = "안녕", tag = "IC", start = 0, end = 2),
    list(form = "하", tag = "XSV", start = 2, end = 3),
    list(form = "세요", tag = "EP", start = 3, end = 5)
  ))
  
  # Test with Kiwi analysis
  kw <- Kiwi$new(model_size = "small")
  result <- kw$analyze("안녕하세요 반갑습니다", pretokenized = pretok)
  
  expect_true(length(result) > 0)
  expect_true(is.list(result))
})