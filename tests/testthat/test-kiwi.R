test_that("analyze works", {
  skip_if_offline()
  res <- tokenize("Test text.", stopwords = FALSE)
  expect_equal(length(res[[1]]$Token), 3)
  expect_true(res[[1]]$Token[[length(res[[1]]$Token)]]$form == ".")
  res <- tokenize("Test text.", stopwords = TRUE)
  expect_equal(length(res[[1]]$Token), 2)
  expect_true(res[[1]]$Token[[length(res[[1]]$Token)]]$form != ".")
})
