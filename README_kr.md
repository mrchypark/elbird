
<!-- README_kr.md is generated from README_kr.Rmd. Please edit that file -->

# elbird <img src="man/figures/logo.png" align="right" height=140/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/mrchypark/elbird/workflows/R-CMD-check/badge.svg)](https://github.com/mrchypark/elbird/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/elbird)](https://CRAN.R-project.org/package=elbird)
[![runiverse-name](https://mrchypark.r-universe.dev/badges/:name)](https://mrchypark.r-universe.dev/)
[![runiverse-package](https://mrchypark.r-universe.dev/badges/elbird)](https://mrchypark.r-universe.dev/ui#packages)
[![metacran
downloads](https://cranlogs.r-pkg.org/badges/elbird)](https://cran.r-project.org/package=elbird)
<!-- badges: end -->

`elbird` 패키지는 `cpp` 기반의 [Kiwi](https://github.com/bab2min/Kiwi)
를 wrapping한 형태소 분석기 패키지입니다. 다른 분석기에 비해 빠른 성능과
쉬운 사용자 사전 추가, 미등록 명사 추출(아직 elbird에는 미구현) 등 편의
기능이 있습니다.

## 설치

`elbird`는 아래 명령어로 설치할 수 있습니다.

``` r
# CRAN
install.packages("elbird")

# Dev version
install.packages("elbird", repos = 'https://mrchypark.r-universe.dev')
```

## 사용예

아래 예시들은 elbird의 함수의 동작을 소개합니다.

### tokenize 함수

기본적으로 list형태의 결과를 출력하는 `tokenize` 함수와 tibble
자료형으로 정리한 `tokenize_tbl`, tidytext와의 문법호환을 지원하는
`tokenize_tidy` 함수를 제공합니다.

``` r
library(elbird)
tokenize("안녕하세요 kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다.")
#> [[1]]
#> [[1]]$Token
#> [[1]]$Token[[1]]
#> [[1]]$Token[[1]]$form
#> [1] "안녕하세요"
#> 
#> [[1]]$Token[[1]]$tag
#> [1] "NNP"
#> 
#> [[1]]$Token[[1]]$start
#> [1] 1
#> 
#> [[1]]$Token[[1]]$len
#> [1] 5
#> 
#> 
#> [[1]]$Token[[2]]
#> [[1]]$Token[[2]]$form
#> [1] "kiwi"
#> 
#> [[1]]$Token[[2]]$tag
#> [1] "SL"
#> 
#> [[1]]$Token[[2]]$start
#> [1] 7
#> 
#> [[1]]$Token[[2]]$len
#> [1] 4
#> 
#> 
#> [[1]]$Token[[3]]
#> [[1]]$Token[[3]]$form
#> [1] "형태소"
#> 
#> [[1]]$Token[[3]]$tag
#> [1] "NNG"
#> 
#> [[1]]$Token[[3]]$start
#> [1] 12
#> 
#> [[1]]$Token[[3]]$len
#> [1] 3
#> 
#> 
#> [[1]]$Token[[4]]
#> [[1]]$Token[[4]]$form
#> [1] "분석기"
#> 
#> [[1]]$Token[[4]]$tag
#> [1] "NNG"
#> 
#> [[1]]$Token[[4]]$start
#> [1] 16
#> 
#> [[1]]$Token[[4]]$len
#> [1] 3
#> 
#> 
#> [[1]]$Token[[5]]
#> [[1]]$Token[[5]]$form
#> [1] "R"
#> 
#> [[1]]$Token[[5]]$tag
#> [1] "SL"
#> 
#> [[1]]$Token[[5]]$start
#> [1] 21
#> 
#> [[1]]$Token[[5]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[6]]
#> [[1]]$Token[[6]]$form
#> [1] "wrapper"
#> 
#> [[1]]$Token[[6]]$tag
#> [1] "SL"
#> 
#> [[1]]$Token[[6]]$start
#> [1] 23
#> 
#> [[1]]$Token[[6]]$len
#> [1] 7
#> 
#> 
#> [[1]]$Token[[7]]
#> [[1]]$Token[[7]]$form
#> [1] "elbird"
#> 
#> [[1]]$Token[[7]]$tag
#> [1] "SL"
#> 
#> [[1]]$Token[[7]]$start
#> [1] 32
#> 
#> [[1]]$Token[[7]]$len
#> [1] 6
#> 
#> 
#> [[1]]$Token[[8]]
#> [[1]]$Token[[8]]$form
#> [1] "소개"
#> 
#> [[1]]$Token[[8]]$tag
#> [1] "NNG"
#> 
#> [[1]]$Token[[8]]$start
#> [1] 40
#> 
#> [[1]]$Token[[8]]$len
#> [1] 2
#> 
#> 
#> [[1]]$Token[[9]]
#> [[1]]$Token[[9]]$form
#> [1] "ᆸ니다"
#> 
#> [[1]]$Token[[9]]$tag
#> [1] "EF"
#> 
#> [[1]]$Token[[9]]$start
#> [1] 42
#> 
#> [[1]]$Token[[9]]$len
#> [1] 3
tokenize_tbl("안녕하세요 kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다.")
#> # A tibble: 15 × 5
#>    unique form       tag   start   len
#>    <chr>  <chr>      <chr> <int> <int>
#>  1 1      안녕하세요 NNP       1     5
#>  2 1      kiwi       SL        7     4
#>  3 1      형태소     NNG      12     3
#>  4 1      분석기     NNG      16     3
#>  5 1      의         JKG      19     1
#>  6 1      R          SL       21     1
#>  7 1      wrapper    SL       23     7
#>  8 1      이         VCP      30     1
#>  9 1      ᆫ          ETM      30     1
#> 10 1      elbird     SL       32     6
#> 11 1      를         JKO      38     1
#> 12 1      소개       NNG      40     2
#> 13 1      하         XSV      42     1
#> 14 1      ᆸ니다      EF       42     3
#> 15 1      .          SF       45     1
tokenize_tidy("안녕하세요 kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다.")
#> [[1]]
#>  [1] "안녕하세요/NNP" "kiwi/SL"        "형태소/NNG"     "분석기/NNG"    
#>  [5] "의/JKG"         "R/SL"           "wrapper/SL"     "이/VCP"        
#>  [9] "ᆫ/ETM"           "elbird/SL"      "를/JKO"         "소개/NNG"      
#> [13] "하/XSV"         "ᆸ니다/EF"        "./SF"
```

여러 문장의 경우 `vector`나 `list`로 입력받아서 `list`로 출력합니다.

``` r
tokenize(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
#> [[1]]
#> [[1]]$Token
#> [[1]]$Token[[1]]
#> [[1]]$Token[[1]]$form
#> [1] "새롭"
#> 
#> [[1]]$Token[[1]]$tag
#> [1] "VA"
#> 
#> [[1]]$Token[[1]]$start
#> [1] 1
#> 
#> [[1]]$Token[[1]]$len
#> [1] 2
#> 
#> 
#> [[1]]$Token[[2]]
#> [[1]]$Token[[2]]$form
#> [1] "작성"
#> 
#> [[1]]$Token[[2]]$tag
#> [1] "NNG"
#> 
#> [[1]]$Token[[2]]$start
#> [1] 5
#> 
#> [[1]]$Token[[2]]$len
#> [1] 2
#> 
#> 
#> [[1]]$Token[[3]]
#> [[1]]$Token[[3]]$form
#> [1] "패키지"
#> 
#> [[1]]$Token[[3]]$tag
#> [1] "NNG"
#> 
#> [[1]]$Token[[3]]$start
#> [1] 9
#> 
#> [[1]]$Token[[3]]$len
#> [1] 3
#> 
#> 
#> [[1]]$Token[[4]]
#> [[1]]$Token[[4]]$form
#> [1] "ᆸ니다"
#> 
#> [[1]]$Token[[4]]$tag
#> [1] "EF"
#> 
#> [[1]]$Token[[4]]$start
#> [1] 13
#> 
#> [[1]]$Token[[4]]$len
#> [1] 3
#> 
#> 
#> 
#> 
#> [[2]]
#> [[2]]$Token
#> [[2]]$Token[[1]]
#> [[2]]$Token[[1]]$form
#> [1] "tidytext"
#> 
#> [[2]]$Token[[1]]$tag
#> [1] "SL"
#> 
#> [[2]]$Token[[1]]$start
#> [1] 1
#> 
#> [[2]]$Token[[1]]$len
#> [1] 8
#> 
#> 
#> [[2]]$Token[[2]]
#> [[2]]$Token[[2]]$form
#> [1] "호환"
#> 
#> [[2]]$Token[[2]]$tag
#> [1] "NNG"
#> 
#> [[2]]$Token[[2]]$start
#> [1] 12
#> 
#> [[2]]$Token[[2]]$len
#> [1] 2
#> 
#> 
#> [[2]]$Token[[3]]
#> [[2]]$Token[[3]]$form
#> [1] "염두"
#> 
#> [[2]]$Token[[3]]$tag
#> [1] "NNG"
#> 
#> [[2]]$Token[[3]]$start
#> [1] 16
#> 
#> [[2]]$Token[[3]]$len
#> [1] 2
#> 
#> 
#> [[2]]$Token[[4]]
#> [[2]]$Token[[4]]$form
#> [1] "작성"
#> 
#> [[2]]$Token[[4]]$tag
#> [1] "NNG"
#> 
#> [[2]]$Token[[4]]$start
#> [1] 21
#> 
#> [[2]]$Token[[4]]$len
#> [1] 2
#> 
#> 
#> [[2]]$Token[[5]]
#> [[2]]$Token[[5]]$form
#> [1] "습니다"
#> 
#> [[2]]$Token[[5]]$tag
#> [1] "EF"
#> 
#> [[2]]$Token[[5]]$start
#> [1] 25
#> 
#> [[2]]$Token[[5]]$len
#> [1] 3
tokenize_tbl(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
#> # A tibble: 22 × 5
#>    unique form     tag   start   len
#>    <chr>  <chr>    <chr> <int> <int>
#>  1 1      새롭     VA        1     2
#>  2 1      게       EC        3     1
#>  3 1      작성     NNG       5     2
#>  4 1      되       XSV       7     1
#>  5 1      ᆫ        ETM       7     1
#>  6 1      패키지   NNG       9     3
#>  7 1      이       VCP      13     1
#>  8 1      ᆸ니다    EF       13     3
#>  9 1      .        SF       16     1
#> 10 2      tidytext SL        1     8
#> # … with 12 more rows
tokenize_tidy(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
#> [[1]]
#> [1] "새롭/VA"    "게/EC"      "작성/NNG"   "되/XSV"     "ᆫ/ETM"      
#> [6] "패키지/NNG" "이/VCP"     "ᆸ니다/EF"    "./SF"      
#> 
#> [[2]]
#>  [1] "tidytext/SL" "와/JKB"      "의/JKG"      "호환/NNG"    "을/JKO"     
#>  [6] "염두/NNG"    "하/XSV"      "고/EC"       "작성/NNG"    "하/XSV"     
#> [11] "었/EP"       "습니다/EF"   "./SF"
```

### With tidytext

`tokenize_tidy` 함수는 `tokenize_tt`, `tokenize_tidytext` 로도 사용할 수
있습니다. 아래는 `tidytext` 패키지와 함께 사용하는 예시 입니다. 아래
`tar`는 형태소 분석을 위한 타겟 텍스트입니다.

``` r
suppressMessages(library(dplyr))
install.packages("presidentSpeech", repos = "https://forkonlp.r-universe.dev/")
#> Installing package into '/usr/local/lib/R/site-library'
#> (as 'lib' is unspecified)
library(stringr)
library(tidytext)
library(presidentSpeech)

spidx %>% 
  filter(president == "이명박") %>% 
  filter(str_detect(title, "취임사")) %>% 
  pull(link) %>% 
  get_speech(paragraph = T) %>%
  select(paragraph, content) -> tar
tar
#> # A tibble: 62 × 2
#>    paragraph content                                                            
#>        <int> <chr>                                                              
#>  1         1 존경하는 국민 여러분!                                              
#>  2         2 700만 해외동포 여러분!                                             
#>  3         3 이 자리에 참석하신 노무현ㆍ김대중ㆍ김영삼ㆍ전두환 전 대통령, 그리… 
#>  4         4 저는 오늘 국민 여러분의 부름을 받고 대한민국의 제17대 대통령에 취… 
#>  5         5 저는 이 자리에서 국민 여러분께 약속드립니다. 국민을 섬겨 나라를 편…
#>  6         6 올해로 대한민국 건국 60주년을 맞이합니다. 우리는 잃었던 땅을 되찾… 
#>  7         7 지구 상에서 가장 가난했던 나라가 세계 10위권의 경제 대국이 되었습… 
#>  8         8 그러나 우리는 알고 있습니다. 그것은 기적이 아니라 우리가 다 함께 … 
#>  9         9 독립을 위해 목숨을 바친 선열들, 전선에서 산화한 장병들, 뙤약볕과 … 
#> 10        10 장롱 속 금붙이를 들고나와 외환위기에 맞섰던 시민들, 겨울 바닷가에… 
#> # … with 52 more rows
```

`tar`를 `tidytext` 패키지의 함수인 `unnest_tokens`로 `elbird`의
`tokenize_tidy`를 tokenizer로 사용하는 예시입니다.

``` r
tar %>% 
  unnest_tokens(
    input = content,
    output = word,
    token = tokenize_tidy
    )
#> # A tibble: 4,537 × 2
#>    paragraph word     
#>        <int> <chr>    
#>  1         1 존경/nng 
#>  2         1 하/xsv   
#>  3         1 는/etm   
#>  4         1 국민/nng 
#>  5         1 여러분/np
#>  6         1 !/sf     
#>  7         2 700/sn   
#>  8         2 만/nr    
#>  9         2 해외/nng 
#> 10         2 동포/nng 
#> # … with 4,527 more rows
```

### analyze 함수

추가로 여러 분석 후보와 분석결과의 점수를 함께 제공하는 `analyze` 함수를
제공합니다.

``` r
library(elbird)
analyze("안녕하세요 kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다.")
#> [[1]]
#> [[1]]$Token
#> [[1]]$Token[[1]]
#> [[1]]$Token[[1]]$form
#> [1] "안녕하세요"
#> 
#> [[1]]$Token[[1]]$tag
#> [1] "NNP"
#> 
#> [[1]]$Token[[1]]$start
#> [1] 1
#> 
#> [[1]]$Token[[1]]$len
#> [1] 5
#> 
#> 
#> [[1]]$Token[[2]]
#> [[1]]$Token[[2]]$form
#> [1] "kiwi"
#> 
#> [[1]]$Token[[2]]$tag
#> [1] "SL"
#> 
#> [[1]]$Token[[2]]$start
#> [1] 7
#> 
#> [[1]]$Token[[2]]$len
#> [1] 4
#> 
#> 
#> [[1]]$Token[[3]]
#> [[1]]$Token[[3]]$form
#> [1] "형태소"
#> 
#> [[1]]$Token[[3]]$tag
#> [1] "NNG"
#> 
#> [[1]]$Token[[3]]$start
#> [1] 12
#> 
#> [[1]]$Token[[3]]$len
#> [1] 3
#> 
#> 
#> [[1]]$Token[[4]]
#> [[1]]$Token[[4]]$form
#> [1] "분석기"
#> 
#> [[1]]$Token[[4]]$tag
#> [1] "NNG"
#> 
#> [[1]]$Token[[4]]$start
#> [1] 16
#> 
#> [[1]]$Token[[4]]$len
#> [1] 3
#> 
#> 
#> [[1]]$Token[[5]]
#> [[1]]$Token[[5]]$form
#> [1] "의"
#> 
#> [[1]]$Token[[5]]$tag
#> [1] "JKG"
#> 
#> [[1]]$Token[[5]]$start
#> [1] 19
#> 
#> [[1]]$Token[[5]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[6]]
#> [[1]]$Token[[6]]$form
#> [1] "R"
#> 
#> [[1]]$Token[[6]]$tag
#> [1] "SL"
#> 
#> [[1]]$Token[[6]]$start
#> [1] 21
#> 
#> [[1]]$Token[[6]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[7]]
#> [[1]]$Token[[7]]$form
#> [1] "wrapper"
#> 
#> [[1]]$Token[[7]]$tag
#> [1] "SL"
#> 
#> [[1]]$Token[[7]]$start
#> [1] 23
#> 
#> [[1]]$Token[[7]]$len
#> [1] 7
#> 
#> 
#> [[1]]$Token[[8]]
#> [[1]]$Token[[8]]$form
#> [1] "이"
#> 
#> [[1]]$Token[[8]]$tag
#> [1] "VCP"
#> 
#> [[1]]$Token[[8]]$start
#> [1] 30
#> 
#> [[1]]$Token[[8]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[9]]
#> [[1]]$Token[[9]]$form
#> [1] "ᆫ"
#> 
#> [[1]]$Token[[9]]$tag
#> [1] "ETM"
#> 
#> [[1]]$Token[[9]]$start
#> [1] 30
#> 
#> [[1]]$Token[[9]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[10]]
#> [[1]]$Token[[10]]$form
#> [1] "elbird"
#> 
#> [[1]]$Token[[10]]$tag
#> [1] "SL"
#> 
#> [[1]]$Token[[10]]$start
#> [1] 32
#> 
#> [[1]]$Token[[10]]$len
#> [1] 6
#> 
#> 
#> [[1]]$Token[[11]]
#> [[1]]$Token[[11]]$form
#> [1] "를"
#> 
#> [[1]]$Token[[11]]$tag
#> [1] "JKO"
#> 
#> [[1]]$Token[[11]]$start
#> [1] 38
#> 
#> [[1]]$Token[[11]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[12]]
#> [[1]]$Token[[12]]$form
#> [1] "소개"
#> 
#> [[1]]$Token[[12]]$tag
#> [1] "NNG"
#> 
#> [[1]]$Token[[12]]$start
#> [1] 40
#> 
#> [[1]]$Token[[12]]$len
#> [1] 2
#> 
#> 
#> [[1]]$Token[[13]]
#> [[1]]$Token[[13]]$form
#> [1] "하"
#> 
#> [[1]]$Token[[13]]$tag
#> [1] "XSV"
#> 
#> [[1]]$Token[[13]]$start
#> [1] 42
#> 
#> [[1]]$Token[[13]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[14]]
#> [[1]]$Token[[14]]$form
#> [1] "ᆸ니다"
#> 
#> [[1]]$Token[[14]]$tag
#> [1] "EF"
#> 
#> [[1]]$Token[[14]]$start
#> [1] 42
#> 
#> [[1]]$Token[[14]]$len
#> [1] 3
#> 
#> 
#> [[1]]$Token[[15]]
#> [[1]]$Token[[15]]$form
#> [1] "."
#> 
#> [[1]]$Token[[15]]$tag
#> [1] "SF"
#> 
#> [[1]]$Token[[15]]$start
#> [1] 45
#> 
#> [[1]]$Token[[15]]$len
#> [1] 1
#> 
#> 
#> 
#> [[1]]$Score
#> [1] -91.58401
#> 
#> 
#> [[2]]
#> [[2]]$Token
#> [[2]]$Token[[1]]
#> [[2]]$Token[[1]]$form
#> [1] "안녕"
#> 
#> [[2]]$Token[[1]]$tag
#> [1] "NNG"
#> 
#> [[2]]$Token[[1]]$start
#> [1] 1
#> 
#> [[2]]$Token[[1]]$len
#> [1] 2
#> 
#> 
#> [[2]]$Token[[2]]
#> [[2]]$Token[[2]]$form
#> [1] "하"
#> 
#> [[2]]$Token[[2]]$tag
#> [1] "XSA"
#> 
#> [[2]]$Token[[2]]$start
#> [1] 3
#> 
#> [[2]]$Token[[2]]$len
#> [1] 1
#> 
#> 
#> [[2]]$Token[[3]]
#> [[2]]$Token[[3]]$form
#> [1] "시"
#> 
#> [[2]]$Token[[3]]$tag
#> [1] "EP"
#> 
#> [[2]]$Token[[3]]$start
#> [1] 4
#> 
#> [[2]]$Token[[3]]$len
#> [1] 1
#> 
#> 
#> [[2]]$Token[[4]]
#> [[2]]$Token[[4]]$form
#> [1] "어요"
#> 
#> [[2]]$Token[[4]]$tag
#> [1] "EF"
#> 
#> [[2]]$Token[[4]]$start
#> [1] 4
#> 
#> [[2]]$Token[[4]]$len
#> [1] 2
#> 
#> 
#> [[2]]$Token[[5]]
#> [[2]]$Token[[5]]$form
#> [1] "kiwi"
#> 
#> [[2]]$Token[[5]]$tag
#> [1] "SL"
#> 
#> [[2]]$Token[[5]]$start
#> [1] 7
#> 
#> [[2]]$Token[[5]]$len
#> [1] 4
#> 
#> 
#> [[2]]$Token[[6]]
#> [[2]]$Token[[6]]$form
#> [1] "형태소"
#> 
#> [[2]]$Token[[6]]$tag
#> [1] "NNG"
#> 
#> [[2]]$Token[[6]]$start
#> [1] 12
#> 
#> [[2]]$Token[[6]]$len
#> [1] 3
#> 
#> 
#> [[2]]$Token[[7]]
#> [[2]]$Token[[7]]$form
#> [1] "분석기"
#> 
#> [[2]]$Token[[7]]$tag
#> [1] "NNG"
#> 
#> [[2]]$Token[[7]]$start
#> [1] 16
#> 
#> [[2]]$Token[[7]]$len
#> [1] 3
#> 
#> 
#> [[2]]$Token[[8]]
#> [[2]]$Token[[8]]$form
#> [1] "의"
#> 
#> [[2]]$Token[[8]]$tag
#> [1] "JKG"
#> 
#> [[2]]$Token[[8]]$start
#> [1] 19
#> 
#> [[2]]$Token[[8]]$len
#> [1] 1
#> 
#> 
#> [[2]]$Token[[9]]
#> [[2]]$Token[[9]]$form
#> [1] "R"
#> 
#> [[2]]$Token[[9]]$tag
#> [1] "SL"
#> 
#> [[2]]$Token[[9]]$start
#> [1] 21
#> 
#> [[2]]$Token[[9]]$len
#> [1] 1
#> 
#> 
#> [[2]]$Token[[10]]
#> [[2]]$Token[[10]]$form
#> [1] "wrapper"
#> 
#> [[2]]$Token[[10]]$tag
#> [1] "SL"
#> 
#> [[2]]$Token[[10]]$start
#> [1] 23
#> 
#> [[2]]$Token[[10]]$len
#> [1] 7
#> 
#> 
#> [[2]]$Token[[11]]
#> [[2]]$Token[[11]]$form
#> [1] "이"
#> 
#> [[2]]$Token[[11]]$tag
#> [1] "VCP"
#> 
#> [[2]]$Token[[11]]$start
#> [1] 30
#> 
#> [[2]]$Token[[11]]$len
#> [1] 1
#> 
#> 
#> [[2]]$Token[[12]]
#> [[2]]$Token[[12]]$form
#> [1] "ᆫ"
#> 
#> [[2]]$Token[[12]]$tag
#> [1] "ETM"
#> 
#> [[2]]$Token[[12]]$start
#> [1] 30
#> 
#> [[2]]$Token[[12]]$len
#> [1] 1
#> 
#> 
#> [[2]]$Token[[13]]
#> [[2]]$Token[[13]]$form
#> [1] "elbird"
#> 
#> [[2]]$Token[[13]]$tag
#> [1] "SL"
#> 
#> [[2]]$Token[[13]]$start
#> [1] 32
#> 
#> [[2]]$Token[[13]]$len
#> [1] 6
#> 
#> 
#> [[2]]$Token[[14]]
#> [[2]]$Token[[14]]$form
#> [1] "를"
#> 
#> [[2]]$Token[[14]]$tag
#> [1] "JKO"
#> 
#> [[2]]$Token[[14]]$start
#> [1] 38
#> 
#> [[2]]$Token[[14]]$len
#> [1] 1
#> 
#> 
#> [[2]]$Token[[15]]
#> [[2]]$Token[[15]]$form
#> [1] "소개"
#> 
#> [[2]]$Token[[15]]$tag
#> [1] "NNG"
#> 
#> [[2]]$Token[[15]]$start
#> [1] 40
#> 
#> [[2]]$Token[[15]]$len
#> [1] 2
#> 
#> 
#> [[2]]$Token[[16]]
#> [[2]]$Token[[16]]$form
#> [1] "하"
#> 
#> [[2]]$Token[[16]]$tag
#> [1] "XSV"
#> 
#> [[2]]$Token[[16]]$start
#> [1] 42
#> 
#> [[2]]$Token[[16]]$len
#> [1] 1
#> 
#> 
#> [[2]]$Token[[17]]
#> [[2]]$Token[[17]]$form
#> [1] "ᆸ니다"
#> 
#> [[2]]$Token[[17]]$tag
#> [1] "EF"
#> 
#> [[2]]$Token[[17]]$start
#> [1] 42
#> 
#> [[2]]$Token[[17]]$len
#> [1] 3
#> 
#> 
#> [[2]]$Token[[18]]
#> [[2]]$Token[[18]]$form
#> [1] "."
#> 
#> [[2]]$Token[[18]]$tag
#> [1] "SF"
#> 
#> [[2]]$Token[[18]]$start
#> [1] 45
#> 
#> [[2]]$Token[[18]]$len
#> [1] 1
#> 
#> 
#> 
#> [[2]]$Score
#> [1] -95.38721
#> 
#> 
#> [[3]]
#> [[3]]$Token
#> [[3]]$Token[[1]]
#> [[3]]$Token[[1]]$form
#> [1] "안녕"
#> 
#> [[3]]$Token[[1]]$tag
#> [1] "NNG"
#> 
#> [[3]]$Token[[1]]$start
#> [1] 1
#> 
#> [[3]]$Token[[1]]$len
#> [1] 2
#> 
#> 
#> [[3]]$Token[[2]]
#> [[3]]$Token[[2]]$form
#> [1] "하"
#> 
#> [[3]]$Token[[2]]$tag
#> [1] "XSA"
#> 
#> [[3]]$Token[[2]]$start
#> [1] 3
#> 
#> [[3]]$Token[[2]]$len
#> [1] 1
#> 
#> 
#> [[3]]$Token[[3]]
#> [[3]]$Token[[3]]$form
#> [1] "시"
#> 
#> [[3]]$Token[[3]]$tag
#> [1] "EP"
#> 
#> [[3]]$Token[[3]]$start
#> [1] 4
#> 
#> [[3]]$Token[[3]]$len
#> [1] 1
#> 
#> 
#> [[3]]$Token[[4]]
#> [[3]]$Token[[4]]$form
#> [1] "어요"
#> 
#> [[3]]$Token[[4]]$tag
#> [1] "EF"
#> 
#> [[3]]$Token[[4]]$start
#> [1] 4
#> 
#> [[3]]$Token[[4]]$len
#> [1] 2
#> 
#> 
#> [[3]]$Token[[5]]
#> [[3]]$Token[[5]]$form
#> [1] "kiwi"
#> 
#> [[3]]$Token[[5]]$tag
#> [1] "SL"
#> 
#> [[3]]$Token[[5]]$start
#> [1] 7
#> 
#> [[3]]$Token[[5]]$len
#> [1] 4
#> 
#> 
#> [[3]]$Token[[6]]
#> [[3]]$Token[[6]]$form
#> [1] "형태소"
#> 
#> [[3]]$Token[[6]]$tag
#> [1] "NNG"
#> 
#> [[3]]$Token[[6]]$start
#> [1] 12
#> 
#> [[3]]$Token[[6]]$len
#> [1] 3
#> 
#> 
#> [[3]]$Token[[7]]
#> [[3]]$Token[[7]]$form
#> [1] "분석기"
#> 
#> [[3]]$Token[[7]]$tag
#> [1] "NNG"
#> 
#> [[3]]$Token[[7]]$start
#> [1] 16
#> 
#> [[3]]$Token[[7]]$len
#> [1] 3
#> 
#> 
#> [[3]]$Token[[8]]
#> [[3]]$Token[[8]]$form
#> [1] "의"
#> 
#> [[3]]$Token[[8]]$tag
#> [1] "JKG"
#> 
#> [[3]]$Token[[8]]$start
#> [1] 19
#> 
#> [[3]]$Token[[8]]$len
#> [1] 1
#> 
#> 
#> [[3]]$Token[[9]]
#> [[3]]$Token[[9]]$form
#> [1] "R"
#> 
#> [[3]]$Token[[9]]$tag
#> [1] "SL"
#> 
#> [[3]]$Token[[9]]$start
#> [1] 21
#> 
#> [[3]]$Token[[9]]$len
#> [1] 1
#> 
#> 
#> [[3]]$Token[[10]]
#> [[3]]$Token[[10]]$form
#> [1] "wrapper"
#> 
#> [[3]]$Token[[10]]$tag
#> [1] "SL"
#> 
#> [[3]]$Token[[10]]$start
#> [1] 23
#> 
#> [[3]]$Token[[10]]$len
#> [1] 7
#> 
#> 
#> [[3]]$Token[[11]]
#> [[3]]$Token[[11]]$form
#> [1] "이"
#> 
#> [[3]]$Token[[11]]$tag
#> [1] "VCP"
#> 
#> [[3]]$Token[[11]]$start
#> [1] 30
#> 
#> [[3]]$Token[[11]]$len
#> [1] 1
#> 
#> 
#> [[3]]$Token[[12]]
#> [[3]]$Token[[12]]$form
#> [1] "ᆫ"
#> 
#> [[3]]$Token[[12]]$tag
#> [1] "ETM"
#> 
#> [[3]]$Token[[12]]$start
#> [1] 30
#> 
#> [[3]]$Token[[12]]$len
#> [1] 1
#> 
#> 
#> [[3]]$Token[[13]]
#> [[3]]$Token[[13]]$form
#> [1] "elbird"
#> 
#> [[3]]$Token[[13]]$tag
#> [1] "SL"
#> 
#> [[3]]$Token[[13]]$start
#> [1] 32
#> 
#> [[3]]$Token[[13]]$len
#> [1] 6
#> 
#> 
#> [[3]]$Token[[14]]
#> [[3]]$Token[[14]]$form
#> [1] "를"
#> 
#> [[3]]$Token[[14]]$tag
#> [1] "JKO"
#> 
#> [[3]]$Token[[14]]$start
#> [1] 38
#> 
#> [[3]]$Token[[14]]$len
#> [1] 1
#> 
#> 
#> [[3]]$Token[[15]]
#> [[3]]$Token[[15]]$form
#> [1] "소개"
#> 
#> [[3]]$Token[[15]]$tag
#> [1] "NNG"
#> 
#> [[3]]$Token[[15]]$start
#> [1] 40
#> 
#> [[3]]$Token[[15]]$len
#> [1] 2
#> 
#> 
#> [[3]]$Token[[16]]
#> [[3]]$Token[[16]]$form
#> [1] "하"
#> 
#> [[3]]$Token[[16]]$tag
#> [1] "XSV"
#> 
#> [[3]]$Token[[16]]$start
#> [1] 42
#> 
#> [[3]]$Token[[16]]$len
#> [1] 1
#> 
#> 
#> [[3]]$Token[[17]]
#> [[3]]$Token[[17]]$form
#> [1] "ᆸ니다"
#> 
#> [[3]]$Token[[17]]$tag
#> [1] "EF"
#> 
#> [[3]]$Token[[17]]$start
#> [1] 42
#> 
#> [[3]]$Token[[17]]$len
#> [1] 3
#> 
#> 
#> [[3]]$Token[[18]]
#> [[3]]$Token[[18]]$form
#> [1] "."
#> 
#> [[3]]$Token[[18]]$tag
#> [1] "SF"
#> 
#> [[3]]$Token[[18]]$start
#> [1] 45
#> 
#> [[3]]$Token[[18]]$len
#> [1] 1
#> 
#> 
#> 
#> [[3]]$Score
#> [1] -95.38721
analyze(c("안녕하세요 kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다."), top_n = 1)
#> [[1]]
#> [[1]]$Token
#> [[1]]$Token[[1]]
#> [[1]]$Token[[1]]$form
#> [1] "안녕하세요"
#> 
#> [[1]]$Token[[1]]$tag
#> [1] "NNP"
#> 
#> [[1]]$Token[[1]]$start
#> [1] 1
#> 
#> [[1]]$Token[[1]]$len
#> [1] 5
#> 
#> 
#> [[1]]$Token[[2]]
#> [[1]]$Token[[2]]$form
#> [1] "kiwi"
#> 
#> [[1]]$Token[[2]]$tag
#> [1] "SL"
#> 
#> [[1]]$Token[[2]]$start
#> [1] 7
#> 
#> [[1]]$Token[[2]]$len
#> [1] 4
#> 
#> 
#> [[1]]$Token[[3]]
#> [[1]]$Token[[3]]$form
#> [1] "형태소"
#> 
#> [[1]]$Token[[3]]$tag
#> [1] "NNG"
#> 
#> [[1]]$Token[[3]]$start
#> [1] 12
#> 
#> [[1]]$Token[[3]]$len
#> [1] 3
#> 
#> 
#> [[1]]$Token[[4]]
#> [[1]]$Token[[4]]$form
#> [1] "분석기"
#> 
#> [[1]]$Token[[4]]$tag
#> [1] "NNG"
#> 
#> [[1]]$Token[[4]]$start
#> [1] 16
#> 
#> [[1]]$Token[[4]]$len
#> [1] 3
#> 
#> 
#> [[1]]$Token[[5]]
#> [[1]]$Token[[5]]$form
#> [1] "의"
#> 
#> [[1]]$Token[[5]]$tag
#> [1] "JKG"
#> 
#> [[1]]$Token[[5]]$start
#> [1] 19
#> 
#> [[1]]$Token[[5]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[6]]
#> [[1]]$Token[[6]]$form
#> [1] "R"
#> 
#> [[1]]$Token[[6]]$tag
#> [1] "SL"
#> 
#> [[1]]$Token[[6]]$start
#> [1] 21
#> 
#> [[1]]$Token[[6]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[7]]
#> [[1]]$Token[[7]]$form
#> [1] "wrapper"
#> 
#> [[1]]$Token[[7]]$tag
#> [1] "SL"
#> 
#> [[1]]$Token[[7]]$start
#> [1] 23
#> 
#> [[1]]$Token[[7]]$len
#> [1] 7
#> 
#> 
#> [[1]]$Token[[8]]
#> [[1]]$Token[[8]]$form
#> [1] "이"
#> 
#> [[1]]$Token[[8]]$tag
#> [1] "VCP"
#> 
#> [[1]]$Token[[8]]$start
#> [1] 30
#> 
#> [[1]]$Token[[8]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[9]]
#> [[1]]$Token[[9]]$form
#> [1] "ᆫ"
#> 
#> [[1]]$Token[[9]]$tag
#> [1] "ETM"
#> 
#> [[1]]$Token[[9]]$start
#> [1] 30
#> 
#> [[1]]$Token[[9]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[10]]
#> [[1]]$Token[[10]]$form
#> [1] "elbird"
#> 
#> [[1]]$Token[[10]]$tag
#> [1] "SL"
#> 
#> [[1]]$Token[[10]]$start
#> [1] 32
#> 
#> [[1]]$Token[[10]]$len
#> [1] 6
#> 
#> 
#> [[1]]$Token[[11]]
#> [[1]]$Token[[11]]$form
#> [1] "를"
#> 
#> [[1]]$Token[[11]]$tag
#> [1] "JKO"
#> 
#> [[1]]$Token[[11]]$start
#> [1] 38
#> 
#> [[1]]$Token[[11]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[12]]
#> [[1]]$Token[[12]]$form
#> [1] "소개"
#> 
#> [[1]]$Token[[12]]$tag
#> [1] "NNG"
#> 
#> [[1]]$Token[[12]]$start
#> [1] 40
#> 
#> [[1]]$Token[[12]]$len
#> [1] 2
#> 
#> 
#> [[1]]$Token[[13]]
#> [[1]]$Token[[13]]$form
#> [1] "하"
#> 
#> [[1]]$Token[[13]]$tag
#> [1] "XSV"
#> 
#> [[1]]$Token[[13]]$start
#> [1] 42
#> 
#> [[1]]$Token[[13]]$len
#> [1] 1
#> 
#> 
#> [[1]]$Token[[14]]
#> [[1]]$Token[[14]]$form
#> [1] "ᆸ니다"
#> 
#> [[1]]$Token[[14]]$tag
#> [1] "EF"
#> 
#> [[1]]$Token[[14]]$start
#> [1] 42
#> 
#> [[1]]$Token[[14]]$len
#> [1] 3
#> 
#> 
#> [[1]]$Token[[15]]
#> [[1]]$Token[[15]]$form
#> [1] "."
#> 
#> [[1]]$Token[[15]]$tag
#> [1] "SF"
#> 
#> [[1]]$Token[[15]]$start
#> [1] 45
#> 
#> [[1]]$Token[[15]]$len
#> [1] 1
#> 
#> 
#> 
#> [[1]]$Score
#> [1] -91.58401
```

## 형태소 태그

[kiwipiepy](https://github.com/bab2min/kiwipiepy)패키지에서 사용하는
[형태소
태그](https://github.com/bab2min/kiwipiepy#%ED%92%88%EC%82%AC-%ED%83%9C%EA%B7%B8)는
아래와 같습니다.

-   The table below is fetched at 2022-04-03 05:38:45 Etc/UTC.

| 대분류                    | 태그      | 설명                                                        |
|:--------------------------|:----------|:------------------------------------------------------------|
| 체언(N)                   | NNG       | 일반 명사                                                   |
| 체언(N)                   | NNP       | 고유 명사                                                   |
| 체언(N)                   | NNB       | 의존 명사                                                   |
| 체언(N)                   | NR        | 수사                                                        |
| 체언(N)                   | NP        | 대명사                                                      |
| 용언(V)                   | VV        | 동사                                                        |
| 용언(V)                   | VA        | 형용사                                                      |
| 용언(V)                   | VX        | 보조 용언                                                   |
| 용언(V)                   | VCP       | 긍정 지시사(이다)                                           |
| 용언(V)                   | VCN       | 부정 지시사(아니다)                                         |
| 관형사                    | MM        | 관형사                                                      |
| 부사(MA)                  | MAG       | 일반 부사                                                   |
| 부사(MA)                  | MAJ       | 접속 부사                                                   |
| 감탄사                    | IC        | 감탄사                                                      |
| 조사(J)                   | JKS       | 주격 조사                                                   |
| 조사(J)                   | JKC       | 보격 조사                                                   |
| 조사(J)                   | JKG       | 관형격 조사                                                 |
| 조사(J)                   | JKO       | 목적격 조사                                                 |
| 조사(J)                   | JKB       | 부사격 조사                                                 |
| 조사(J)                   | JKV       | 호격 조사                                                   |
| 조사(J)                   | JKQ       | 인용격 조사                                                 |
| 조사(J)                   | JX        | 보조사                                                      |
| 조사(J)                   | JC        | 접속 조사                                                   |
| 어미(E)                   | EP        | 선어말 어미                                                 |
| 어미(E)                   | EF        | 종결 어미                                                   |
| 어미(E)                   | EC        | 연결 어미                                                   |
| 어미(E)                   | ETN       | 명사형 전성 어미                                            |
| 어미(E)                   | ETM       | 관형형 전성 어미                                            |
| 접두사                    | XPN       | 체언 접두사                                                 |
| 접미사(XS)                | XSN       | 명사 파생 접미사                                            |
| 접미사(XS)                | XSV       | 동사 파생 접미사                                            |
| 접미사(XS)                | XSA       | 형용사 파생 접미사                                          |
| 어근                      | XR        | 어근                                                        |
| 부호, 외국어, 특수문자(S) | SF        | 종결 부호(. ! ?)                                            |
| 부호, 외국어, 특수문자(S) | SP        | 구분 부호(, / : ;)                                          |
| 부호, 외국어, 특수문자(S) | SS        | 인용 부호 및 괄호(’ ” ( ) \[ \] \< \> { } ― ‘ ’ “ ” ≪ ≫ 등) |
| 부호, 외국어, 특수문자(S) | SE        | 줄임표(…)                                                   |
| 부호, 외국어, 특수문자(S) | SO        | 붙임표(- \~)                                                |
| 부호, 외국어, 특수문자(S) | SW        | 기타 특수 문자                                              |
| 부호, 외국어, 특수문자(S) | SL        | 알파벳(A-Z a-z)                                             |
| 부호, 외국어, 특수문자(S) | SH        | 한자                                                        |
| 부호, 외국어, 특수문자(S) | SN        | 숫자(0-9)                                                   |
| 분석 불능                 | UN        | 분석 불능\*                                                 |
| 웹(W)                     | W_URL     | URL 주소\*                                                  |
| 웹(W)                     | W_EMAIL   | 이메일 주소\*                                               |
| 웹(W)                     | W_HASHTAG | 해시태그(#abcd)\*                                           |
| 웹(W)                     | W_MENTION | 멘션(@abcd)\*                                               |

## 특별히 감사

### kiwi 패키지

kiwi 패키지 제작자 이신 [bab2min](https://github.com/bab2min)님께
감사드립니다.

### logo

로고 제작에 [의견](https://github.com/mrchypark/elbird/issues/6)을 주신
[jhk0530](https://github.com/jhk0530)님께 감사드립니다.
