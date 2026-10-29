# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>차세대 크로스 플랫폼 Clash / Mihomo GUI 프록시 클라이언트</strong></p>
  <p align="center">Flutter와 초고성능 Mihomo 코어로 제작되었습니다. 최고의 속도, 우아한 모던 디자인 및 완벽한 프로토콜 호환성을 선사합니다.</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>다운로드</b></a> •
    <a href="https://wmimo.buzz"><b>공식 웹사이트</b></a> •
    <a href="#주요-기능"><b>주요 기능</b></a> •
    <a href="docs/BENCHMARKS.md"><b>성능 벤치마크</b></a> •
    <a href="#빠른-시작"><b>빠른 시작</b></a> •
    <a href="#소스코드-빌드"><b>소스 빌드</b></a> •
    <a href="https://t.me/wmimoapp"><b>커뮤니티</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo 라이트 모드" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo 다크 모드" width="370" />
  </p>
  <sub><em>세련된 18px 마이크로 카드 UI, 부드러운 실시간 베지에 트래픽 그래프, 종합 네트워크 진단 (라이트 & 다크 듀얼 테마)</em></sub>
</div>

---

## 주요 기능

- **아티잔 마이크로 카드 디자인 & 네이티브 듀얼 테마**:
  - 18px 곡률 마이크로 카드와 감각적인 시안 블루 컬러의 절제된 미학.
  - 라이트 모드와 깊이 있는 다크 모드를 완벽하게 지원.
  - 대화면 데스크톱 사이드바와 모바일 한 손 레이아웃 자동 적응.
- **강력한 Mihomo (Meta) 코어 엔진**:
  - Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH, Direct 등 전 프로토콜 지원.
  - 백그라운드 Isolate 비동기 노드 파싱 및 정렬 — UI 지연 없는 논블로킹 로딩 (5,000개 노드 파싱 약 163ms 소요, [성능 벤치마크](docs/BENCHMARKS.md) 참조).
- **스마트 라우팅 및 듀얼 프록시 엔진**:
  - 규칙 분류 (Rule) / 글로벌 (Global) / 직결 (Direct) 모드 원클릭 전환.
  - **TUN 가상 어댑터 모드** (시스템 전체 투명 캡처) 및 **시스템 프록시 모드** (간편 무권한 연결).
  - Android 앱별 분할 프록시 및 Windows UWP Loopback 제외 도구.
- **실시간 트래픽 원격 분석 & 종합 진단 도구**:
  - 1분/5분/15분/30분/60분 다중 시간 축 베지에 곡선 트래픽 그래프.
  - 출구 IP, 위치 및 ISP 정보 즉시 조회, 원터치 복사 및 마스킹 보안 기능.
  - 구독 플랜 데이터 사용량 진행률 및 만료일 카운트다운.
  - 전체 진단 도구: 라우팅 규칙 검사기, 실시간 코어 콘솔 로그, 병렬 Ping 테스트, 런타임 설정 뷰어.
- **운영체제 네이티브 깊은 통합**:
  - **Windows**: 앱 테마와 동기화되는 트레이 메뉴, 트레이 아이콘 실시간 속도 표시, `comctl32 v6` 비주얼 스타일.
  - **Android**: 백그라운드 상주 알림 (즉시 연결 끊기 버튼 탑재), 퀵 세팅 타일, 실시간 다국어 동기화.
  - **macOS**: 메뉴바 Template 아이콘 지원 및 시스템 프록시 자동화.
- **멀티 채널 무중단 자동 업데이트**:
  - `stable` (안정 버전) 및 `beta` (프리뷰 버전) 채널을 자유롭게 전환.
  - 백그라운드 무소음 고속 다운로드 및 SHA-256 해시 무결성 검증.
- **완벽한 9개국어 네이티브 번역**:
  - 한국어, 영어, 중국어(간체/번체), 일본어, 러시아어, 스페인어, 아랍어, 페르시아어 798개 키 100% 매칭 (0 누락 키, [벤치마크](docs/BENCHMARKS.md) 참조).

