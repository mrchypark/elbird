
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Elbird <img src="man/figures/logo.png" align="right" height=140/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/Elbird)](https://CRAN.R-project.org/package=Elbird)
[![](https://cranlogs.r-pkg.org/badges/Elbird)](https://cran.r-project.org/package=Elbird)
<!-- badges: end -->

# Please check [Korean readme](./README_kr.md)

The ʻElbird`package is a morpheme analysis package packed with
[kiwipiepy](https://github.com/bab2min/kiwipiepy). It is based on cpp
package`kiwi`and that has convenient functions such as faster
performance compared to other analyzers, easy user dictionary addition,
unregistered noun extraction (not implemented in`Elbird\` yet).

## Installation

### Pre required

You need python before installing Elbird.

#### mothod 1

`Elbird` uses `conda` for python backend. Below is how to install
`conda`.

``` r
install.packages("reticulate")
reticulate::install_miniconda()
```

#### mothod 2

If the above installation does not work, execute the command below. The
two methods are not used together.

``` r
install.packages("remotes")
remotes::install_github("mrchypark/multilinguer")
multilinguer::install_conda()
```

#### pre install check

You can check install is success code below.

``` r
reticulate::conda_version()
#> [1] "conda 4.9.1"
```

### CRAN *\!NOT YET\!*

You can install the released version of Elbird from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("Elbird")
```

### Github

You can install the development version of Elbird from
[github](https://github.com/mrchypark/Elbird) with:

``` r
install.packages("remotes")
remotes::install_github("mrchypark/Elbird")
```

## Example

The examples below introduce the behavior of `Elbird`’s functions.

### analyze

Basically, the `analyze` function that uses the output of the `analyze`
function of the [kiwipiepy](https://github.com/bab2min/kiwipiepy)
package as it is, and the `analyze_tbl` organized in tibble data type,
and grammar compatibility with tidytext are supported provides an
`analyze_tidy` function.

``` r
library(Elbird)
analyze("안녕하세요 kiwi 형태소 분석기의 R wrapper인 Elbird를 소개합니다.")
#> [[1]]
#> [[1]][[1]]
#> [[1]][[1]][[1]]
#> [1] "안녕하세요"
#> 
#> [[1]][[1]][[2]]
#> [1] "NNP"
#> 
#> [[1]][[1]][[3]]
#> [1] 0
#> 
#> [[1]][[1]][[4]]
#> [1] 5
#> 
#> 
#> [[1]][[2]]
#> [[1]][[2]][[1]]
#> [1] "kiwi"
#> 
#> [[1]][[2]][[2]]
#> [1] "SL"
#> 
#> [[1]][[2]][[3]]
#> [1] 6
#> 
#> [[1]][[2]][[4]]
#> [1] 4
#> 
#> 
#> [[1]][[3]]
#> [[1]][[3]][[1]]
#> [1] "형태소"
#> 
#> [[1]][[3]][[2]]
#> [1] "NNG"
#> 
#> [[1]][[3]][[3]]
#> [1] 11
#> 
#> [[1]][[3]][[4]]
#> [1] 3
#> 
#> 
#> [[1]][[4]]
#> [[1]][[4]][[1]]
#> [1] "분석"
#> 
#> [[1]][[4]][[2]]
#> [1] "NNG"
#> 
#> [[1]][[4]][[3]]
#> [1] 15
#> 
#> [[1]][[4]][[4]]
#> [1] 2
#> 
#> 
#> [[1]][[5]]
#> [[1]][[5]][[1]]
#> [1] "기"
#> 
#> [[1]][[5]][[2]]
#> [1] "NNB"
#> 
#> [[1]][[5]][[3]]
#> [1] 17
#> 
#> [[1]][[5]][[4]]
#> [1] 1
#> 
#> 
#> [[1]][[6]]
#> [[1]][[6]][[1]]
#> [1] "의"
#> 
#> [[1]][[6]][[2]]
#> [1] "JKG"
#> 
#> [[1]][[6]][[3]]
#> [1] 18
#> 
#> [[1]][[6]][[4]]
#> [1] 1
#> 
#> 
#> [[1]][[7]]
#> [[1]][[7]][[1]]
#> [1] "R"
#> 
#> [[1]][[7]][[2]]
#> [1] "SL"
#> 
#> [[1]][[7]][[3]]
#> [1] 20
#> 
#> [[1]][[7]][[4]]
#> [1] 1
#> 
#> 
#> [[1]][[8]]
#> [[1]][[8]][[1]]
#> [1] "wrapper"
#> 
#> [[1]][[8]][[2]]
#> [1] "SL"
#> 
#> [[1]][[8]][[3]]
#> [1] 22
#> 
#> [[1]][[8]][[4]]
#> [1] 7
#> 
#> 
#> [[1]][[9]]
#> [[1]][[9]][[1]]
#> [1] "이"
#> 
#> [[1]][[9]][[2]]
#> [1] "VCP"
#> 
#> [[1]][[9]][[3]]
#> [1] 29
#> 
#> [[1]][[9]][[4]]
#> [1] 1
#> 
#> 
#> [[1]][[10]]
#> [[1]][[10]][[1]]
#> [1] "ᆫ"
#> 
#> [[1]][[10]][[2]]
#> [1] "ETM"
#> 
#> [[1]][[10]][[3]]
#> [1] 30
#> 
#> [[1]][[10]][[4]]
#> [1] 0
#> 
#> 
#> [[1]][[11]]
#> [[1]][[11]][[1]]
#> [1] "Elbird"
#> 
#> [[1]][[11]][[2]]
#> [1] "SL"
#> 
#> [[1]][[11]][[3]]
#> [1] 31
#> 
#> [[1]][[11]][[4]]
#> [1] 6
#> 
#> 
#> [[1]][[12]]
#> [[1]][[12]][[1]]
#> [1] "를"
#> 
#> [[1]][[12]][[2]]
#> [1] "JKO"
#> 
#> [[1]][[12]][[3]]
#> [1] 37
#> 
#> [[1]][[12]][[4]]
#> [1] 1
#> 
#> 
#> [[1]][[13]]
#> [[1]][[13]][[1]]
#> [1] "소개"
#> 
#> [[1]][[13]][[2]]
#> [1] "NNG"
#> 
#> [[1]][[13]][[3]]
#> [1] 39
#> 
#> [[1]][[13]][[4]]
#> [1] 2
#> 
#> 
#> [[1]][[14]]
#> [[1]][[14]][[1]]
#> [1] "하"
#> 
#> [[1]][[14]][[2]]
#> [1] "XSV"
#> 
#> [[1]][[14]][[3]]
#> [1] 41
#> 
#> [[1]][[14]][[4]]
#> [1] 1
#> 
#> 
#> [[1]][[15]]
#> [[1]][[15]][[1]]
#> [1] "ᆸ니다"
#> 
#> [[1]][[15]][[2]]
#> [1] "EF"
#> 
#> [[1]][[15]][[3]]
#> [1] 42
#> 
#> [[1]][[15]][[4]]
#> [1] 2
#> 
#> 
#> [[1]][[16]]
#> [[1]][[16]][[1]]
#> [1] "."
#> 
#> [[1]][[16]][[2]]
#> [1] "SF"
#> 
#> [[1]][[16]][[3]]
#> [1] 44
#> 
#> [[1]][[16]][[4]]
#> [1] 1
analyze_tbl("안녕하세요 kiwi 형태소 분석기의 R wrapper인 Elbird를 소개합니다.")
#> [[1]]
#> # A tibble: 16 x 4
#>    morph      tag   start   end
#>    <chr>      <chr> <int> <int>
#>  1 안녕하세요 NNP       0     5
#>  2 kiwi       SL        6     4
#>  3 형태소     NNG      11     3
#>  4 분석       NNG      15     2
#>  5 기         NNB      17     1
#>  6 의         JKG      18     1
#>  7 R          SL       20     1
#>  8 wrapper    SL       22     7
#>  9 이         VCP      29     1
#> 10 ᆫ          ETM      30     0
#> 11 Elbird     SL       31     6
#> 12 를         JKO      37     1
#> 13 소개       NNG      39     2
#> 14 하         XSV      41     1
#> 15 ᆸ니다      EF       42     2
#> 16 .          SF       44     1
analyze_tidy("안녕하세요 kiwi 형태소 분석기의 R wrapper인 Elbird를 소개합니다.")
#> [[1]]
#>  [1] "안녕하세요/NNP" "kiwi/SL"        "형태소/NNG"     "분석/NNG"      
#>  [5] "기/NNB"         "의/JKG"         "R/SL"           "wrapper/SL"    
#>  [9] "이/VCP"         "ᆫ/ETM"           "Elbird/SL"      "를/JKO"        
#> [13] "소개/NNG"       "하/XSV"         "ᆸ니다/EF"        "./SF"
```

Multiple sentences are input as `vector` or `list` and output as `list`.

``` r
analyze(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
#> [[1]]
#> [[1]][[1]]
#> [[1]][[1]][[1]]
#> [1] "새롭"
#> 
#> [[1]][[1]][[2]]
#> [1] "VA"
#> 
#> [[1]][[1]][[3]]
#> [1] 0
#> 
#> [[1]][[1]][[4]]
#> [1] 2
#> 
#> 
#> [[1]][[2]]
#> [[1]][[2]][[1]]
#> [1] "게"
#> 
#> [[1]][[2]][[2]]
#> [1] "EC"
#> 
#> [[1]][[2]][[3]]
#> [1] 2
#> 
#> [[1]][[2]][[4]]
#> [1] 1
#> 
#> 
#> [[1]][[3]]
#> [[1]][[3]][[1]]
#> [1] "작성"
#> 
#> [[1]][[3]][[2]]
#> [1] "NNG"
#> 
#> [[1]][[3]][[3]]
#> [1] 4
#> 
#> [[1]][[3]][[4]]
#> [1] 2
#> 
#> 
#> [[1]][[4]]
#> [[1]][[4]][[1]]
#> [1] "되"
#> 
#> [[1]][[4]][[2]]
#> [1] "XSV"
#> 
#> [[1]][[4]][[3]]
#> [1] 6
#> 
#> [[1]][[4]][[4]]
#> [1] 1
#> 
#> 
#> [[1]][[5]]
#> [[1]][[5]][[1]]
#> [1] "ᆫ"
#> 
#> [[1]][[5]][[2]]
#> [1] "ETM"
#> 
#> [[1]][[5]][[3]]
#> [1] 7
#> 
#> [[1]][[5]][[4]]
#> [1] 0
#> 
#> 
#> [[1]][[6]]
#> [[1]][[6]][[1]]
#> [1] "패키지"
#> 
#> [[1]][[6]][[2]]
#> [1] "NNG"
#> 
#> [[1]][[6]][[3]]
#> [1] 8
#> 
#> [[1]][[6]][[4]]
#> [1] 3
#> 
#> 
#> [[1]][[7]]
#> [[1]][[7]][[1]]
#> [1] "이"
#> 
#> [[1]][[7]][[2]]
#> [1] "VCP"
#> 
#> [[1]][[7]][[3]]
#> [1] 12
#> 
#> [[1]][[7]][[4]]
#> [1] 1
#> 
#> 
#> [[1]][[8]]
#> [[1]][[8]][[1]]
#> [1] "ᆸ니다"
#> 
#> [[1]][[8]][[2]]
#> [1] "EF"
#> 
#> [[1]][[8]][[3]]
#> [1] 13
#> 
#> [[1]][[8]][[4]]
#> [1] 2
#> 
#> 
#> [[1]][[9]]
#> [[1]][[9]][[1]]
#> [1] "."
#> 
#> [[1]][[9]][[2]]
#> [1] "SF"
#> 
#> [[1]][[9]][[3]]
#> [1] 15
#> 
#> [[1]][[9]][[4]]
#> [1] 1
#> 
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [[2]][[1]][[1]]
#> [1] "tidytext"
#> 
#> [[2]][[1]][[2]]
#> [1] "SL"
#> 
#> [[2]][[1]][[3]]
#> [1] 0
#> 
#> [[2]][[1]][[4]]
#> [1] 8
#> 
#> 
#> [[2]][[2]]
#> [[2]][[2]][[1]]
#> [1] "와"
#> 
#> [[2]][[2]][[2]]
#> [1] "JKB"
#> 
#> [[2]][[2]][[3]]
#> [1] 8
#> 
#> [[2]][[2]][[4]]
#> [1] 1
#> 
#> 
#> [[2]][[3]]
#> [[2]][[3]][[1]]
#> [1] "의"
#> 
#> [[2]][[3]][[2]]
#> [1] "JKG"
#> 
#> [[2]][[3]][[3]]
#> [1] 9
#> 
#> [[2]][[3]][[4]]
#> [1] 1
#> 
#> 
#> [[2]][[4]]
#> [[2]][[4]][[1]]
#> [1] "호환"
#> 
#> [[2]][[4]][[2]]
#> [1] "NNG"
#> 
#> [[2]][[4]][[3]]
#> [1] 11
#> 
#> [[2]][[4]][[4]]
#> [1] 2
#> 
#> 
#> [[2]][[5]]
#> [[2]][[5]][[1]]
#> [1] "을"
#> 
#> [[2]][[5]][[2]]
#> [1] "JKO"
#> 
#> [[2]][[5]][[3]]
#> [1] 13
#> 
#> [[2]][[5]][[4]]
#> [1] 1
#> 
#> 
#> [[2]][[6]]
#> [[2]][[6]][[1]]
#> [1] "염두"
#> 
#> [[2]][[6]][[2]]
#> [1] "NNG"
#> 
#> [[2]][[6]][[3]]
#> [1] 15
#> 
#> [[2]][[6]][[4]]
#> [1] 2
#> 
#> 
#> [[2]][[7]]
#> [[2]][[7]][[1]]
#> [1] "하"
#> 
#> [[2]][[7]][[2]]
#> [1] "XSV"
#> 
#> [[2]][[7]][[3]]
#> [1] 17
#> 
#> [[2]][[7]][[4]]
#> [1] 1
#> 
#> 
#> [[2]][[8]]
#> [[2]][[8]][[1]]
#> [1] "고"
#> 
#> [[2]][[8]][[2]]
#> [1] "EC"
#> 
#> [[2]][[8]][[3]]
#> [1] 18
#> 
#> [[2]][[8]][[4]]
#> [1] 1
#> 
#> 
#> [[2]][[9]]
#> [[2]][[9]][[1]]
#> [1] "작성"
#> 
#> [[2]][[9]][[2]]
#> [1] "NNG"
#> 
#> [[2]][[9]][[3]]
#> [1] 20
#> 
#> [[2]][[9]][[4]]
#> [1] 2
#> 
#> 
#> [[2]][[10]]
#> [[2]][[10]][[1]]
#> [1] "하"
#> 
#> [[2]][[10]][[2]]
#> [1] "XSV"
#> 
#> [[2]][[10]][[3]]
#> [1] 24
#> 
#> [[2]][[10]][[4]]
#> [1] 0
#> 
#> 
#> [[2]][[11]]
#> [[2]][[11]][[1]]
#> [1] "었"
#> 
#> [[2]][[11]][[2]]
#> [1] "EP"
#> 
#> [[2]][[11]][[3]]
#> [1] 23
#> 
#> [[2]][[11]][[4]]
#> [1] 1
#> 
#> 
#> [[2]][[12]]
#> [[2]][[12]][[1]]
#> [1] "습니다"
#> 
#> [[2]][[12]][[2]]
#> [1] "EF"
#> 
#> [[2]][[12]][[3]]
#> [1] 24
#> 
#> [[2]][[12]][[4]]
#> [1] 3
#> 
#> 
#> [[2]][[13]]
#> [[2]][[13]][[1]]
#> [1] "."
#> 
#> [[2]][[13]][[2]]
#> [1] "SF"
#> 
#> [[2]][[13]][[3]]
#> [1] 27
#> 
#> [[2]][[13]][[4]]
#> [1] 1
analyze_tbl(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
#> [[1]]
#> # A tibble: 9 x 4
#>   morph  tag   start   end
#>   <chr>  <chr> <int> <int>
#> 1 새롭   VA        0     2
#> 2 게     EC        2     1
#> 3 작성   NNG       4     2
#> 4 되     XSV       6     1
#> 5 ᆫ      ETM       7     0
#> 6 패키지 NNG       8     3
#> 7 이     VCP      12     1
#> 8 ᆸ니다  EF       13     2
#> 9 .      SF       15     1
#> 
#> [[2]]
#> # A tibble: 13 x 4
#>    morph    tag   start   end
#>    <chr>    <chr> <int> <int>
#>  1 tidytext SL        0     8
#>  2 와       JKB       8     1
#>  3 의       JKG       9     1
#>  4 호환     NNG      11     2
#>  5 을       JKO      13     1
#>  6 염두     NNG      15     2
#>  7 하       XSV      17     1
#>  8 고       EC       18     1
#>  9 작성     NNG      20     2
#> 10 하       XSV      24     0
#> 11 었       EP       23     1
#> 12 습니다   EF       24     3
#> 13 .        SF       27     1
analyze_tidy(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
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

The `analyze_tidy` function can also be used as `analyze_tt` and
`analyze_tidytext`. Below is an example of using it with the `tidytext`
package.

The `tar` below is the target text for morpheme analysis.

``` r
suppressMessages(library(dplyr))
library(stringr)
library(tidytext)
library(presidentSpeechKr)

spidx %>% 
  filter(president == "이명박") %>% 
  filter(str_detect(title, "취임사")) %>% 
  pull(link) %>% 
  get_speech(paragraph = T) %>%
  select(paragraph, content) -> tar
tar
#> # A tibble: 62 x 2
#>    paragraph content                                                            
#>        <int> <chr>                                                              
#>  1         1 존경하는 국민 여러분!                                              
#>  2         2 700만 해외동포 여러분!                                             
#>  3         3 이 자리에 참석하신 노무현ㆍ김대중ㆍ김영삼ㆍ전두환 전 대통령, 그리고 이슬람 카리모프 우즈베키스탄 대통령, 엥흐바야르 남…
#>  4         4 저는 오늘 국민 여러분의 부름을 받고 대한민국의 제17대 대통령에 취임합니다. 한없이 자랑스러운 나라, 한없이 위대한 …
#>  5         5 저는 이 자리에서 국민 여러분께 약속드립니다. 국민을 섬겨 나라를 편안하게 하겠습니다. 경제를 발전시키고 사회를 통합하…
#>  6         6 올해로 대한민국 건국 60주년을 맞이합니다. 우리는 잃었던 땅을 되찾아 나라를 세웠고, 그 나라를 지키려고 목숨을 걸었…
#>  7         7 지구 상에서 가장 가난했던 나라가 세계 10위권의 경제 대국이 되었습니다. 도움을 받는 나라에서 베푸는 나라로 올라섰습…
#>  8         8 그러나 우리는 알고 있습니다. 그것은 기적이 아니라 우리가 다 함께 흘린 피와 땀과 눈물의 결정입니다. 그것은 신화가 …
#>  9         9 독립을 위해 목숨을 바친 선열들, 전선에서 산화한 장병들, 뙤약볕과 비바람 속에 땅을 일군 농민들, 밤낮없이 산업현장을…
#> 10        10 장롱 속 금붙이를 들고나와 외환위기에 맞섰던 시민들, 겨울 바닷가에서 기름을 걷고 닦는 자원봉사자들, 그리고 사회 각 …
#> # … with 52 more rows
```

This is an example of using `analyze_tidy` of `Elbird` as a tokenizer
with `tar` as `unnest_tokens` which is a function of `tidytext` package.

``` r
tar %>% 
  unnest_tokens(
    input = content,
    output = word,
    token = analyze_tidy
    )
#> # A tibble: 4,538 x 2
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
#> # … with 4,528 more rows
```

### add user word

`Elbird` connects and provides the add user word function of `kiwi`.

The `add_user_word` function receives words, morpheme tags, and weights
as inputs and adds a user dictionary to be used for analysis.

The example below is an example of adding a user dictionary and
modifying the result of `박찬` being divided and analyzed.

``` r
library(Elbird)
analyze_tbl("안녕하세요. 저는 박찬엽 입니다.")
#> [[1]]
#> # A tibble: 9 x 4
#>   morph      tag   start   end
#>   <chr>      <chr> <int> <int>
#> 1 안녕하세요 NNP       0     5
#> 2 .          SF        5     1
#> 3 저         NP        7     1
#> 4 는         JX        8     1
#> 5 박찬       NNP      10     2
#> 6 엽         NNG      12     1
#> 7 이         VCP      14     1
#> 8 ᆸ니다      EF       15     2
#> 9 .          SF       17     1
add_user_word("박찬엽","NNP",1)
analyze_tbl("안녕하세요. 저는 박찬엽 입니다.")
#> [[1]]
#> # A tibble: 8 x 4
#>   morph      tag   start   end
#>   <chr>      <chr> <int> <int>
#> 1 안녕하세요 NNP       0     5
#> 2 .          SF        5     1
#> 3 저         NP        7     1
#> 4 는         JX        8     1
#> 5 박찬엽     NNP      10     3
#> 6 이         VCP      14     1
#> 7 ᆸ니다      EF       15     2
#> 8 .          SF       17     1
```

## tag set

[Tag
list](https://github.com/bab2min/kiwipiepy#%ED%92%88%EC%82%AC-%ED%83%9C%EA%B7%B8)
that used in [kiwipiepy](https://github.com/bab2min/kiwipiepy) package.

  - The table below is fetched at 2020-11-03 08:26:43 UTC.

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
[suggestion](https://github.com/mrchypark/Elbird/issues/6).
