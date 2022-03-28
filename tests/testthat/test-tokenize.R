test_that("tokenize works", {
  res <- tokenize("안녕하세요.")
  expect_equal(res[[1]]$Token[[1]]$form, "안녕")
  expect_equal(res[[1]]$Token[[1]]$tag, "NNG")
  expect_equal(res[[1]]$Token[[1]]$start, 1)
  expect_equal(res[[1]]$Token[[1]]$len, 2)
})
