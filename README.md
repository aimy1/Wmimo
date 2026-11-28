<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---

<div align="center">
  <img src="assets/images/app_icon_256.png" width="96" height="96" alt="Wmimo Logo" />
  <h1>Wmimo</h1>
  <p><strong>Next-Generation Cross-Platform Clash / Mihomo GUI Proxy Client</strong></p>
  <p>Built with Flutter & Mihomo Core (v1.19.34). Designed for zero telemetry, multi-hop chaining, real-time diagnostics, and native OS integration across desktop and mobile.</p>

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
    <a href="https://github.com/aimy1/Wmimo/releases"><b>Download</b></a> ·
    <a href="#sec-platforms"><b>Platforms</b></a> ·
    <a href="#sec-features"><b>Features</b></a> ·
    <a href="#sec-quickstart"><b>Quick Start</b></a> ·
    <a href="#sec-build"><b>Build</b></a> ·
    <a href="#sec-security"><b>Security & License</b></a> ·
    <a href="#sec-community"><b>Community</b></a>
  </p>
</div>

| Light Mode | Dark Mode |
| :---: | :---: |
| <img src="docs/preview_light.png" alt="Wmimo Light Theme" width="360" /> | <img src="docs/preview_dark.png" alt="Wmimo Dark Theme" width="360" /> |

<p align="center"><sub><em>18px micro-card dashboard, live Bezier throughput graph, dual TUN / System Proxy engines, and customizable home cards</em></sub></p>

---

<a id="sec-platforms"></a>

## Supported Platforms & Release Artifacts

| Platform | Architecture | Release Packages | Platform Highlights |
| :--- | :--- | :--- | :--- |
| **Windows** | `x64`, `arm64` | Installer (`.exe`), Portable (`.zip`) | Unprivileged System Proxy, WHQL-signed Wintun TUN (Admin), UWP Loopback helper, Dark/Light Tray & live speed, Global Hotkeys |
| **macOS** | `Universal` (`arm64` + `x64`) | `.dmg` Installer, Portable (`.zip`) | Privileged service authorization (`osascript` env-safe), System Proxy & TUN, adaptive Menu Bar icon, iCloud Drive sync, Global Hotkeys |
| **Linux** | `x64`, `arm64` | `.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz` | `setcap` / privileged service TUN, System Proxy, GTK3 desktop shell, Global Hotkeys |
| **Android** | `arm64-v8a`, `armeabi-v7a`, `x86_64` | Split ABI & Universal `.apk` | Live hot-swap Per-App Proxy (Whitelist/Blacklist + presets), Battery Optimization Keep-Alive, Quick Settings Tile, Foreground notification |
| **iOS** | `arm64` | Unsigned `.ipa` (TrollStore / Sideload) | Network Extension VPN tunnel & iCloud Drive backup sync (see [Apple Dev Guide](docs/APPLE_DEVELOPMENT.md)) |

