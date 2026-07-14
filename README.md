# 소통마케팅 (Sotong Marketing)

소통웨어(SotongWare)의 **맞춤형 홍보·마케팅 사이트 제작** 안내·상담 웹앱입니다.  
Flutter로 만든 정적 사이트이며, 상담 내용은 서버에 저장하지 않고 브라우저·메일로만 이어집니다.

- **서비스명:** 소통마케팅
- **공개 URL:** https://sotongware-marketing.web.app/
- **문의:** sotongware@naver.com
- **Firebase 프로젝트 ID:** `sotongware-marketing`

---

## 개요

사업·상품·서비스·농산물·관광·기술·브랜드의 가치를 고객이 이해하고, 상담·문의로 이어지도록  
홍보 사이트 구성을 안내하고 제작 상담을 돕는 공개 사이트입니다.

## 대상

- 온라인 소개·홍보 링크가 필요한 소상공인·중소기업
- 상품·서비스·농산물·관광·숙박·기술·전문가 브랜드를 소개하려는 고객
- 맞춤형 홍보 사이트 제작 범위를 먼저 살펴보고 싶은 분

## 목적

1. 필요한 홍보 수준과 제작 등급을 스스로 가늠할 수 있게 한다.
2. 준비 자료·제작 과정·활용 방법을 한곳에서 안내한다.
3. 상담 전 질문을 정리해 메일로 보낼 수 있게 한다. (서버 미저장)

## 메뉴 구조

| 그룹 | 경로 | 설명 |
|------|------|------|
| A. 살펴보기 | `/`, `/needs`, `/prepare` | 홈, 필요 파악, 고객 준비자료 |
| B. 제작 안내 | `/services`, `/packages`, `/process`, `/custom`, `/industries` | 서비스·등급·과정·맞춤·업종 |
| C. 결과와 활용 | `/examples`, `/utilization`, `/maintenance`, `/faq` | 예시·활용·관리·FAQ |
| D. 상담 | `/consultation`, `/request-process`, `/about`, `/contact` | 상담 준비·의뢰·소개·문의 |

## 제작 등급(패키지)

JSON(`assets/data/service_packages.json`) 기준:

- **스타트** — 빠른 소개·연락 링크
- **비즈니스** — 전문 소개·문의 유도
- **프리미엄** — 브랜드·콘텐츠 확장
- **맞춤** — 범위 협의 후 구성

※ 화면의 추천·안내는 견적 확정이 아닙니다. 범위와 비용은 상담 후 결정됩니다.

## 상담 도우미

`/consultation`에서 10단계 질문을 채우면 요약 문장을 만들고,  
mailto로 `sotongware@naver.com`에 보낼 수 있습니다.

- 작성 내용은 **브라우저 로컬**에서만 다루며 **서버에 자동 저장하지 않습니다.**
- 길이가 길면 mailto 본문이 잘릴 수 있어, 화면에서 복사·붙여넣기를 안내합니다.

## 개인정보·저장

- 상담 초안·선택값은 서버 DB에 올리지 않습니다.
- 메일을 보낼 때만 사용자 기기·메일 클라이언트로 전달됩니다.

## 로컬 실행

```bash
flutter pub get
flutter run -d chrome
```

웹만 빠르게 볼 때:

```bash
flutter run -d web-server --web-port 8080
```

## 테스트

```bash
flutter test
```

주요 테스트:

- `test/widget_test.dart` — 홈 렌더
- `test/package_recommender_test.dart` — 등급 추천
- `test/consultation_summary_test.dart` — 상담 요약·메일
- `test/content_repository_test.dart` — JSON 로드
- `test/router_test.dart` — `/packages`, 404
- `test/mailto_helper_test.dart` — mailto 길이 제한

## 웹 빌드

```bash
flutter build web --release
```

결과물: `build/web/`  
`web/`에 둔 `robots.txt`, `sitemap.xml`, `og-image.png`, 아이콘 등이 함께 복사됩니다.

## Firebase 배포

프로젝트 ID는 **반드시** `sotongware-marketing`만 사용하세요.  
다른 Firebase 프로젝트에 배포하지 마세요.

```bash
flutter build web --release
firebase use sotongware-marketing
firebase deploy --only hosting
```

- Hosting public: `build/web` (`firebase.json`)
- `.firebaserc` default: `sotongware-marketing`

## URL·연락처

| 항목 | 값 |
|------|-----|
| 사이트 | https://sotongware-marketing.web.app/ |
| 이메일 | sotongware@naver.com |
| 브랜드 | 소통웨어 (SotongWare) |

## 프로젝트 구조

```
lib/
  app/                 # App, Shell, GoRouter
  core/                # 상수, 모델, 서비스, mailto
  features/            # 페이지별 UI
  shared/              # 레이아웃·테마·공통 위젯
assets/
  branding/            # 브랜드 SVG
  data/                # JSON 콘텐츠
web/
  index.html           # SEO / OG / Twitter Card
  manifest.json
  robots.txt
  sitemap.xml
  og-image.png / .svg
  icons/               # favicon·PWA 아이콘·SVG
tool/
  render_marketing_icons.js  # SVG → PNG 변환
test/                  # 단위·위젯 테스트
```

## 아이콘·OG 이미지 재생성

브랜드 SVG를 수정한 뒤 PNG를 다시 만들려면:

```bash
cd tool
npm install
node render_marketing_icons.js
```

생성물:

- `web/favicon.png` (48)
- `web/icons/Icon-192.png`, `Icon-512.png`
- `web/icons/Icon-maskable-192.png`, `Icon-maskable-512.png`
- `web/og-image.png` (1200×630)

소스 SVG:

- `web/icons/sotong_marketing_icon.svg`
- `web/icons/sotong_marketing_icon_maskable.svg` (안전한 중앙 ~80% 영역)
- `assets/branding/sotong_marketing_icon.svg` (앱에서도 사용)
- `web/og-image.svg`
