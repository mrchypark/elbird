
<!-- README_kr.md is generated from README_kr.Rmd. Please edit that file -->

# elbird <img src="man/figures/logo.png" align="right" height=140/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/elbird)](https://CRAN.R-project.org/package=elbird)
[![](https://cranlogs.r-pkg.org/badges/elbird)](https://cran.r-project.org/package=elbird)
<!-- badges: end -->

`elbird` 패키지는 [kiwipiepy](https://github.com/bab2min/kiwipiepy) 를
wrapping한 형태소 분석기 패키지입니다. `cpp` 기반의 `kiwi`를 베이스로 하고 있으며 다른 분석기에 비해 빠른
성능과 쉬운 사용자 사전 추가, 미등록 명사 추출(아직 elbird에는 미구현) 등 편의 기능이 있습니다.

## 설치

### CRAN *\!아직 적용 전입니다\!*

안정화 버전의 `elbird`는 아래 명령어로 설치할 수 있습니다.(아직 안됬습니다\!)

``` r
# CRAN *!NOT YET!*
install.packages("elbird")

# Dev version
install.packages("elbird", repos = 'https://mrchypark.r-universe.dev')
```

## 사용예

아래 예시들은 elbird의 함수의 동작을 소개합니다.

### analyze 함수

기본적으로 [kiwipiepy](https://github.com/bab2min/kiwipiepy) 패키지의 `analyze`
함수의 출력을 그대로 사용하는 `analyze` 함수와 tibble 자료형으로 정리한 `analyze_tbl`,
tidytext와의 문법호환을 지원하는 `analyze_tidy` 함수를 제공합니다.

``` r
library(elbird)
## analyze("안녕하세요 kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다.")
analyze_tbl("안녕하세요 kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다.")
#> [[1]]
#> # A tibble: 19 × 4
#>    morph   tag   start   end
#>    <chr>   <chr> <int> <int>
#>  1 안녕    NNG       0     2
#>  2 하      XSA       2     1
#>  3 시      EP        4     1
#>  4 어요    EC        3     2
#>  5 kiwi    SL        6     4
#>  6 형태소  NNG      11     3
#>  7 분석    NNG      15     2
#>  8 기      NNB      17     1
#>  9 의      JKG      18     1
#> 10 R       SL       20     1
#> 11 wrapper SL       22     7
#> 12 이      VCP      29     1
#> 13 ᆫ       ETM      30     0
#> 14 elbird  SL       31     6
#> 15 를      JKO      37     1
#> 16 소개    NNG      39     2
#> 17 하      XSV      41     1
#> 18 ᆸ니다   EF       42     2
#> 19 .       SF       44     1
analyze_tidy("안녕하세요 kiwi 형태소 분석기의 R wrapper인 elbird를 소개합니다.")
#> [[1]]
#>  [1] "안녕/NNG"   "하/XSA"     "시/EP"      "어요/EC"    "kiwi/SL"   
#>  [6] "형태소/NNG" "분석/NNG"   "기/NNB"     "의/JKG"     "R/SL"      
#> [11] "wrapper/SL" "이/VCP"     "ᆫ/ETM"       "elbird/SL"  "를/JKO"    
#> [16] "소개/NNG"   "하/XSV"     "ᆸ니다/EF"    "./SF"
```

여러 문장의 경우 `vector`나 `list`로 입력받아서 `list`로 출력합니다.

``` r
## analyze(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
analyze_tbl(c("새롭게 작성된 패키지 입니다.", "tidytext와의 호환을 염두하고 작성하였습니다."))
#> [[1]]
#> # A tibble: 9 × 4
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
#> # A tibble: 13 × 4
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

`analyze_tidy` 함수는 `analyze_tt`, `analyze_tidytext` 로도 사용할 수 있습니다. 아래는
`tidytext` 패키지와 함께 사용하는 예시 입니다.

아래 `tar`는 형태소 분석을 위한 타겟 텍스트입니다.

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

`tar`를 `tidytext` 패키지의 함수인 `unnest_tokens`로 `elbird`의 `analyze_tidy`를
tokenizer로 사용하는 예시입니다.

``` r
tar %>% 
  unnest_tokens(
    input = content,
    output = word,
    token = analyze_tidy
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

### 사용자 사전 추가

`elbird`는 `kiwi`의 사용자 사전 추가 기능을 연결하여 제공합니다.

`add_user_word` 함수는 단어, 형태소 태그, 가중치를 입력으로 받아 사용자 사전을 추가하여 분석에 사용하도록
동작합니다.

아래 예시는 `박찬엽`이 나뉘어 분석되고 있던 결과를 사용자 사전을 추가하여 수정한 예시 입니다.

``` r
library(elbird)
analyze_tbl("안녕하세요. 저는 박찬엽 입니다.")
#> [[1]]
#> # A tibble: 14 × 4
#>    morph tag   start   end
#>    <chr> <chr> <int> <int>
#>  1 안녕  NNG       0     2
#>  2 하    XSA       2     1
#>  3 시    EP        4     1
#>  4 어요  EF        3     2
#>  5 .     SF        5     1
#>  6 저    NP        7     1
#>  7 는    JX        8     1
#>  8 박찬  NNP      10     2
#>  9 이    VCP      12     1
#> 10 어    EC       12     1
#> 11 ᆸ     NNG      13     0
#> 12 이    VCP      14     1
#> 13 ᆸ니다 EF       15     2
#> 14 .     SF       17     1
add_user_word("박찬엽","NNP",1)
analyze_tbl("안녕하세요. 저는 박찬엽 입니다.")
#> [[1]]
#> # A tibble: 14 × 4
#>    morph tag   start   end
#>    <chr> <chr> <int> <int>
#>  1 안녕  NNG       0     2
#>  2 하    XSA       2     1
#>  3 시    EP        4     1
#>  4 어요  EF        3     2
#>  5 .     SF        5     1
#>  6 저    NP        7     1
#>  7 는    JX        8     1
#>  8 박찬  NNP      10     2
#>  9 이    VCP      12     1
#> 10 어    EC       12     1
#> 11 ᆸ     NNG      13     0
#> 12 이    VCP      14     1
#> 13 ᆸ니다 EF       15     2
#> 14 .     SF       17     1
```

### 사용자 사전 가중치

`kiwi` 패키지 제작자의 설명을 보면 가중치는 어떤 실수(`double`)라도 가능합니다. 사용하시면서 감각을 찾으면 좋을 것
같습니다. \#\# 형태소 태그

[kiwipiepy](https://github.com/bab2min/kiwipiepy)패키지에서 사용하는 [형태소
태그](https://github.com/bab2min/kiwipiepy#%ED%92%88%EC%82%AC-%ED%83%9C%EA%B7%B8)는
아래와 같습니다.

  - The table below is fetched at 2022-03-08 17:44:17 UTC.

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

## 특별히 감사

### kiwi 패키지

kiwi 패키지 제작자 이신 [bab2min](https://github.com/bab2min)님께 감사드립니다.

### logo

로고 제작에 [의견](https://github.com/mrchypark/elbird/issues/6)을 주신
[jhk0530](https://github.com/jhk0530)님께 감사드립니다.
