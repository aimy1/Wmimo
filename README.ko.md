# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>현대적인 크로스 플랫폼 Clash / Mihomo 프록시 GUI 클라이언트</h3>
  <p>Flutter 및 Mihomo 코어를 기반으로 제작되어 초고속, 우아함, 강력한 전체 프로토콜 프록시 경험을 제공합니다.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>
</div>

---

## 🔥 Beta 브랜치 주요 변경 사항 (What's New in Beta)

> [!TIP]
> 현재 브랜치는 **`beta` 테스트 브랜치**로, 최신 프로토콜 지원, Linux 런타임 최적화 및 프록시 노드 안정성 개선 사항이 포함되어 있습니다:

- 🔄 **범용 구독 변환기 (`SubscriptionConverter`)**：
  - **Base64 인코딩 구독** 및 개별 노드 링크(`vmess://`, `vless://` (Reality/Vision), `ss://`, `trojan://`, `hysteria2://` / `hy2://`, `tuic://` 등)를 자동 감지 및 변환;
  - 지역별 스마트 그룹(🇭🇰 홍콩, 🇯🇵 일본, 🇸🇬 싱가포르, 🇹🇼 대만, 🇺🇸 미국, 🇰🇷 한국 등), `노드 선택`, `자동 선택`, `장애 조치(Fallback)` 자동 생성;
  - '프로필 추가' 화면에서 노드 링크나 Base64 텍스트를 직접 붙여넣어 가져오기 지원.
- 🐧 **Linux 연결 안정성 및 작업 디렉터리 권한 최적화**：
  - 코어 작업 디렉터리 `work_dir`를 쓰기 가능한 `~/.local/share/wmimo`로 설정하여 AppImage 환경의 `cache.db` 권한 오류 해결;
  - 코어 시작 전 `proxy-groups:` 완전성을 보장하여 연결 후 노드가 사라지는 문제 해결.
- 🎯 **내부 어댑터 필터링 및 프록시 노드 보호**：
  - Mihomo Meta 내부 제어 어댑터(`COMPATIBLE`, `PASS`, `PASS-RULE`, `REJECT-DROP`, `DIRECT`, `REJECT`, `DNS`)를 정확하게 필터링;
  - 지연 시간 테스트(⚡) 및 UI 표시가 항상 실제 프록시 노드에만 적용되도록 보장.
- 📦 **모든 주요 Linux 배포판 패키징 지원**：
  - AppImage(무설치 포터블), Debian/Ubuntu(`.deb`), Fedora/RHEL(`.rpm`), Arch Linux(`.pkg.tar.zst` & `PKGBUILD`), 포터블 아카이브(`.tar.gz`) 지원.

---

## 📌 플랫폼 지원 현황

| 플랫폼 | 상태 | 패키지 형식 | 설명 |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **완료** | 설치 프로그램 (`.exe`) 및 포터블 (`.zip`) | 데스크톱 사이드바, 시스템 트레이 메뉴, 실시간 트래픽 차트, TUN 모드, 자동 업데이트. |
| 🐧 **Linux** | ✅ **준비 완료** | Debian 패키지 (`.deb`) 및 포터블 (`.tar.gz`) | 네이티브 GTK3 UI, 시스템 트레이 연동, Linux용 Mihomo 데몬 내장. |
| 📱 **Android** | ✅ **준비 완료** | 통합 APK 및 ABI 분할 APK | VpnService 드라이버 내장, 모바일 맞춤형 UI, 백그라운드 유지. |
| 🍎 **macOS** | 🚧 **개발 중** | DMG 설치 파일 | NetworkExtension 아키텍처 적응 중. |
| 🍏 **iOS** | 🚧 **개발 중** | IPA | NetworkExtension 프레임워크 연동 중. |

---

## ✨ 핵심 기능

- 🎨 **세련되고 모던한 UI**: 라이트/다크 모드 완벽 지원, 반응형 적응형 레이아웃 (모바일 및 데스크톱 사이드바).
- ⚡ **고성능 Mihomo 코어**: Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard 프로토콜 완벽 지원.
- 🔀 **풍부한 시스템 트레이 메뉴**: 실시간 업/다운로드 속도 표시, 프록시 모드 전환, 핑 측정, 구독 원클릭 업데이트.
- 📊 **실시간 모니터링 & 진단**: 베지어 트래픽 그래프, 실시간 IP & ISP 조회 카드, 접이식 프록시 그룹.
- 🚀 **다중 채널 자동 업데이트**: `stable` (안정 채널) 및 `beta` (테스트 채널) 지원.
- 🌍 **9개 언어 완벽 다국어 지원**: 한국어, 영어, 중국어(간체/번체), 일본어, 러시아어, 스페인어, 아랍어, 페르시아어.

---

## 💖 후원 및 기부

- **토큰 (Currency)**: `USDT`
- **네트워크 (Network)**: `APTOS`
- **지갑 주소 (Address)**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 라이선스

본 프로젝트는 **GPL-3.0** 라이선스에 따라 배포됩니다.