> Download official binaries from [GitHub Releases](https://github.com/aimy1/Wmimo/releases) and verify Android APK SHA-256 / Wintun signatures against [SECURITY.md](SECURITY.md).

---

<a id="sec-features"></a>

## Core Capabilities & Feature Highlights

| Module | Key Capabilities |
| :--- | :--- |
| **Mihomo Routing Core** | `v1.19.34` • Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH, Direct • Isolate YAML parser (`5,000` nodes in `~163 ms`) |
| **Multi-Hop Chain Proxy `[Beta]`** | Built on **`dialer-proxy`** orchestration (`Entry ➔ Transit... ➔ Exit`), drag/swap hop ordering, anti-duplicate validation, atomic `chain_proxies.json` surviving subscription updates |
| **Mobile Per-App Proxy** | Android allowlist/blocklist with empty-whitelist leak guard, live VPN interface hot-swap without restarting Mihomo, Launcher + system app deduplicated discovery & auth-free presets |
| **Network Diagnostics (`NetCheck`)** | 2-phase concurrent 5-step pipeline (NIC/gateway ignoring virtual TUN NICs, DNS & Fake-IP `198.18.0.0/15`, Core/Ports, Proxy/TUN, Active Node 204 probe) + Domain Query + One-Click Auto-Repair |
| **Speed Test Engine (`SpeedTest`)** | Multi-stream HTTP download/upload, steady Ping & Jitter, real-time dual-series waveform chart, scenario grades (`Gaming / 8K / Calls`), concurrent CDN latency badges, proxy pre-flight check |
| **Backup & Sync** | WebDAV, iCloud Drive (iOS/macOS), local & URL `.zip` export/restore; includes `chain_proxies.json`, optional-file resilience, pre-staged atomic restore & Zip-Slip protection |
| **Micro-Card UI & Telemetry** | Light & OLED Dark themes, customizable Home Cards Manager, Auto-Orientation enabled by default, multi-span Bezier traffic wave (`1m–60m`), egress IP/Geo/ISP with privacy masking |
| **Privacy & Localization** | Zero telemetry/analytics SDKs, strict local execution, **9 languages × 959 keys (100% parity)** plus dedicated 9-language Privacy Policy & User Agreement views |

---

<a id="sec-quickstart"></a>

## Quick Start

1. **Download & Install**: Grab the matching package for your OS from [GitHub Releases](https://github.com/aimy1/Wmimo/releases).
2. **Import Profile**: Open `Subscriptions` and paste a Clash/Mihomo URL or import a local YAML file.
3. **Connect**: Toggle the master switch on `Overview` to start routing immediately.

<details>
<summary><b>Platform-Specific Setup Notes (Windows / Android / macOS & Linux / iOS)</b></summary>

- **Windows**: Use **System Proxy Mode** without elevation, or right-click **Run as administrator** for WHQL Wintun **TUN Mode**. Create a `portable` folder beside `wmimo.exe` (or toggle Portable Mode in settings) for self-contained storage.
- **Android**: Grant VPN permission on first connect. In Settings, whitelist Wmimo from **Battery Optimization** for background keep-alive and configure **Per-App Proxy** (live hot-swap supported without reconnecting core).
- **macOS & Linux**: TUN mode requests one-time service authorization via secure stdin (`sudo -S`) or system prompt (`osascript` / `pkexec`).
- **iOS**: Distributed as unsigned `.ipa` for TrollStore or personal sideloading; see [docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md) for App Group & signing details.

</details>

---

<a id="sec-build"></a>

## Build from Source

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) & [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- Platform toolchains: Visual Studio 2022 C++ (Windows), Xcode (macOS/iOS), GTK3/Clang/CMake/Ninja (Linux), Android SDK & NDK (Android)

```bash
git clone https://github.com/aimy1/Wmimo.git && cd Wmimo
flutter pub get && dart run slang
dart run tool/download_all_cores.dart
flutter run
# Release: flutter build {windows|macos|linux|apk} --release
```

---

## Performance & Automated Verification

- **Subscription Parsing**: `~30,670 nodes/s` — `5,000` multi-protocol nodes parsed & grouped in `~163 ms` inside a background Isolate.
- **Format Fast-Path**: `SubscriptionConverter.isClashYaml` detects `1,000` nodes in `~1.4 ms`.
- **i18n Parity**: **9/9 locales × 898 keys = 100.0% coverage** (`0` missing keys, `0` empty values) + 9 localized Privacy Policies (`assets/txts/`).
- **Reproduce Locally**: Run `flutter analyze --no-pub lib/ third_party/libclash_vpn_service/lib/ test/`, `flutter test test/benchmark_profile_scale_test.dart`, `flutter test test/i18n_integrity_test.dart`, and `dart run tool/verify_i18n.dart`.

Full benchmark methodology & hardware details: [docs/BENCHMARKS.md](docs/BENCHMARKS.md).

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

<a id="sec-security"></a>

## Security, Privacy & Licensing

- **Zero Data Collection**: Strictly local execution; zero analytics, crash telemetry, or ad SDKs. Read full terms in [assets/txts/privacy_policy_en.txt](assets/txts/privacy_policy_en.txt).
- **Artifact Authenticity**: Verify official Android APK SHA-256 certificate fingerprints and WHQL Wintun notices in [SECURITY.md](SECURITY.md).
- Licensed under the **GNU General Public License v3.0 (GPL-3.0-or-later)**. See [LICENSE](LICENSE).
- **Rust Workspace Crates**: Dual-licensed under [MIT](rust/LICENSE-MIT) OR [Apache-2.0](rust/LICENSE-APACHE) standalone, and GPL-3.0 when distributed as part of Wmimo.
- **Third-Party & Core Components**: See [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) and [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md).

---

<a id="sec-community"></a>

## Community & Feedback

- **Official Website**: [wmimo.buzz](https://wmimo.buzz) · **Telegram Channel**: [t.me/wmimoapp](https://t.me/wmimoapp) · **Author Email**: [aisaniya@proton.me](mailto:aisaniya@proton.me) · **Issue Tracker**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

**Acknowledgements**: **[GooRingX (vowe)](https://github.com/GooRingX)** — architectural insights and open-source inspiration. · **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** — high-performance core routing & protocol engine. · **[Flutter](https://flutter.dev/)** — cross-platform UI framework.
