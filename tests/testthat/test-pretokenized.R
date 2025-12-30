test_that("Pretokenized class works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  if (!model_works("base")) {
    get_model("base")
  }

  kw <- Kiwi$new(model_size = "base")
  pretok <- kw$create_pretokenized()
  expect_equal(class(pretok), c("Pretokenized", "R6"))

  span_id <- pretok$add_span(0, 5)
  pretok$add_token_to_span(span_id, "안녕", "IC", 0, 2)
  pretok$add_token_to_span(span_id, "하", "XSV", 2, 3)
  pretok$add_token_to_span(span_id, "세요", "EP", 3, 5)

  # Test getting pretokenized spans
  words <- pretok$get_all_spans()
  expect_true(is.list(words))
  expect_true(length(words) >= 1)

  # Test clearing pretokenized words
  pretok$clear()
  cleared_words <- pretok$get_all_spans()
  expect_equal(length(cleared_words), 0)
})

test_that("Pretokenized integration with Kiwi works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")

  if (!model_works("base")) {
    get_model("base")
  }

  # Create pretokenized with custom analysis
  kw <- Kiwi$new(model_size = "base")
  pretok <- kw$create_pretokenized()
  span_id <- pretok$add_span(0, 5)
  pretok$add_token_to_span(span_id, "안녕", "IC", 0, 2)
  pretok$add_token_to_span(span_id, "하", "XSV", 2, 3)
  pretok$add_token_to_span(span_id, "세요", "EP", 3, 5)

  # Test with Kiwi analysis
  result <- kw$analyze("안녕하세요 반갑습니다", pretokenized = pretok)

  expect_true(length(result) > 0)
  expect_true(is.list(result))
})
