test_that("tokenize works", {
  res <- tokenize("안녕하세요.")
  expect_equal(res[[1]]$Token[[1]]$form, "안녕")
  expect_equal(res[[1]]$Token[[1]]$tag, "NNG")
  expect_equal(res[[1]]$Token[[1]]$start, 1)
  expect_equal(res[[1]]$Token[[1]]$len, 2)
})

test_that("tokenize_tbl works", {
  res <- tokenize_tbl("안녕하세요.")
  expect_true(tibble::is_tibble(res))
  expect_equal(nrow(res), 5)
  expect_equal(ncol(res), 5)
  expect_true("unique" %in% names(res))
  expect_true("form" %in% names(res))
  expect_true("tag" %in% names(res))
  expect_true("start" %in% names(res))
  expect_true("len" %in% names(res))
})
