<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---

<div align="center">
  <img src="assets/images/app_icon_256.png" width="96" height="96" alt="Wmimo Logo" />
  <h1>Wmimo</h1>
  <p><strong>차세대 크로스 플랫폼 Clash / Mihomo GUI 프록시 클라이언트</strong></p>
  <p>Flutter와 Mihomo 코어(v1.19.34) 기반으로 제작되었습니다. 데이터 수집 제로 원칙과 멀티홉 체인 프록시, 병렬 네트워크 진단, 실시간 파형 속도 측정을 제공합니다.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/stargazers"><img src="https://img.shields.io/github/stars/aimy1/Wmimo?color=F59E0B&label=Stars&logo=github&style=flat-square" alt="Stars" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions/workflows/release.yml"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="CI Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&label=Downloads" alt="Downloads" /></a>
    <a href="https://github.com/MetaCubeX/mihomo"><img src="https://img.shields.io/badge/Mihomo-v1.19.34-FF6B6B?style=flat-square" alt="Mihomo" /></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPL--3.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-%40wmimoapp-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><b>다운로드</b></a> ·
    <a href="#sec-platforms"><b>지원 플랫폼</b></a> ·
    <a href="#sec-features"><b>핵심 기능</b></a> ·
    <a href="#sec-quickstart"><b>빠른 시작</b></a> ·
    <a href="#sec-build"><b>소스 빌드</b></a> ·
    <a href="#sec-security"><b>보안 및 라이선스</b></a> ·
    <a href="#sec-community"><b>커뮤니티</b></a>
  </p>
</div>

| 라이트 모드 | 다크 모드 |
| :---: | :---: |
| <img src="docs/preview_light.png" alt="Wmimo Light Theme" width="360" /> | <img src="docs/preview_dark.png" alt="Wmimo Dark Theme" width="360" /> |

<p align="center"><sub><em>18px 마이크로 카드 대시보드 · 실시간 베지어 트래픽 차트 · TUN / 시스템 프록시 듀얼 엔진</em></sub></p>

---

<a id="sec-platforms"></a>

## 지원 플랫폼 및 릴리스 패키지

| 플랫폼 | 아키텍처 | 배포 형식 | 주요 OS 통합 기능 |
| :--- | :--- | :--- | :--- |
| **Windows** | `x64`, `arm64` | 설치 파일(`.exe`), 포터블(`.zip`) | 비권한 시스템 프록시, WHQL Wintun TUN, UWP 루프백, 트레이 속도 및 테마 동기화, 전역 단축키 |
| **macOS** | `Universal` (`arm64` + `x64`) | `.dmg`, 포터블(`.zip`) | 안전한 서비스 권한 상승/TUN, 적응형 메뉴 막대 아이콘, iCloud Drive 동기화, 전역 단축키 |
| **Linux** | `x64`, `arm64` | `.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz` | `setcap` / 서비스 TUN, 시스템 프록시, GTK3 데스크톱 통합, 전역 단축키 |
| **Android** | `arm64-v8a`, `armeabi-v7a`, `x86_64` | ABI 분할 APK 및 유니버설 `.apk` | 무중단 앱별 프록시 핫스왑, 배터리 최적화 제외 확인, 빠른 설정 타일, 포그라운드 알림 |
| **iOS** | `arm64` | 미서명 `.ipa` (TrollStore / 사이드로딩) | Network Extension VPN 및 iCloud 동기화 ([Apple 개발 가이드](docs/APPLE_DEVELOPMENT.md)) |

