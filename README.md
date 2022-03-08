
<!-- README.md is generated from README.Rmd. Please edit that file -->

# elbird <img src="man/figures/logo.png" align="right" height=140/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/elbird)](https://CRAN.R-project.org/package=elbird)
[![](https://cranlogs.r-pkg.org/badges/elbird)](https://cran.r-project.org/package=elbird)
<!-- badges: end -->

# [한국어 버전](./README_kr.md)는 [여기](./README_kr.md)에서 확인하세요.

The `elbird` package is a morpheme analysis package packed with
[kiwipiepy](https://github.com/bab2min/kiwipiepy). It is based on cpp
package `kiwi` and that has convenient functions such as faster
performance compared to other tokenizers, easy user dictionary addition,
unregistered noun extraction (not implemented in `elbird` yet).

## Installation

### CRAN *\!NOT YET\!*

You can install the released version of elbird from
[CRAN](https://CRAN.R-project.org) with:

``` r
# CRAN *!NOT YET!*
install.packages("elbird")

# Dev version
install.packages("elbird", repos = 'https://mrchypark.r-universe.dev')
```

## Example

The examples below introduce the behavior of `elbird`’s functions.

### tokenize

Basically, the `tokenize` function that uses the output of the
`tokenize` function of the
[kiwipiepy](https://github.com/bab2min/kiwipiepy) package as it is, and
the `tokenize_tbl` organized in tibble data type, and grammar
compatibility with tidytext are supported provides an `tokenize_tidy`
function.

``` r
library(elbird)
tokenize("안녕하세요 kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다.")
#> [[1]]
#> [[1]][[1]]
#> Token(form='안녕', tag='NNG', start=0, len=2)
#> 
#> [[1]][[2]]
#> Token(form='하', tag='XSA', start=2, len=1)
#> 
#> [[1]][[3]]
#> Token(form='시', tag='EP', start=4, len=1)
#> 
#> [[1]][[4]]
#> Token(form='어요', tag='EC', start=3, len=2)
#> 
#> [[1]][[5]]
#> Token(form='kiwi', tag='SL', start=6, len=4)
#> 
#> [[1]][[6]]
#> Token(form='형태소', tag='NNG', start=11, len=3)
#> 
#> [[1]][[7]]
#> Token(form='분석', tag='NNG', start=15, len=2)
#> 
#> [[1]][[8]]
#> Token(form='기', tag='NNB', start=17, len=1)
#> 
#> [[1]][[9]]
#> Token(form='의', tag='JKG', start=18, len=1)
#> 
#> [[1]][[10]]
#> Token(form='R', tag='SL', start=20, len=1)
#> 
#> [[1]][[11]]
#> Token(form='wrapper', tag='SL', start=22, len=7)
#> 
#> [[1]][[12]]
#> Token(form='이', tag='VCP', start=29, len=1)
#> 
#> [[1]][[13]]
#> Token(form='ᆫ', tag='ETM', start=30, len=0)
#> 
#> [[1]][[14]]
#> Token(form='elbird', tag='SL', start=31, len=6)
#> 
#> [[1]][[15]]
#> Token(form='를', tag='JKO', start=37, len=1)
#> 
#> [[1]][[16]]
#> Token(form='소개', tag='NNG', start=39, len=2)
#> 
#> [[1]][[17]]
#> Token(form='하', tag='XSV', start=41, len=1)
#> 
#> [[1]][[18]]
#> Token(form='ᆸ니다', tag='EF', start=42, len=2)
#> 
#> [[1]][[19]]
#> Token(form='.', tag='SF', start=44, len=1)
tokenize_tbl("안녕하세요 kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다.")
#> # A tibble: 19 × 5
#>    unique form    tag   start   end
#>    <chr>  <chr>   <chr> <int> <int>
#>  1 1      안녕    NNG       0     2
#>  2 1      하      XSA       2     1
#>  3 1      시      EP        4     1
#>  4 1      어요    EC        3     2
#>  5 1      kiwi    SL        6     4
#>  6 1      형태소  NNG      11     3
#>  7 1      분석    NNG      15     2
#>  8 1      기      NNB      17     1
#>  9 1      의      JKG      18     1
#> 10 1      R       SL       20     1
#> 11 1      wrapper SL       22     7
#> 12 1      이      VCP      29     1
#> 13 1      ᆫ       ETM      30     0
#> 14 1      elbird  SL       31     6
#> 15 1      를      JKO      37     1
#> 16 1      소개    NNG      39     2
#> 17 1      하      XSV      41     1
#> 18 1      ᆸ니다   EF       42     2
#> 19 1      .       SF       44     1
tokenize_tidy("안녕하세요 kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다.")
#> [[1]]
#>  [1] "안녕/NNG"   "하/XSA"     "시/EP"      "어요/EC"    "kiwi/SL"   
#>  [6] "형태소/NNG" "분석/NNG"   "기/NNB"     "의/JKG"     "R/SL"      
#> [11] "wrapper/SL" "이/VCP"     "ᆫ/ETM"       "elbird/SL"  "를/JKO"    
#> [16] "소개/NNG"   "하/XSV"     "ᆸ니다/EF"    "./SF"
```

Multiple sentences are input as `vector` or `list` and output as `list`.

``` r
tokenize(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
#> [[1]]
#> [[1]][[1]]
#> Token(form='새롭', tag='VA', start=0, len=2)
#> 
#> [[1]][[2]]
#> Token(form='게', tag='EC', start=2, len=1)
#> 
#> [[1]][[3]]
#> Token(form='작성', tag='NNG', start=4, len=2)
#> 
#> [[1]][[4]]
#> Token(form='되', tag='XSV', start=6, len=1)
#> 
#> [[1]][[5]]
#> Token(form='ᆫ', tag='ETM', start=7, len=0)
#> 
#> [[1]][[6]]
#> Token(form='패키지', tag='NNG', start=8, len=3)
#> 
#> [[1]][[7]]
#> Token(form='이', tag='VCP', start=12, len=1)
#> 
#> [[1]][[8]]
#> Token(form='ᆸ니다', tag='EF', start=13, len=2)
#> 
#> [[1]][[9]]
#> Token(form='.', tag='SF', start=15, len=1)
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> Token(form='tidytext', tag='SL', start=0, len=8)
#> 
#> [[2]][[2]]
#> Token(form='와', tag='JKB', start=8, len=1)
#> 
#> [[2]][[3]]
#> Token(form='의', tag='JKG', start=9, len=1)
#> 
#> [[2]][[4]]
#> Token(form='호환', tag='NNG', start=11, len=2)
#> 
#> [[2]][[5]]
#> Token(form='을', tag='JKO', start=13, len=1)
#> 
#> [[2]][[6]]
#> Token(form='염두', tag='NNG', start=15, len=2)
#> 
#> [[2]][[7]]
#> Token(form='하', tag='XSV', start=17, len=1)
#> 
#> [[2]][[8]]
#> Token(form='고', tag='EC', start=18, len=1)
#> 
#> [[2]][[9]]
#> Token(form='작성', tag='NNG', start=20, len=2)
#> 
#> [[2]][[10]]
#> Token(form='하', tag='XSV', start=24, len=0)
#> 
#> [[2]][[11]]
#> Token(form='었', tag='EP', start=23, len=1)
#> 
#> [[2]][[12]]
#> Token(form='습니다', tag='EF', start=24, len=3)
#> 
#> [[2]][[13]]
#> Token(form='.', tag='SF', start=27, len=1)
tokenize_tbl(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
#> # A tibble: 22 × 5
#>    unique form     tag   start   end
#>    <chr>  <chr>    <chr> <int> <int>
#>  1 1      새롭     VA        0     2
#>  2 1      게       EC        2     1
#>  3 1      작성     NNG       4     2
#>  4 1      되       XSV       6     1
#>  5 1      ᆫ        ETM       7     0
#>  6 1      패키지   NNG       8     3
#>  7 1      이       VCP      12     1
#>  8 1      ᆸ니다    EF       13     2
#>  9 1      .        SF       15     1
#> 10 2      tidytext SL        0     8
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

The `tokenize_tidy` function can also be used as `tokenize_tt` and
`tokenize_tidytext`. Below is an example of using it with the `tidytext`
package. The `tar` below is the target text for morpheme analysis.

``` r
suppressMessages(library(dplyr))
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

This is an example of using `tokenize_tidy` of `elbird` as a tokenizer
with `tar` as `unnest_tokens` which is a function of `tidytext` package.

``` r
tar %>% 
  unnest_tokens(
    input = content,
    output = word,
    token = tokenize_tidy
    )
#> # A tibble: 4,563 × 2
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
#> # … with 4,553 more rows
```

### analyze

In addition, an `analyze` function is provided that uses the output of
the `analyze` function of the
[kiwipiepy](https://github.com/bab2min/kiwipiepy) package as it is.

``` r
library(elbird)
analyze("안녕하세요 kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다.")
#> [[1]]
#> [[1]][[1]]
#> [[1]][[1]][[1]]
#> Token(form='안녕', tag='NNG', start=0, len=2)
#> 
#> [[1]][[1]][[2]]
#> Token(form='하', tag='XSA', start=2, len=1)
#> 
#> [[1]][[1]][[3]]
#> Token(form='시', tag='EP', start=4, len=1)
#> 
#> [[1]][[1]][[4]]
#> Token(form='어요', tag='EC', start=3, len=2)
#> 
#> [[1]][[1]][[5]]
#> Token(form='kiwi', tag='SL', start=6, len=4)
#> 
#> [[1]][[1]][[6]]
#> Token(form='형태소', tag='NNG', start=11, len=3)
#> 
#> [[1]][[1]][[7]]
#> Token(form='분석', tag='NNG', start=15, len=2)
#> 
#> [[1]][[1]][[8]]
#> Token(form='기', tag='NNB', start=17, len=1)
#> 
#> [[1]][[1]][[9]]
#> Token(form='의', tag='JKG', start=18, len=1)
#> 
#> [[1]][[1]][[10]]
#> Token(form='R', tag='SL', start=20, len=1)
#> 
#> [[1]][[1]][[11]]
#> Token(form='wrapper', tag='SL', start=22, len=7)
#> 
#> [[1]][[1]][[12]]
#> Token(form='이', tag='VCP', start=29, len=1)
#> 
#> [[1]][[1]][[13]]
#> Token(form='ᆫ', tag='ETM', start=30, len=0)
#> 
#> [[1]][[1]][[14]]
#> Token(form='elbird', tag='SL', start=31, len=6)
#> 
#> [[1]][[1]][[15]]
#> Token(form='를', tag='JKO', start=37, len=1)
#> 
#> [[1]][[1]][[16]]
#> Token(form='소개', tag='NNG', start=39, len=2)
#> 
#> [[1]][[1]][[17]]
#> Token(form='하', tag='XSV', start=41, len=1)
#> 
#> [[1]][[1]][[18]]
#> Token(form='ᆸ니다', tag='EF', start=42, len=2)
#> 
#> [[1]][[1]][[19]]
#> Token(form='.', tag='SF', start=44, len=1)
#> 
#> 
#> [[1]][[2]]
#> [1] -97.36888
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [[2]][[1]][[1]]
#> Token(form='안녕', tag='NNG', start=0, len=2)
#> 
#> [[2]][[1]][[2]]
#> Token(form='하', tag='XSA', start=2, len=1)
#> 
#> [[2]][[1]][[3]]
#> Token(form='시', tag='EP', start=4, len=1)
#> 
#> [[2]][[1]][[4]]
#> Token(form='어요', tag='EC', start=3, len=2)
#> 
#> [[2]][[1]][[5]]
#> Token(form='kiwi', tag='SL', start=6, len=4)
#> 
#> [[2]][[1]][[6]]
#> Token(form='형태소', tag='NNG', start=11, len=3)
#> 
#> [[2]][[1]][[7]]
#> Token(form='분석', tag='NNG', start=15, len=2)
#> 
#> [[2]][[1]][[8]]
#> Token(form='기', tag='NNG', start=17, len=1)
#> 
#> [[2]][[1]][[9]]
#> Token(form='의', tag='JKG', start=18, len=1)
#> 
#> [[2]][[1]][[10]]
#> Token(form='R', tag='SL', start=20, len=1)
#> 
#> [[2]][[1]][[11]]
#> Token(form='wrapper', tag='SL', start=22, len=7)
#> 
#> [[2]][[1]][[12]]
#> Token(form='이', tag='VCP', start=29, len=1)
#> 
#> [[2]][[1]][[13]]
#> Token(form='ᆫ', tag='ETM', start=30, len=0)
#> 
#> [[2]][[1]][[14]]
#> Token(form='elbird', tag='SL', start=31, len=6)
#> 
#> [[2]][[1]][[15]]
#> Token(form='를', tag='JKO', start=37, len=1)
#> 
#> [[2]][[1]][[16]]
#> Token(form='소개', tag='NNG', start=39, len=2)
#> 
#> [[2]][[1]][[17]]
#> Token(form='하', tag='XSV', start=41, len=1)
#> 
#> [[2]][[1]][[18]]
#> Token(form='ᆸ니다', tag='EF', start=42, len=2)
#> 
#> [[2]][[1]][[19]]
#> Token(form='.', tag='SF', start=44, len=1)
#> 
#> 
#> [[2]][[2]]
#> [1] -97.94218
#> 
#> 
#> [[3]]
#> [[3]][[1]]
#> [[3]][[1]][[1]]
#> Token(form='안녕', tag='NNG', start=0, len=2)
#> 
#> [[3]][[1]][[2]]
#> Token(form='하', tag='XSA', start=2, len=1)
#> 
#> [[3]][[1]][[3]]
#> Token(form='시', tag='EP', start=4, len=1)
#> 
#> [[3]][[1]][[4]]
#> Token(form='어요', tag='EC', start=3, len=2)
#> 
#> [[3]][[1]][[5]]
#> Token(form='kiwi', tag='SL', start=6, len=4)
#> 
#> [[3]][[1]][[6]]
#> Token(form='형태소', tag='NNG', start=11, len=3)
#> 
#> [[3]][[1]][[7]]
#> Token(form='분석', tag='NNG', start=15, len=2)
#> 
#> [[3]][[1]][[8]]
#> Token(form='기', tag='ETN', start=17, len=1)
#> 
#> [[3]][[1]][[9]]
#> Token(form='의', tag='JKG', start=18, len=1)
#> 
#> [[3]][[1]][[10]]
#> Token(form='R', tag='SL', start=20, len=1)
#> 
#> [[3]][[1]][[11]]
#> Token(form='wrapper', tag='SL', start=22, len=7)
#> 
#> [[3]][[1]][[12]]
#> Token(form='이', tag='VCP', start=29, len=1)
#> 
#> [[3]][[1]][[13]]
#> Token(form='ᆫ', tag='ETM', start=30, len=0)
#> 
#> [[3]][[1]][[14]]
#> Token(form='elbird', tag='SL', start=31, len=6)
#> 
#> [[3]][[1]][[15]]
#> Token(form='를', tag='JKO', start=37, len=1)
#> 
#> [[3]][[1]][[16]]
#> Token(form='소개', tag='NNG', start=39, len=2)
#> 
#> [[3]][[1]][[17]]
#> Token(form='하', tag='XSV', start=41, len=1)
#> 
#> [[3]][[1]][[18]]
#> Token(form='ᆸ니다', tag='EF', start=42, len=2)
#> 
#> [[3]][[1]][[19]]
#> Token(form='.', tag='SF', start=44, len=1)
#> 
#> 
#> [[3]][[2]]
#> [1] -98.88614
analyze(c("안녕하세요","kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다."))
#> Warning in if (is.na(item)) break: the condition has length > 1 and only the
#> first element will be used

#> Warning in if (is.na(item)) break: the condition has length > 1 and only the
#> first element will be used
#> [[1]]
#> [[1]][[1]]
#> [[1]][[1]][[1]]
#> Token(form='안녕', tag='NNG', start=0, len=2)
#> 
#> [[1]][[1]][[2]]
#> Token(form='하', tag='XSA', start=2, len=1)
#> 
#> [[1]][[1]][[3]]
#> Token(form='시', tag='EP', start=4, len=1)
#> 
#> [[1]][[1]][[4]]
#> Token(form='어요', tag='EC', start=3, len=2)
#> 
#> 
#> [[1]][[2]]
#> [1] -18.16951
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [[2]][[1]][[1]]
#> Token(form='안녕', tag='NNG', start=0, len=2)
#> 
#> [[2]][[1]][[2]]
#> Token(form='하', tag='XSA', start=2, len=1)
#> 
#> [[2]][[1]][[3]]
#> Token(form='시', tag='EP', start=4, len=1)
#> 
#> [[2]][[1]][[4]]
#> Token(form='어요', tag='EF', start=3, len=2)
#> 
#> 
#> [[2]][[2]]
#> [1] -22.45279
#> 
#> 
#> [[3]]
#> [[3]][[1]]
#> [[3]][[1]][[1]]
#> Token(form='안녕', tag='NNG', start=0, len=2)
#> 
#> [[3]][[1]][[2]]
#> Token(form='하', tag='XSA', start=2, len=1)
#> 
#> [[3]][[1]][[3]]
#> Token(form='세요', tag='EF', start=3, len=2)
#> 
#> 
#> [[3]][[2]]
#> [1] -28.44329
#> 
#> 
#> [[4]]
#> [[4]][[1]]
#> [[4]][[1]][[1]]
#> Token(form='kiwi', tag='SL', start=0, len=4)
#> 
#> [[4]][[1]][[2]]
#> Token(form='형태소', tag='NNG', start=5, len=3)
#> 
#> [[4]][[1]][[3]]
#> Token(form='분석', tag='NNG', start=9, len=2)
#> 
#> [[4]][[1]][[4]]
#> Token(form='기', tag='NNB', start=11, len=1)
#> 
#> [[4]][[1]][[5]]
#> Token(form='의', tag='JKG', start=12, len=1)
#> 
#> [[4]][[1]][[6]]
#> Token(form='R', tag='SL', start=14, len=1)
#> 
#> [[4]][[1]][[7]]
#> Token(form='wrapper', tag='SL', start=16, len=7)
#> 
#> [[4]][[1]][[8]]
#> Token(form='이', tag='VCP', start=23, len=1)
#> 
#> [[4]][[1]][[9]]
#> Token(form='ᆫ', tag='ETM', start=24, len=0)
#> 
#> [[4]][[1]][[10]]
#> Token(form='elbird', tag='SL', start=25, len=6)
#> 
#> [[4]][[1]][[11]]
#> Token(form='를', tag='JKO', start=31, len=1)
#> 
#> [[4]][[1]][[12]]
#> Token(form='소개', tag='NNG', start=33, len=2)
#> 
#> [[4]][[1]][[13]]
#> Token(form='하', tag='XSV', start=35, len=1)
#> 
#> [[4]][[1]][[14]]
#> Token(form='ᆸ니다', tag='EF', start=36, len=2)
#> 
#> [[4]][[1]][[15]]
#> Token(form='.', tag='SF', start=38, len=1)
#> 
#> 
#> [[4]][[2]]
#> [1] -84.13857
#> 
#> 
#> [[5]]
#> [[5]][[1]]
#> [[5]][[1]][[1]]
#> Token(form='kiwi', tag='SL', start=0, len=4)
#> 
#> [[5]][[1]][[2]]
#> Token(form='형태소', tag='NNG', start=5, len=3)
#> 
#> [[5]][[1]][[3]]
#> Token(form='분석', tag='NNG', start=9, len=2)
#> 
#> [[5]][[1]][[4]]
#> Token(form='기', tag='NNG', start=11, len=1)
#> 
#> [[5]][[1]][[5]]
#> Token(form='의', tag='JKG', start=12, len=1)
#> 
#> [[5]][[1]][[6]]
#> Token(form='R', tag='SL', start=14, len=1)
#> 
#> [[5]][[1]][[7]]
#> Token(form='wrapper', tag='SL', start=16, len=7)
#> 
#> [[5]][[1]][[8]]
#> Token(form='이', tag='VCP', start=23, len=1)
#> 
#> [[5]][[1]][[9]]
#> Token(form='ᆫ', tag='ETM', start=24, len=0)
#> 
#> [[5]][[1]][[10]]
#> Token(form='elbird', tag='SL', start=25, len=6)
#> 
#> [[5]][[1]][[11]]
#> Token(form='를', tag='JKO', start=31, len=1)
#> 
#> [[5]][[1]][[12]]
#> Token(form='소개', tag='NNG', start=33, len=2)
#> 
#> [[5]][[1]][[13]]
#> Token(form='하', tag='XSV', start=35, len=1)
#> 
#> [[5]][[1]][[14]]
#> Token(form='ᆸ니다', tag='EF', start=36, len=2)
#> 
#> [[5]][[1]][[15]]
#> Token(form='.', tag='SF', start=38, len=1)
#> 
#> 
#> [[5]][[2]]
#> [1] -84.71187
#> 
#> 
#> [[6]]
#> [[6]][[1]]
#> [[6]][[1]][[1]]
#> Token(form='kiwi', tag='SL', start=0, len=4)
#> 
#> [[6]][[1]][[2]]
#> Token(form='형태소', tag='NNG', start=5, len=3)
#> 
#> [[6]][[1]][[3]]
#> Token(form='분석', tag='NNG', start=9, len=2)
#> 
#> [[6]][[1]][[4]]
#> Token(form='기', tag='ETN', start=11, len=1)
#> 
#> [[6]][[1]][[5]]
#> Token(form='의', tag='JKG', start=12, len=1)
#> 
#> [[6]][[1]][[6]]
#> Token(form='R', tag='SL', start=14, len=1)
#> 
#> [[6]][[1]][[7]]
#> Token(form='wrapper', tag='SL', start=16, len=7)
#> 
#> [[6]][[1]][[8]]
#> Token(form='이', tag='VCP', start=23, len=1)
#> 
#> [[6]][[1]][[9]]
#> Token(form='ᆫ', tag='ETM', start=24, len=0)
#> 
#> [[6]][[1]][[10]]
#> Token(form='elbird', tag='SL', start=25, len=6)
#> 
#> [[6]][[1]][[11]]
#> Token(form='를', tag='JKO', start=31, len=1)
#> 
#> [[6]][[1]][[12]]
#> Token(form='소개', tag='NNG', start=33, len=2)
#> 
#> [[6]][[1]][[13]]
#> Token(form='하', tag='XSV', start=35, len=1)
#> 
#> [[6]][[1]][[14]]
#> Token(form='ᆸ니다', tag='EF', start=36, len=2)
#> 
#> [[6]][[1]][[15]]
#> Token(form='.', tag='SF', start=38, len=1)
#> 
#> 
#> [[6]][[2]]
#> [1] -85.65583
analyze(c("안녕하세요","kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다."), top_n = 2)
#> Warning in if (is.na(item)) break: the condition has length > 1 and only the
#> first element will be used

#> Warning in if (is.na(item)) break: the condition has length > 1 and only the
#> first element will be used
#> [[1]]
#> [[1]][[1]]
#> [[1]][[1]][[1]]
#> Token(form='안녕', tag='NNG', start=0, len=2)
#> 
#> [[1]][[1]][[2]]
#> Token(form='하', tag='XSA', start=2, len=1)
#> 
#> [[1]][[1]][[3]]
#> Token(form='시', tag='EP', start=4, len=1)
#> 
#> [[1]][[1]][[4]]
#> Token(form='어요', tag='EC', start=3, len=2)
#> 
#> 
#> [[1]][[2]]
#> [1] -18.16951
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [[2]][[1]][[1]]
#> Token(form='안녕', tag='NNG', start=0, len=2)
#> 
#> [[2]][[1]][[2]]
#> Token(form='하', tag='XSA', start=2, len=1)
#> 
#> [[2]][[1]][[3]]
#> Token(form='시', tag='EP', start=4, len=1)
#> 
#> [[2]][[1]][[4]]
#> Token(form='어요', tag='EF', start=3, len=2)
#> 
#> 
#> [[2]][[2]]
#> [1] -22.45279
#> 
#> 
#> [[3]]
#> [[3]][[1]]
#> [[3]][[1]][[1]]
#> Token(form='kiwi', tag='SL', start=0, len=4)
#> 
#> [[3]][[1]][[2]]
#> Token(form='형태소', tag='NNG', start=5, len=3)
#> 
#> [[3]][[1]][[3]]
#> Token(form='분석', tag='NNG', start=9, len=2)
#> 
#> [[3]][[1]][[4]]
#> Token(form='기', tag='NNB', start=11, len=1)
#> 
#> [[3]][[1]][[5]]
#> Token(form='의', tag='JKG', start=12, len=1)
#> 
#> [[3]][[1]][[6]]
#> Token(form='R', tag='SL', start=14, len=1)
#> 
#> [[3]][[1]][[7]]
#> Token(form='wrapper', tag='SL', start=16, len=7)
#> 
#> [[3]][[1]][[8]]
#> Token(form='이', tag='VCP', start=23, len=1)
#> 
#> [[3]][[1]][[9]]
#> Token(form='ᆫ', tag='ETM', start=24, len=0)
#> 
#> [[3]][[1]][[10]]
#> Token(form='elbird', tag='SL', start=25, len=6)
#> 
#> [[3]][[1]][[11]]
#> Token(form='를', tag='JKO', start=31, len=1)
#> 
#> [[3]][[1]][[12]]
#> Token(form='소개', tag='NNG', start=33, len=2)
#> 
#> [[3]][[1]][[13]]
#> Token(form='하', tag='XSV', start=35, len=1)
#> 
#> [[3]][[1]][[14]]
#> Token(form='ᆸ니다', tag='EF', start=36, len=2)
#> 
#> [[3]][[1]][[15]]
#> Token(form='.', tag='SF', start=38, len=1)
#> 
#> 
#> [[3]][[2]]
#> [1] -84.13857
#> 
#> 
#> [[4]]
#> [[4]][[1]]
#> [[4]][[1]][[1]]
#> Token(form='kiwi', tag='SL', start=0, len=4)
#> 
#> [[4]][[1]][[2]]
#> Token(form='형태소', tag='NNG', start=5, len=3)
#> 
#> [[4]][[1]][[3]]
#> Token(form='분석', tag='NNG', start=9, len=2)
#> 
#> [[4]][[1]][[4]]
#> Token(form='기', tag='NNG', start=11, len=1)
#> 
#> [[4]][[1]][[5]]
#> Token(form='의', tag='JKG', start=12, len=1)
#> 
#> [[4]][[1]][[6]]
#> Token(form='R', tag='SL', start=14, len=1)
#> 
#> [[4]][[1]][[7]]
#> Token(form='wrapper', tag='SL', start=16, len=7)
#> 
#> [[4]][[1]][[8]]
#> Token(form='이', tag='VCP', start=23, len=1)
#> 
#> [[4]][[1]][[9]]
#> Token(form='ᆫ', tag='ETM', start=24, len=0)
#> 
#> [[4]][[1]][[10]]
#> Token(form='elbird', tag='SL', start=25, len=6)
#> 
#> [[4]][[1]][[11]]
#> Token(form='를', tag='JKO', start=31, len=1)
#> 
#> [[4]][[1]][[12]]
#> Token(form='소개', tag='NNG', start=33, len=2)
#> 
#> [[4]][[1]][[13]]
#> Token(form='하', tag='XSV', start=35, len=1)
#> 
#> [[4]][[1]][[14]]
#> Token(form='ᆸ니다', tag='EF', start=36, len=2)
#> 
#> [[4]][[1]][[15]]
#> Token(form='.', tag='SF', start=38, len=1)
#> 
#> 
#> [[4]][[2]]
#> [1] -84.71187
```

### add user word

`elbird` connects and provides the add user word function of `kiwi`.

The `add_user_word` function receives words, morpheme tags, and weights
as inputs and adds a user dictionary to be used for analysis.

The example below is an example of adding a user dictionary and
modifying the result of `박찬` being divided and tokenized.

``` r
library(elbird)
tokenize_tbl("안녕하세요. 저는 박찬엽 입니다.")
#> # A tibble: 14 × 5
#>    unique form  tag   start   end
#>    <chr>  <chr> <chr> <int> <int>
#>  1 1      안녕  NNG       0     2
#>  2 1      하    XSA       2     1
#>  3 1      시    EP        4     1
#>  4 1      어요  EF        3     2
#>  5 1      .     SF        5     1
#>  6 1      저    NP        7     1
#>  7 1      는    JX        8     1
#>  8 1      박찬  NNP      10     2
#>  9 1      이    VCP      12     1
#> 10 1      어    EC       12     1
#> 11 1      ᆸ     NNG      13     0
#> 12 1      이    VCP      14     1
#> 13 1      ᆸ니다 EF       15     2
#> 14 1      .     SF       17     1
add_user_word("박찬엽","NNP",1)
tokenize_tbl("안녕하세요. 저는 박찬엽 입니다.")
#> # A tibble: 14 × 5
#>    unique form  tag   start   end
#>    <chr>  <chr> <chr> <int> <int>
#>  1 1      안녕  NNG       0     2
#>  2 1      하    XSA       2     1
#>  3 1      시    EP        4     1
#>  4 1      어요  EF        3     2
#>  5 1      .     SF        5     1
#>  6 1      저    NP        7     1
#>  7 1      는    JX        8     1
#>  8 1      박찬  NNP      10     2
#>  9 1      이    VCP      12     1
#> 10 1      어    EC       12     1
#> 11 1      ᆸ     NNG      13     0
#> 12 1      이    VCP      14     1
#> 13 1      ᆸ니다 EF       15     2
#> 14 1      .     SF       17     1
```

## tag set

[Tag
list](https://github.com/bab2min/kiwipiepy#%ED%92%88%EC%82%AC-%ED%83%9C%EA%B7%B8)
that used in [kiwipiepy](https://github.com/bab2min/kiwipiepy) package.

  - The table below is fetched at 2022-03-08 19:37:03 UTC.

<table class="kable_wrapper">

<tbody>

<tr>

<td>

| 대분류              | 태그         | 설명                                                  |
| :--------------- | :--------- | :-------------------------------------------------- |
| 체언(N)            | NNG        | 일반 명사                                               |
| 체언(N)            | NNP        | 고유 명사                                               |
| 체언(N)            | NNB        | 의존 명사                                               |
| 체언(N)            | NR         | 수사                                                  |
| 체언(N)            | NP         | 대명사                                                 |
| 용언(V)            | VV         | 동사                                                  |
| 용언(V)            | VA         | 형용사                                                 |
| 용언(V)            | VX         | 보조 용언                                               |
| 용언(V)            | VCP        | 긍정 지시사(이다)                                          |
| 용언(V)            | VCN        | 부정 지시사(아니다)                                         |
| 관형사              | MM         | 관형사                                                 |
| 부사(MA)           | MAG        | 일반 부사                                               |
| 부사(MA)           | MAJ        | 접속 부사                                               |
| 감탄사              | IC         | 감탄사                                                 |
| 조사(J)            | JKS        | 주격 조사                                               |
| 조사(J)            | JKC        | 보격 조사                                               |
| 조사(J)            | JKG        | 관형격 조사                                              |
| 조사(J)            | JKO        | 목적격 조사                                              |
| 조사(J)            | JKB        | 부사격 조사                                              |
| 조사(J)            | JKV        | 호격 조사                                               |
| 조사(J)            | JKQ        | 인용격 조사                                              |
| 조사(J)            | JX         | 보조사                                                 |
| 조사(J)            | JC         | 접속 조사                                               |
| 어미(E)            | EP         | 선어말 어미                                              |
| 어미(E)            | EF         | 종결 어미                                               |
| 어미(E)            | EC         | 연결 어미                                               |
| 어미(E)            | ETN        | 명사형 전성 어미                                           |
| 어미(E)            | ETM        | 관형형 전성 어미                                           |
| 접두사              | XPN        | 체언 접두사                                              |
| 접미사(XS)          | XSN        | 명사 파생 접미사                                           |
| 접미사(XS)          | XSV        | 동사 파생 접미사                                           |
| 접미사(XS)          | XSA        | 형용사 파생 접미사                                          |
| 어근               | XR         | 어근                                                  |
| 부호, 외국어, 특수문자(S) | SF         | 종결 부호(. \! ?)                                       |
| 부호, 외국어, 특수문자(S) | SP         | 구분 부호(, / : ;)                                      |
| 부호, 외국어, 특수문자(S) | SS         | 인용 부호 및 괄호(’ " ( ) \[ \] \< \> { } ― ‘ ’ “ ” ≪ ≫ 등) |
| 부호, 외국어, 특수문자(S) | SE         | 줄임표(…)                                              |
| 부호, 외국어, 특수문자(S) | SO         | 붙임표(- \~)                                           |
| 부호, 외국어, 특수문자(S) | SW         | 기타 특수 문자                                            |
| 부호, 외국어, 특수문자(S) | SL         | 알파벳(A-Z a-z)                                        |
| 부호, 외국어, 특수문자(S) | SH         | 한자                                                  |
| 부호, 외국어, 특수문자(S) | SN         | 숫자(0-9)                                             |
| 분석 불능            | UN         | 분석 불능\*                                             |
| 웹(W)             | W\_URL     | URL 주소\*                                            |
| 웹(W)             | W\_EMAIL   | 이메일 주소\*                                            |
| 웹(W)             | W\_HASHTAG | 해시태그(\#abcd)\*                                      |
| 웹(W)             | W\_MENTION | 멘션(@abcd)\*                                         |

</td>

</tr>

</tbody>

</table>

## Special Thanks to

### kiwi package

[bab2min](https://github.com/bab2min) with [kiwi
package](https://github.com/bab2min/Kiwi) author.

### logo

[jhk0530](https://github.com/jhk0530) with
[suggestion](https://github.com/mrchypark/elbird/issues/6).
