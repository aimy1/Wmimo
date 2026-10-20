# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>Next-Generation Cross-Platform Clash / Mihomo GUI Proxy Client</strong></p>
  <p align="center">Crafted with Flutter & the high-performance Mihomo core. Engineered for speed, modern elegance, and multi-protocol flexibility.</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>Download</b></a> •
    <a href="#features"><b>Features</b></a> •
    <a href="#quick-start"><b>Quick Start</b></a> •
    <a href="#build-from-source"><b>Build</b></a> •
    <a href="https://t.me/wmimoapp"><b>Community</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo Light Theme" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo Dark Theme" width="370" />
  </p>
  <sub><em>18px micro-card layout system, real-time bezier traffic wave, and system-level proxy routing (Light & Dark dual themes)</em></sub>
</div>

---

## Features

- **Artisan Micro-Card UI & Native Dual Themes**:
  - Precision 18px rounded micro-card system infused with the signature cyan-blue accent.
  - Native, seamless transitions between Clean Light mode and Deep OLED Dark mode.
  - Responsive layout: expansive Desktop Sidebar on large screens & compact ergonomic navigation on mobile devices.
- **High-Performance Mihomo (Meta) Core**:
  - Full protocol suite: **Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH, Direct**.
  - Asynchronous background Isolate processing for node parsing and sorting — **Zero UI Freeze** during startup.
- **Intelligent Routing & Dual-Engine Proxy**:
  - Rapid outbound mode toggling: **Rule (Split Routing)** / **Global** / **Direct**.
  - Flexible dual engine: **TUN Virtual Adapter Mode** (transparent system-wide capture) and **System Proxy Mode** (standard unprivileged routing).
  - Fine-grained traffic steering: Android Per-App Proxy filtering and Windows UWP Loopback exemption utility.
- **Deep Real-Time Telemetry & Diagnostics**:
  - Ultra-smooth Bezier traffic wave monitor with multi-window spans (1m / 5m / 15m / 30m / 60m).
  - Instant egress IP, geolocation, and ISP lookup card with one-tap copy and privacy masking.
  - Subscription plan data usage progress bar with expiration countdown.
  - Built-in diagnostic toolset: Routing Rules inspection, Real-time Core Logs, Concurrent Latency Ping, and Runtime Configuration viewer.
- **Deep Native Operating System Integration**:
  - **Windows**: Native dark/light adaptive tray context menu, real-time download/upload speed indicator in tray, and modern `comctl32 v6` visual styling.
  - **Android**: Foreground service notification with instant disconnect action, Quick Settings Pull-Down Tile, and automatic language synchronization.
  - **macOS**: Adaptive menu bar Template icon and system proxy automation.
- **Multi-Channel Silent Auto-Updates**:
  - Switch freely between `stable` (production) and `beta` (pre-release) channels.
  - Background silent download with SHA-256 hash integrity verification.
- **True 100% Native 9-Language Parity**:
  - Complete, seamless coverage across: 简体中文, English, 繁體中文, 日本語, 한국어, Русский, Español, العربية, فارسی.

---

## Quick Start

1. **Download & Install**: Grab the latest release package for your operating system from the [Releases](https://github.com/aimy1/Wmimo/releases) page.
2. **Import Subscription**: Navigate to `Subscriptions`, paste your Clash/Mihomo subscription link or import a local YAML profile.
3. **Connect & Enjoy**: Click the master connect toggle on the `Overview` screen to begin routing.
   - *Windows Note*: To use **TUN Mode**, launch Wmimo by right-clicking and choosing **Run as administrator**; or simply use **System Proxy Mode** for effortless unprivileged browsing.

---

## Build from Source

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- Host compiler toolchain (Visual Studio 2022 C++ on Windows, GTK3/Clang/CMake on Linux, Android SDK on Android)

### Quick Commands

```bash
# 1. Clone repository
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. Fetch dependencies and generate i18n
flutter pub get
dart run slang

# 3. Download Mihomo cores for all platforms
dart run tool/download_all_cores.dart

# 4. Run development target
flutter run

# 5. Build production binaries
flutter build windows --release   # Windows
flutter build apk --release       # Android
flutter build linux --release     # Linux
flutter build macos --release     # macOS
```

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## Acknowledgements

- **[GooRingX (vowe)](https://github.com/GooRingX)**: Invaluable open-source contributions, architectural insights, and design inspiration.
- **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**: Phenomenal core engine and protocol support.
- **[Flutter](https://flutter.dev/)**: Empowering modern cross-platform user interface framework.

---

## Community & Feedback

- **Telegram Channel & Group**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **Author Email**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **Issue Tracker**: [Submit an Issue](https://github.com/aimy1/Wmimo/issues)

---

## License

Wmimo is licensed under the **GNU General Public License v3.0 (GPL-3.0)**. See the [LICENSE](LICENSE) file for details.