> [GitHub Releases](https://github.com/aimy1/Wmimo/releases)에서 다운로드하고 [SECURITY.md](SECURITY.md)에서 APK SHA-256 지문을 확인하세요.

---

<a id="sec-features"></a>

## 핵심 기능 매트릭스

| 모듈 | 핵심 기능 |
| :--- | :--- |
| **Mihomo 라우팅 코어** | `v1.19.34` • SS, VMess, VLESS Reality, Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH • Isolate YAML 파서 (`5,000`개 노드 `~163 ms`) |
| **멀티홉 체인 프록시 `[Beta]`** | **`dialer-proxy`** 기반 다단계 홉 구성, 드래그/스왑 순서 변경, 중복 검사, 구독 업데이트에도 유지되는 `chain_proxies.json` |
| **모바일 앱별 프록시** | 빈 화이트리스트 누수 차단, 코어 재시작 없는 실시간 핫스왑, Launcher 통합 검색 및 무권한 프리셋 |
| **네트워크 진단 (`NetCheck`)** | 2단계 5항목 병렬 진단(가상 TUN 제외, DNS/Fake-IP 점검, 포트, 프록시/TUN, 출구 204 핸드셰이크) + 도메인 검사 + 원클릭 자동 복구 |
| **속도 측정 (`SpeedTest`)** | 다중 스트림 HTTP 속도 측정, 안정적 Ping/Jitter, 실시간 송수신 파형 그래프, 시나리오 등급, CDN 지연시간 배지 |
| **백업 및 동기화** | WebDAV, iCloud Drive, 로컬/URL `.zip` 백업(체인 프록시 포함, 임시 스테이징 검증 및 Zip-Slip 차단) |
| **UI 및 모니터링** | 라이트/다크 테마, 홈 카드 관리, 화면 회전 기본 활성화, 1m–60m 트래픽 차트, 출구 IP 마스킹 |
| **개인정보 및 9개 언어** | 텔레메트리/광고 SDK 제로, **9개 언어 × 898개 키 100% 일치** 및 9개 언어 개인정보 처리방침 |

---

<a id="sec-quickstart"></a>

## 빠른 시작

1. **다운로드**: [GitHub Releases](https://github.com/aimy1/Wmimo/releases)에서 OS 설치 파일을 받습니다.
2. **구독 가져오기**: 구독 메뉴에 Clash/Mihomo 링크 또는 로컬 YAML을 추가합니다.
3. **연결**: 홈 상단 스위치를 켜서 라우팅을 시작합니다.

<details>
<summary><b>플랫폼별 팁 (Windows / Android / macOS·Linux / iOS)</b></summary>

- **Windows**: 일반 브라우징은 시스템 프록시, TUN 모드는 관리자 권한 실행이 필요합니다. `portable` 폴더 생성 시 포터블 모드로 동작합니다.
- **Android**: 배터리 최적화 제외 설정을 권장하며, 앱별 프록시는 연결 중에도 즉시 핫스왑 적용됩니다.
- **iOS**: 미서명 `.ipa`로 배포됩니다([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)).

</details>

---

<a id="sec-build"></a>

## 소스에서 빌드

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) & [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- 플랫폼별 빌드 도구 (VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK)

```bash
git clone https://github.com/aimy1/Wmimo.git && cd Wmimo
flutter pub get && dart run slang
dart run tool/download_all_cores.dart
flutter run
# Release: flutter build {windows|macos|linux|apk} --release
```

---

## 성능 벤치마크 및 검증

- **구독 파싱**: `~30,670 노드/초` (백그라운드 Isolate에서 `5,000` 노드 `~163 ms` 처리).
- **국제화 커버리지**: **9개 언어 × 898개 키 = 100.0%** ([docs/BENCHMARKS.md](docs/BENCHMARKS.md)).

자세한 방법론: [docs/BENCHMARKS.md](docs/BENCHMARKS.md)

---

## Star 히스토리

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

<a id="sec-security"></a>

## 보안, 개인정보 및 라이선스

- **데이터 수집 제로**: [assets/txts/privacy_policy_ko.txt](assets/txts/privacy_policy_ko.txt)
- **인증서 및 서명 검증**: [SECURITY.md](SECURITY.md)
- **GNU General Public License v3.0 (GPL-3.0-or-later)** ([LICENSE](LICENSE)).
- Rust 크레이트: 단독 [MIT](rust/LICENSE-MIT) / [Apache-2.0](rust/LICENSE-APACHE), Wmimo 배포 시 GPL-3.0.
- 서드파티 고지: [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md), [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)

---

<a id="sec-community"></a>

## 커뮤니티 및 피드백

- **공식 웹사이트**: [wmimo.buzz](https://wmimo.buzz) · **Telegram 채널**: [t.me/wmimoapp](https://t.me/wmimoapp) · **이메일**: [aisaniya@proton.me](mailto:aisaniya@proton.me) · **이슈 트래커**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

**감사의 말**: **[GooRingX (vowe)](https://github.com/GooRingX)** · **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** · **[Flutter](https://flutter.dev/)**