---

## 빠른 시작

1. **다운로드**: [Releases 페이지](https://github.com/aimy1/Wmimo/releases)에서 사용 중인 OS에 맞는 패키지를 다운로드합니다.
2. **구독 가져오기**: '구독 관리'에서 Clash/Mihomo 링크를 붙여넣거나 로컬 YAML 파일을 불러옵니다.
3. **연결**: '홈' 화면에서 스위치를 켜면 즉시 보안 프록시 통신이 시작됩니다.
   - *Windows 팁*: **TUN 모드**를 사용하려면 앱을 마우스 우클릭 후 【관리자 권한으로 실행】하십시오. 일반 웹서핑은 **시스템 프록시 모드**로도 충분합니다.

---

## 소스코드 빌드

### 환경 요구사항
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- 호스트 플랫폼 컴파일러 툴체인 (Windows: Visual Studio 2022 C++, Linux: GTK3/Clang/CMake, Android: Android SDK)

### 빌드 명령어

```bash
# 1. 저장소 복제
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. 패키지 설치 및 다국어 코드 생성
flutter pub get
dart run slang

# 3. 플랫폼별 Mihomo 코어 다운로드
dart run tool/download_all_cores.dart

# 4. 개발 모드 실행
flutter run

# 5. 배포 바이너리 빌드
flutter build windows --release   # Windows
flutter build apk --release       # Android
flutter build linux --release     # Linux
flutter build macos --release     # macOS
```

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## 성능 및 품질 검증

Wmimo의 아키텍처 효율성과 커버리지는 독립적으로 재현 가능한 자동화 테스트를 통해 검증됩니다:

- **구독 파싱 처리량**: 초당 약 30,670개 노드 (5,000개 다중 프로토콜 노드를 백그라운드 Isolate에서 약 163ms 만에 파싱 및 분류).
- **빠른 포맷 탐지**: `isClashYaml` 알고리즘으로 1,000개 노드 설정을 약 1.4ms 내에 검증.
- **다국어 완성도**: 9개 언어 각 798개 키 100.0% 완전 일치 (0 누락 키).
- **자동 검증 실행**: `flutter test test/benchmark_profile_scale_test.dart` 및 `flutter test test/i18n_integrity_test.dart`.

상세한 벤치마크 보고서 및 테스트 환경은 [docs/BENCHMARKS.md](docs/BENCHMARKS.md)에서 확인하실 수 있습니다.

---

## 감사의 말

- **[GooRingX (vowe)](https://github.com/GooRingX)**: 탁월한 오픈소스 기여와 설계 통찰력에 진심으로 감사드립니다.
- **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**: 강력한 코어 엔진과 전 프로토콜 지원에 감사드립니다.
- **[Flutter](https://flutter.dev/)**: 뛰어난 크로스 플랫폼 프레임워크 지원에 감사드립니다.

---

## 커뮤니티 & 문의

- **공식 웹사이트**: [wmimo.buzz](https://wmimo.buzz)
- **Telegram 공식 채널**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **개발자 이메일**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **이슈 제보**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## 라이선스

이 프로젝트는 **GNU General Public License v3.0 (GPL-3.0-or-later)**에 따라 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하십시오.

- **Rust Workspace 크레이트**: 독립 라이브러리로 사용 시 [MIT](rust/LICENSE-MIT) 또는 [Apache-2.0](rust/LICENSE-APACHE) 듀얼 라이선스가 적용되며, Wmimo와 함께 배포 시 GPL-3.0을 따릅니다.
- **서드파티 및 핵심 컴포넌트 라이선스**: [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) 및 [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)를 참조하십시오.
- **보안 정책 및 서명 인증서**: 공식 Android APK 서명 인증서 지문(SHA-256) 및 릴리스 검증 가이드는 [SECURITY.md](SECURITY.md)를 참조하십시오.
