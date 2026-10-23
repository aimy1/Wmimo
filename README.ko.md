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
    <a href="#주요-기능"><b>주요 기능</b></a> •
    <a href="#빠른-시작"><b>빠른 시작</b></a> •
    <a href="https://t.me/wmimoapp"><b>커뮤니티</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo 라이트 모드" width="45%" />&nbsp;&nbsp;&nbsp;&nbsp;<img src="docs/preview_dark.png" alt="Wmimo 다크 모드" width="45%" />
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
  - Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard 등 전 프로토콜 지원.
  - 백그라운드 Isolate 비동기 노드 파싱 — **시작 시 UI 멈춤 현상 제로 (Zero UI Freeze)**.
- **스마트 라우팅 및 듀얼 프록시 엔진**:
  - 규칙 분류 (Rule) / 글로벌 (Global) / 직결 (Direct) 모드 원클릭 전환.
  - **TUN 가상 어댑터 모드** (시스템 전체 투명 캡처) 및 **시스템 프록시 모드** (간편 무권한 연결).
  - Android 앱별 분할 프록시 및 Windows UWP Loopback 제외 도구.
- **실시간 트래픽 원격 분석 & 종합 진단 도구**:
  - 1분/5분/15분/30분/60분 다중 시간 축 베지에 곡선 트래픽 그래프.
  - 출구 IP, 위치 및 ISP 정보 즉시 조회, 원터치 복사 및 마스킹 보안 기능.
  - 구독 플랜 데이터 사용량 진행률 및 만료일 카운트다운.
- **운영체제 네이티브 깊은 통합**:
  - **Windows**: 앱 테마와 동기화되는 트레이 메뉴, 트레이 아이콘 실시간 속도 표시, `comctl32 v6` 비주얼 스타일.
  - **Android**: 백그라운드 상주 알림 (즉시 연결 끊기 버튼 탑재), 퀵 세팅 타일, 실시간 다국어 동기화.
  - **macOS**: 메뉴바 Template 아이콘 지원.
- **완벽한 9개국어 네이티브 번역**:
  - 한국어, 영어, 중국어(간체/번체), 일본어, 러시아어, 스페인어, 아랍어, 페르시아어 705개 키 100% 매칭.

---

## 빠른 시작

1. **다운로드**: [Releases 페이지](https://github.com/aimy1/Wmimo/releases)에서 사용 중인 OS에 맞는 패키지를 다운로드합니다.
2. **구독 가져오기**: '구독 관리'에서 Clash/Mihomo 링크를 붙여넣거나 로컬 YAML 파일을 불러옵니다.
3. **연결**: '홈' 화면에서 스위치를 켜면 즉시 보안 프록시 통신이 시작됩니다.
   - *Windows 팁*: **TUN 모드**를 사용하려면 앱을 마우스 우클릭 후 【관리자 권한으로 실행】하십시오. 일반 웹서핑은 **시스템 프록시 모드**로도 충분합니다.

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## 커뮤니티 & 문의

- **Telegram 공식 채널**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **개발자 이메일**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **이슈 제보**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## 라이선스

이 프로젝트는 **GPL-3.0 라이선스**에 따라 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하십시오.
