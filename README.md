
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Elbird

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/Elbird)](https://CRAN.R-project.org/package=Elbird)
[![](https://cranlogs.r-pkg.org/badges/Elbird)](https://cran.r-project.org/package=Elbird)
<!-- badges: end -->

The goal of Elbird is to provide R Wrapper functions in
[kiwipiepy](https://github.com/bab2min/kiwipiepy) package.

## Installation

### Pre required

You need to install conda before installing Elbird.

``` r
install.packages("reticulate")
reticulate::install_miniconda()
```

or

``` r
install.packages("remotes")
remotes::install_github("mrchypark/multilinguer")
multilinguer::install_conda()
```

### CRAN \[*NOT YET*\]

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

This is a basic example which shows you how to solve a common problem:

``` r
library(Elbird)
analyze_tbl("안녕하세요 kiwi 형태소 분석기의 R wrapper인 Elbird를 소개합니다.")
#> [[1]]
#> [90m# A tibble: 16 x 4[39m
#>    morph      tag   start   end
#>    [3m[90m<chr>[39m[23m      [3m[90m<chr>[39m[23m [3m[90m<int>[39m[23m [3m[90m<int>[39m[23m
#> [90m 1[39m 안녕하세요 NNP       0     5
#> [90m 2[39m kiwi       SL        6     4
#> [90m 3[39m 형태소     NNG      11     3
#> [90m 4[39m 분석       NNG      15     2
#> [90m 5[39m 기         NNB      17     1
#> [90m 6[39m 의         JKG      18     1
#> [90m 7[39m R          SL       20     1
#> [90m 8[39m wrapper    SL       22     7
#> [90m 9[39m 이         VCP      29     1
#> [90m10[39m ᆫ          ETM      30     0
#> [90m11[39m Elbird     SL       31     6
#> [90m12[39m 를         JKO      37     1
#> [90m13[39m 소개       NNG      39     2
#> [90m14[39m 하         XSV      41     1
#> [90m15[39m ᆸ니다      EF       42     2
#> [90m16[39m .          SF       44     1
analyze_tbl(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
#> [[1]]
#> [90m# A tibble: 9 x 4[39m
#>   morph  tag   start   end
#>   [3m[90m<chr>[39m[23m  [3m[90m<chr>[39m[23m [3m[90m<int>[39m[23m [3m[90m<int>[39m[23m
#> [90m1[39m 새롭   VA        0     2
#> [90m2[39m 게     EC        2     1
#> [90m3[39m 작성   NNG       4     2
#> [90m4[39m 되     XSV       6     1
#> [90m5[39m ᆫ      ETM       7     0
#> [90m6[39m 패키지 NNG       8     3
#> [90m7[39m 이     VCP      12     1
#> [90m8[39m ᆸ니다  EF       13     2
#> [90m9[39m .      SF       15     1
#> 
#> [[2]]
#> [90m# A tibble: 13 x 4[39m
#>    morph    tag   start   end
#>    [3m[90m<chr>[39m[23m    [3m[90m<chr>[39m[23m [3m[90m<int>[39m[23m [3m[90m<int>[39m[23m
#> [90m 1[39m tidytext SL        0     8
#> [90m 2[39m 와       JKB       8     1
#> [90m 3[39m 의       JKG       9     1
#> [90m 4[39m 호환     NNG      11     2
#> [90m 5[39m 을       JKO      13     1
#> [90m 6[39m 염두     NNG      15     2
#> [90m 7[39m 하       XSV      17     1
#> [90m 8[39m 고       EC       18     1
#> [90m 9[39m 작성     NNG      20     2
#> [90m10[39m 하       XSV      24     0
#> [90m11[39m 었       EP       23     1
#> [90m12[39m 습니다   EF       24     3
#> [90m13[39m .        SF       27     1
analyze_tidytext("안녕하세요 kiwi 형태소 분석기의 R wrapper인 Elbird를 소개합니다.")
#> [[1]]
#>  [1] "안녕하세요/NNP" "kiwi/SL"        "형태소/NNG"     "분석/NNG"      
#>  [5] "기/NNB"         "의/JKG"         "R/SL"           "wrapper/SL"    
#>  [9] "이/VCP"         "ᆫ/ETM"           "Elbird/SL"      "를/JKO"        
#> [13] "소개/NNG"       "하/XSV"         "ᆸ니다/EF"        "./SF"
analyze_tt(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
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
#> [90m# A tibble: 62 x 2[39m
#>    paragraph content                                                            
#>        [3m[90m<int>[39m[23m [3m[90m<chr>[39m[23m                                                              
#> [90m 1[39m         1 존경하는 국민 여러분!                                              
#> [90m 2[39m         2 700만 해외동포 여러분!                                             
#> [90m 3[39m         3 이 자리에 참석하신 노무현ㆍ김대중ㆍ김영삼ㆍ전두환 전 대통령, 그리고 이슬람 카리모프 우즈베키스탄 대통령, 엥흐바야르 남…
#> [90m 4[39m         4 저는 오늘 국민 여러분의 부름을 받고 대한민국의 제17대 대통령에 취임합니다. 한없이 자랑스러운 나라, 한없이 위대한 …
#> [90m 5[39m         5 저는 이 자리에서 국민 여러분께 약속드립니다. 국민을 섬겨 나라를 편안하게 하겠습니다. 경제를 발전시키고 사회를 통합하…
#> [90m 6[39m         6 올해로 대한민국 건국 60주년을 맞이합니다. 우리는 잃었던 땅을 되찾아 나라를 세웠고, 그 나라를 지키려고 목숨을 걸었…
#> [90m 7[39m         7 지구 상에서 가장 가난했던 나라가 세계 10위권의 경제 대국이 되었습니다. 도움을 받는 나라에서 베푸는 나라로 올라섰습…
#> [90m 8[39m         8 그러나 우리는 알고 있습니다. 그것은 기적이 아니라 우리가 다 함께 흘린 피와 땀과 눈물의 결정입니다. 그것은 신화가 …
#> [90m 9[39m         9 독립을 위해 목숨을 바친 선열들, 전선에서 산화한 장병들, 뙤약볕과 비바람 속에 땅을 일군 농민들, 밤낮없이 산업현장을…
#> [90m10[39m        10 장롱 속 금붙이를 들고나와 외환위기에 맞섰던 시민들, 겨울 바닷가에서 기름을 걷고 닦는 자원봉사자들, 그리고 사회 각 …
#> [90m# … with 52 more rows[39m
tar %>% 
  unnest_tokens(
    input = content,
    output = word,
    token = analyze_tt
    )
#> [90m# A tibble: 4,538 x 2[39m
#>    paragraph word     
#>        [3m[90m<int>[39m[23m [3m[90m<chr>[39m[23m    
#> [90m 1[39m         1 존경/nng 
#> [90m 2[39m         1 하/xsv   
#> [90m 3[39m         1 는/etm   
#> [90m 4[39m         1 국민/nng 
#> [90m 5[39m         1 여러분/np
#> [90m 6[39m         1 !/sf     
#> [90m 7[39m         2 700/sn   
#> [90m 8[39m         2 만/nr    
#> [90m 9[39m         2 해외/nng 
#> [90m10[39m         2 동포/nng 
#> [90m# … with 4,528 more rows[39m
```

## tag set

Tag list that used in [kiwipiepy](https://github.com/bab2min/kiwipiepy)
package.

[tag
table](https://github.com/bab2min/kiwipiepy#%ED%92%88%EC%82%AC-%ED%83%9C%EA%B7%B8)
