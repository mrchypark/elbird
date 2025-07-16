# Implementation Plan

- [x] 1. 빌드 시스템 업그레이드 및 C++17 지원 구현
  - configure 스크립트를 수정하여 Kiwi v0.21.0 다운로드 및 C++17 컴파일러 요구사항 추가
  - DESCRIPTION 파일의 SystemRequirements 섹션을 업데이트하여 C++17 지원 명시
  - 플랫폼별 Makevars 파일들을 C++17 표준으로 업데이트
  - _Requirements: 2.1, 2.2, 2.3_

- [x] 2. 핵심 C++ API 바인딩 업데이트
- [x] 2.1 기존 kiwi_analyze 함수 바인딩을 새로운 시그니처로 업데이트
  - kiwi_bind.cpp에서 kiwi_analyze_ 함수를 새로운 API (blocklist, pretokenized 매개변수 포함)로 수정
  - 하위 호환성을 위해 기본값으로 NULL 처리 로직 구현
  - 기존 R 함수들이 동일하게 작동하도록 래퍼 함수 유지
  - _Requirements: 1.2, 3.1, 3.2_

- [x] 2.2 kiwi_builder_build 함수 바인딩 업데이트
  - 새로운 typo correction 매개변수 (typos, typo_cost_threshold) 지원 추가
  - 기본값으로 오타 교정 비활성화 설정 구현
  - 오류 처리 로직 강화
  - _Requirements: 1.1, 4.1_

- [x] 2.3 새로운 API 함수들에 대한 C++ 바인딩 구현
  - kiwi_new_morphset, kiwi_morphset_* 함수들 바인딩 추가
  - kiwi_pt_init, kiwi_pt_* 함수들 바인딩 추가  
  - kiwi_typo_* 함수들 바인딩 추가
  - 적절한 메모리 관리 및 finalizer 함수들 구현
  - _Requirements: 4.2, 4.3_

- [x] 3. R API 호환성 유지 및 새로운 기능 추가
- [x] 3.1 기존 analyze() 함수 호환성 보장
  - R/analyze.R에서 새로운 C++ 바인딩을 사용하도록 내부 로직 수정
  - 기존 매개변수와 반환값 형식 완전 유지
  - 새로운 선택적 매개변수 (blocklist, pretokenized) 추가
  - _Requirements: 3.1, 3.2_

- [x] 3.2 기존 tokenize() 함수 호환성 보장
  - R/tokenize.R에서 새로운 분석 결과를 기존 형식으로 변환하는 로직 구현
  - 모든 tokenize 변형 함수들 (tokenize_tbl, tokenize_tidytext 등) 호환성 확인
  - _Requirements: 3.1, 3.2_

- [x] 3.3 Kiwi R6 클래스 업데이트
  - R/kiwi.R에서 initialize 메서드를 새로운 빌드 API로 업데이트
  - analyze, tokenize 메서드들을 새로운 C++ 바인딩 사용하도록 수정
  - 기존 메서드 시그니처와 동작 완전 유지
  - _Requirements: 3.3_

- [x] 4. 새로운 기능을 위한 R 클래스 및 메서드 구현
- [x] 4.1 Morphset R6 클래스 구현
  - 형태소 집합 생성, 추가, 관리를 위한 R6 클래스 작성
  - C++ 바인딩과 연동하는 메서드들 구현
  - 적절한 메모리 관리 및 finalizer 구현
  - _Requirements: 4.2_

- [x] 4.2 Pretokenized R6 클래스 구현
  - 사전 토큰화 객체 관리를 위한 R6 클래스 작성
  - 구간 추가, 토큰 추가 메서드들 구현
  - C++ 바인딩과의 연동 로직 구현
  - _Requirements: 4.2_

- [x] 4.3 오타 교정 기능을 Kiwi 클래스에 통합
  - set_typo_correction() 메서드를 Kiwi 클래스에 추가
  - 오타 교정 설정 관리 로직 구현
  - 오타 교정 결과를 기존 분석 결과 형식에 통합
  - _Requirements: 4.1, 4.2_

- [x] 5. 테스트 스위트 업데이트 및 확장
- [x] 5.1 기존 테스트 호환성 검증
  - tests/testthat/ 디렉토리의 모든 기존 테스트 실행 및 통과 확인
  - 실패하는 테스트가 있다면 수정하여 100% 통과율 달성
  - 테스트 실행 시간 성능 확인
  - _Requirements: 3.1, 3.2, 3.3_

- [x] 5.2 새로운 기능에 대한 테스트 작성
  - Morphset 클래스 기능 테스트 작성
  - Pretokenized 클래스 기능 테스트 작성
  - 오타 교정 기능 테스트 작성
  - 새로운 API 매개변수들에 대한 테스트 작성
  - _Requirements: 4.1, 4.2, 4.3_

- [x] 5.3 성능 및 안정성 테스트 추가
  - 대용량 텍스트 처리 성능 테스트 작성
  - 메모리 누수 검사 테스트 구현
  - 멀티스레딩 안정성 테스트 추가
  - _Requirements: 1.1, 5.1, 5.2, 5.3_

- [x] 6. 문서화 및 예제 업데이트
- [x] 6.1 함수 문서화 업데이트
  - 모든 새로운 매개변수에 대한 roxygen2 문서 추가
  - 새로운 클래스들에 대한 상세한 문서 작성
  - 사용 예제 코드 업데이트
  - _Requirements: 4.3_

- [x] 6.2 README 및 vignette 업데이트
  - README.Rmd에 새로운 기능 소개 섹션 추가
  - 기존 vignette들을 새로운 기능 반영하여 업데이트
  - 마이그레이션 가이드 작성
  - _Requirements: 1.1, 4.1, 4.2, 4.3_

- [x] 6.3 CHANGELOG 및 NEWS 파일 업데이트
  - 주요 변경사항을 NEWS.md에 기록
  - 버전 정보 및 호환성 정보 명시
  - 알려진 이슈 및 해결 방법 문서화
  - _Requirements: 1.1, 1.2, 1.3_

- [x] 7. 패키지 메타데이터 및 설정 파일 업데이트
- [x] 7.1 DESCRIPTION 파일 업데이트
  - 버전 번호를 0.3.0으로 업데이트 (주요 업그레이드 반영)
  - SystemRequirements에 C++17 요구사항 명시
  - 새로운 의존성이 있다면 Imports 섹션 업데이트
  - _Requirements: 2.1, 2.2_

- [x] 7.2 NAMESPACE 파일 재생성 및 검증
  - roxygen2를 사용하여 NAMESPACE 파일 재생성
  - 모든 새로운 export 함수들이 올바르게 포함되었는지 확인
  - import 구문들이 올바른지 검증
  - _Requirements: 4.1, 4.2, 4.3_

- [x] 8. 최종 통합 테스트 및 검증
- [x] 8.1 전체 패키지 빌드 및 설치 테스트
  - 다양한 플랫폼에서 패키지 빌드 성공 확인
  - R CMD check 통과 확인 (WARNING 및 ERROR 0개)
  - 설치 후 모든 기능 정상 작동 확인
  - _Requirements: 5.1, 5.2, 5.3_

- [x] 8.2 실제 사용 시나리오 테스트
  - 기존 사용자 코드가 수정 없이 작동하는지 확인
  - 새로운 기능들을 활용한 실제 사용 사례 테스트
  - 성능 개선 효과 측정 및 문서화
  - _Requirements: 1.1, 3.1, 3.2, 3.3, 4.1_