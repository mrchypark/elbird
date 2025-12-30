test_that("new API parameters work", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  
  if (!model_works("small"))
    get_model("small")
  
  kw <- Kiwi$new(model_size = "small")
  
  # Test new parameters in analyze function
  result1 <- kw$analyze("안녕하세요", 
                       top_n = 3, 
                       match_option = Match$ALL,
                       typos = FALSE,
                       typo_cost_threshold = 2.5)
  
  expect_true(length(result1) > 0)
  expect_true(is.list(result1))
  
  # Test with different match options
  result2 <- kw$analyze("안녕하세요", 
                       match_option = Match$ALL_WITH_NORMALIZING)
  
  expect_true(length(result2) > 0)
  expect_true(is.list(result2))
})

test_that("tokenize function with new parameters works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  
  # Test tokenize with new parameters
  result1 <- tokenize("안녕하세요 테스트입니다", 
                     stopwords = TRUE,
                     normalize_coda = TRUE,
                     typos = FALSE)
  
  expect_true(tibble::is_tibble(result1))
  expect_true(nrow(result1) > 0)
  expect_true(all(c("sent", "form", "tag", "start", "len") %in% names(result1)))
  
  # Test with different parameters
  result2 <- tokenize("안녕하세요 테스트입니다", 
                     stopwords = FALSE,
                     normalize_coda = FALSE,
                     typos = TRUE)
  
  expect_true(tibble::is_tibble(result2))
  expect_true(nrow(result2) > 0)
})

test_that("analyze function with new parameters works", {
  skip_if_offline()
  skip_on_os(os = "windows", arch = "i386")
  
  # Test analyze with new parameters
  result1 <- analyze("안녕하세요 테스트입니다", 
                    top_n = 2,
                    typos = FALSE,
                    typo_cost_threshold = 3.0)
  
  expect_true(length(result1) > 0)
  expect_true(is.list(result1))
  
  # Test with typo correction enabled
  result2 <- analyze("안뇽하세요 테스트입니다", 
                    typos = TRUE,
                    typo_cost_threshold = 2.0)
  
  expect_true(length(result2) > 0)
  expect_true(is.list(result2))
})