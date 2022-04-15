test_that("tokenize stopword works", {
  skip_if_offline()
  res <- tokenize("Test text.", stopwords = FALSE)
  expect_equal(nrow(res), 3)
  expect_true(res[nrow(res), "form"] == ".")
  res <- tokenize("Test text.", stopwords = TRUE)
  expect_equal(nrow(res), 2)
  expect_true(res[nrow(res), "form"] != ".")
})

test_that("stopwords works", {
  sw <- Stopwords$new()
  expect_equal(class(sw), c("Stopwords","R6"))
  expect_equal(nrow(sw$get()), 106)
  sw <- Stopwords$new(use_system_dict = F)
  expect_equal(nrow(sw$get()), 0)
  sw$add("dkdh")
  expect_equal(nrow(sw$get()), 1)
})
