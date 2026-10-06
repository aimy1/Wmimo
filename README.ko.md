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
    <a href="https://wmimo.buzz"><img src="https://img.shields.io/badge/공식웹사이트-wmimo.buzz-00BCDF?style=flat-square&logo=googlechrome&logoColor=white" alt="공식 웹사이트" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="Wmimo 미리보기" width="380" />
  <br/>
  <sub><em>✨ 세련된 18px 마이크로 카드 UI, 실시간 트래픽 모니터링 및 네트워크 진단 도구</em></sub>
</div>

---

## 📌 플랫폼 지원 현황

| 플랫폼 | 상태 | 패키지 형식 | 설명 |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **완료** | 설치 프로그램 (`.exe`) 및 포터블 (`.zip`) | 데스크톱 사이드바, 시스템 트레이 메뉴, 실시간 트래픽 차트, TUN 모드, 자동 업데이트. |
| 🐧 **Linux** | ✅ **준비 완료** | AppImage (`.AppImage`), Debian (`.deb`), RPM (`.rpm`), 포터블 (`.tar.gz`) | 네이티브 GTK3 UI, 시스템 트레이 연동, Linux용 Mihomo 데몬 내장. |
| 📱 **Android** | ✅ **준비 완료** | 통합 APK 및 ABI 분할 APK | VpnService 드라이버 내장, 고정 Release 서명(원활한 덮어쓰기 업데이트), 모바일 맞춤형 UI, 백그라운드 유지. |
| 🍎 **macOS** | 🛠️ **소스 지원** | DMG / 로컬 빌드 | 시스템 프록시 및 TUN 모드 코드 레벨 지원 완료. 로컬 빌드(`flutter run -d macos`) 지원. 공식 릴리스 사전 빌드 배포는 미포함. |
| 🍏 **iOS** | 📦 **프레임워크 준비** | IPA / 소스 | NetworkExtension 아키텍처 및 채널 연동 완료. Apple 서명 제한으로 인해 사전 빌드 IPA는 배포되지 않으며 타사 클라이언트 사용 권장. |

> 💡 **배포 정책**：공식 CI/CD는 **Windows**, **Linux**, **Android** 플랫폼의 사전 빌드 패키지 배포에 집중합니다. macOS 및 iOS는 소스 코드가 준비되어 있으나 공식 릴리스에 사전 빌드 파일은 배포되지 않습니다.

---

## ✨ 핵심 기능

- 🎨 **세련되고 모던한 UI**: 라이트/다크 모드 완벽 지원, 반응형 적응형 레이아웃 (모바일 및 데스크톱 사이드바).
- ⚡ **고성능 Mihomo 코어**: Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard 프로토콜 완벽 지원.
- 🔀 **풍부한 시스템 트레이 메뉴**: 실시간 업/다운로드 속도 표시, 프록시 모드 전환, 핑 측정, 구독 원클릭 업데이트.
- 📊 **실시간 모니터링 & 진단**: 베지어 트래픽 그래프, 실시간 IP & ISP 조회 카드, 접이식 프록시 그룹.
- 🚀 **다중 채널 자동 업데이트**: `stable` (안정 채널) 및 `beta` (테스트 채널) 지원.
- 🌍 **9개 언어 완벽 다국어 지원**: 한국어, 영어, 중국어(간체/번체), 일본어, 러시아어, 스페인어, 아랍어, 페르시아어.

---

## 📬 개발자 문의 및 버그 신고

버그나 오류가 발생하거나 기능 제안이 있으신 경우 언제든지 개발자에게 문의해 주세요:

- 🌐 **공식 웹사이트**: [https://wmimo.buzz](https://wmimo.buzz/)
- 📧 **개발자 이메일**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- 🐛 **GitHub Issues**: [이슈 등록](https://github.com/aimy1/Wmimo/issues)

---

## 📄 라이선스

본 프로젝트는 **GPL-3.0** 라이선스에 따라 배포됩니다.
