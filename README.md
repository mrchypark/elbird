
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
#> 10 ㄴ          ETM      30     0
#> 11 Elbird     SL       31     6
#> 12 를         JKO      37     1
#> 13 소개       NNG      39     2
#> 14 하         XSV      41     1
#> 15 ㅂ니다      EF       42     2
#> 16 .          SF       44     1
analyze_tbl(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
#> [[1]]
#> # A tibble: 9 x 4
#>   morph  tag   start   end
#>   <chr>  <chr> <int> <int>
#> 1 새롭   VA        0     2
#> 2 게     EC        2     1
#> 3 작성   NNG       4     2
#> 4 되     XSV       6     1
#> 5 ㄴ      ETM       7     0
#> 6 패키지 NNG       8     3
#> 7 이     VCP      12     1
#> 8 ㅂ니다  EF       13     2
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
analyze_tidytext("안녕하세요 kiwi 형태소 분석기의 R wrapper인 Elbird를 소개합니다.")
#> [[1]]
#>  [1] "안녕하세요/NNP" "kiwi/SL"        "형태소/NNG"     "분석/NNG"      
#>  [5] "기/NNB"         "의/JKG"         "R/SL"           "wrapper/SL"    
#>  [9] "이/VCP"         "ㄴ/ETM"         "Elbird/SL"      "를/JKO"        
#> [13] "소개/NNG"       "하/XSV"         "ㅂ니다/EF"      "./SF"
analyze_tt(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
#> [[1]]
#> [1] "새롭/VA"    "게/EC"      "작성/NNG"   "되/XSV"     "ㄴ/ETM"    
#> [6] "패키지/NNG" "이/VCP"     "ㅂ니다/EF"  "./SF"      
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
#> # A tibble: 62 x 2
#>    paragraph content                                                            
#>        <int> <chr>                                                              
#>  1         1 존경하는 국민 여러분!                                              
#>  2         2 700만 해외동포 여러분!                                             
#>  3         3 이 자리에 참석하신 노무현ㆍ김대중ㆍ김영삼ㆍ전두환 전 대통령, 그리고 이슬람 카리모프 우즈베키스탄 대통령, 엥흐바야르 남~
#>  4         4 저는 오늘 국민 여러분의 부름을 받고 대한민국의 제17대 대통령에 취임합니다. 한없이 자랑스러운 나라, 한없이 위대한 ~
#>  5         5 저는 이 자리에서 국민 여러분께 약속드립니다. 국민을 섬겨 나라를 편안하게 하겠습니다. 경제를 발전시키고 사회를 통합하~
#>  6         6 올해로 대한민국 건국 60주년을 맞이합니다. 우리는 잃었던 땅을 되찾아 나라를 세웠고, 그 나라를 지키려고 목숨을 걸었~
#>  7         7 지구 상에서 가장 가난했던 나라가 세계 10위권의 경제 대국이 되었습니다. 도움을 받는 나라에서 베푸는 나라로 올라섰습~
#>  8         8 그러나 우리는 알고 있습니다. 그것은 기적이 아니라 우리가 다 함께 흘린 피와 땀과 눈물의 결정입니다. 그것은 신화가 ~
#>  9         9 독립을 위해 목숨을 바친 선열들, 전선에서 산화한 장병들, 뙤약볕과 비바람 속에 땅을 일군 농민들, 밤낮없이 산업현장을~
#> 10        10 장롱 속 금붙이를 들고나와 외환위기에 맞섰던 시민들, 겨울 바닷가에서 기름을 걷고 닦는 자원봉사자들, 그리고 사회 각 ~
#> # ... with 52 more rows
tar %>% 
  unnest_tokens(
    input = content,
    output = word,
    token = analyze_tt
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
#> # ... with 4,528 more rows
```

## tag

Tag list that used in [kiwipiepy](https://github.com/bab2min/kiwipiepy)
package.

<table>
<tr>
<th>
대분류
</th>
<th>
태그
</th>
<th>
설명
</th>
</tr>
<tr>
<th rowspan="5">
체언(N)
</th>
<td>
NNG
</td>
<td>
일반 명사
</td>
</tr>
<tr>
<td>
NNP
</td>
<td>
고유 명사
</td>
</tr>
<tr>
<td>
NNB
</td>
<td>
의존 명사
</td>
</tr>
<tr>
<td>
NR
</td>
<td>
수사
</td>
</tr>
<tr>
<td>
NP
</td>
<td>
대명사
</td>
</tr>
<tr>
<th rowspan="5">
용언(V)
</th>
<td>
VV
</td>
<td>
동사
</td>
</tr>
<tr>
<td>
VA
</td>
<td>
형용사
</td>
</tr>
<tr>
<td>
VX
</td>
<td>
보조 용언
</td>
</tr>
<tr>
<td>
VCP
</td>
<td>
긍정 지시사(이다)
</td>
</tr>
<tr>
<td>
VCN
</td>
<td>
부정 지시사(아니다)
</td>
</tr>
<tr>
<th rowspan="1">
관형사
</th>
<td>
MM
</td>
<td>
관형사
</td>
</tr>
<tr>
<th rowspan="2">
부사(MA)
</th>
<td>
MAG
</td>
<td>
일반 부사
</td>
</tr>
<tr>
<td>
MAJ
</td>
<td>
접속 부사
</td>
</tr>
<tr>
<th rowspan="1">
감탄사
</th>
<td>
IC
</td>
<td>
감탄사
</td>
</tr>
<tr>
<th rowspan="9">
조사(J)
</th>
<td>
JKS
</td>
<td>
주격 조사
</td>
</tr>
<tr>
<td>
JKC
</td>
<td>
보격 조사
</td>
</tr>
<tr>
<td>
JKG
</td>
<td>
관형격 조사
</td>
</tr>
<tr>
<td>
JKO
</td>
<td>
목적격 조사
</td>
</tr>
<tr>
<td>
JKB
</td>
<td>
부사격 조사
</td>
</tr>
<tr>
<td>
JKV
</td>
<td>
호격 조사
</td>
</tr>
<tr>
<td>
JKQ
</td>
<td>
인용격 조사
</td>
</tr>
<tr>
<td>
JX
</td>
<td>
보조사
</td>
</tr>
<tr>
<td>
JC
</td>
<td>
접속 조사
</td>
</tr>
<tr>
<th rowspan="5">
어미(E)
</th>
<td>
EP
</td>
<td>
선어말 어미
</td>
</tr>
<tr>
<td>
EF
</td>
<td>
종결 어미
</td>
</tr>
<tr>
<td>
EC
</td>
<td>
연결 어미
</td>
</tr>
<tr>
<td>
ETN
</td>
<td>
명사형 전성 어미
</td>
</tr>
<tr>
<td>
ETM
</td>
<td>
관형형 전성 어미
</td>
</tr>
<tr>
<th rowspan="1">
접두사
</th>
<td>
XPN
</td>
<td>
체언 접두사
</td>
</tr>
<tr>
<th rowspan="3">
접미사(XS)
</th>
<td>
XSN
</td>
<td>
명사 파생 접미사
</td>
</tr>
<tr>
<td>
XSV
</td>
<td>
동사 파생 접미사
</td>
</tr>
<tr>
<td>
XSA
</td>
<td>
형용사 파생 접미사
</td>
</tr>
<tr>
<th rowspan="1">
어근
</th>
<td>
XR
</td>
<td>
어근
</td>
</tr>
<tr>
<th rowspan="9">
부호, 외국어, 특수문자(S)
</th>
<td>
SF
</td>
<td>
종결 부호(. ! ?)
</td>
</tr>
<tr>
<td>
SP
</td>
<td>
구분 부호(, / : ;)
</td>
</tr>
<tr>
<td>
SS
</td>
<td>
인용 부호 및 괄호(’ " ( ) \[ \] &lt; &gt; { } ― ‘ ’ “ ” ≪ ≫ 등)
</td>
</tr>
<tr>
<td>
SE
</td>
<td>
줄임표(…)
</td>
</tr>
<tr>
<td>
SO
</td>
<td>
붙임표(- \~)
</td>
</tr>
<tr>
<td>
SW
</td>
<td>
기타 특수 문자
</td>
</tr>
<tr>
<td>
SL
</td>
<td>
알파벳(A-Z a-z)
</td>
</tr>
<tr>
<td>
SH
</td>
<td>
한자
</td>
</tr>
<tr>
<td>
SN
</td>
<td>
숫자(0-9)
</td>
</tr>
<tr>
<th rowspan="1">
분석 불능
</th>
<td>
UN
</td>
<td>
분석 불능<sup>\*</sup>
</td>
</tr>
<tr>
<th rowspan="4">
웹(W)
</th>
<td>
W\_URL
</td>
<td>
URL 주소<sup>\*</sup>
</td>
</tr>
<tr>
<td>
W\_EMAIL
</td>
<td>
이메일 주소<sup>\*</sup>
</td>
</tr>
<tr>
<td>
W\_HASHTAG
</td>
<td>
해시태그(\#abcd)<sup>\*</sup>
</td>
</tr>
<tr>
<td>
W\_MENTION
</td>
<td>
멘션(@abcd)<sup>\*</sup>
</td>
</tr>
</table>

<sup>\*</sup> 세종 품사 태그와 다른 독자적인 태그입니다.
