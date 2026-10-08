# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>Modern Cross-Platform Clash / Mihomo Proxy GUI Client</h3>
  <p>Crafted with Flutter & Mihomo core, delivering ultra-fast, elegant, and powerful full-protocol network proxy capabilities.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram" alt="Telegram" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="Wmimo UI Preview" width="380" />
  <br/>
  <sub><em>✨ Sleek 18px micro-card aesthetic, real-time traffic monitor, and comprehensive network diagnostics</em></sub>
</div>

---

## 📌 Platform Support & Linux Multi-Distro Matrix

| Platform / Distro | Status | Supported Formats | Description |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **Production Ready** | Setup (`.exe`) & Portable (`.zip`) | Full desktop sidebar, rich system tray menu, real-time speed & traffic chart, TUN mode, system proxy, auto-update. |
| 🐧 **Linux (Universal)** | ✅ **Ready** | Universal AppImage (`.AppImage`) & Portable (`.tar.gz`) | Self-contained executable, works out-of-the-box on all Linux distributions. |
| 🐧 **Debian / Ubuntu / Mint / Deepin** | ✅ **Ready** | Debian Package (`.deb`) | Native package with desktop entry, icons, and system service integration. |
| 🐧 **Fedora / RHEL / openSUSE** | ✅ **Ready** | RedHat Package (`.rpm`) | Standard RPM package with system dependencies and desktop shortcuts. |
| 🐧 **Arch Linux / Manjaro** | ✅ **Ready** | Arch Package (`.pkg.tar.zst`) & `PKGBUILD` | Native pacman binary package and AUR build script. |
| 📱 **Android** | ✅ **Ready** | Universal APK & Split ABIs (`arm64-v8a`, `v7a`, `x86_64`) | VpnService driver integration, persistent release keystore, compact mobile UI, background keep-alive. |
| 🍎 **macOS** | ✅ **Ready** | DMG Image (`.dmg`) & Portable (`.zip`) | Full desktop UI, menu bar dynamic traffic & system tray, system proxy & TUN mode (Touch ID / admin SUID 4755), auto-update. Automated CI/CD prebuilds and local package script included. |
| 🍏 **iOS** | ✅ **Ready** | Universal IPA (`.ipa`) & Source | Full app, `NetworkExtension` VPN extension, and widgets. Provides unsigned Universal `.ipa` packages perfectly compatible with **TrollStore** (permanent, no Apple ID/certificate required, full system VPN) and sideloading tools (AltStore / Sideloadly / enterprise certs). |

> 💡 **Distribution Policy**: Official CI/CD automated releases provide prebuilt binaries for **Windows**, **macOS**, **Linux**, **Android**, and **iOS**.
> - **macOS**: Fully automated GitHub Actions workflow and local one-click packaging script for `.dmg` and `.zip`.
> - **iOS**: Provides a standalone `.ipa` containing `PlugIns/wmimoService.appex`.
>   - **TrollStore (Recommended)**: For iOS 14.0 - 17.0 (excluding 17.0.1+), install directly with zero Apple ID/certificate requirements, permanent validity, and native NetworkExtension VPN permissions.
>   - **Sideloading Tools (AltStore / SideStore / Sideloadly / Enterprise)**: For iOS 17.0.1+ devices using custom or personal developer certificates.
>   - **Local Xcode Deployment**: Connect iPhone to Mac and run via `ios/Runner.xcworkspace` with a personal Apple ID.

---

## ✨ Key Features

- 🎨 **Minimalist & Modern UI**:
  - Notion/Apple-inspired clean aesthetic with 18px rounded micro-cards and cyan-blue brand accents.
  - Seamless Light & Deep Dark mode transitions.
  - Responsive adaptive layout (Compact Mobile mode & Clash Verge style Desktop Sidebar).
- ⚡ **High-Performance Mihomo Core**:
  - Full support for Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard, Direct protocols.
  - Ultra-low memory footprint and multi-core throughput optimization.
- 🔀 **Full-Featured System Tray Integration**:
  - Dynamic tray icon status with real-time upload/download speeds.
  - One-click outbound mode toggling (Rule / Global / Direct) & TUN mode switcher.
  - Fast node selector with flag badges, delay ping metrics, and one-click subscription refresh.
- 📊 **Real-Time Visual Diagnostics**:
  - Smooth Bezier traffic curves with customizable multi-interval viewing (1m / 5m / 15m / 30m / 60m).
  - Built-in IP & ISP info card with instant geo-lookup and tap-to-copy.
  - Subscription plan usage progress bar & expiration countdown.
  - Quick utility toolset: Routing Rules, Core Logs, Network Check, Speed Test, Runtime Config.
- 🚀 **Intelligent Multi-Channel Auto-Update**:
  - Dual update channels: `stable` (production) and `beta` (preview).
  - Background silent download with SHA-256 verification and automatic in-place installer execution.
- 🌍 **Comprehensive 9-Language Internationalization**:
  - 100% synchronized coverage across 简体中文, English, 繁體中文, 日本語, 한국어, Русский, Español, العربية, فارسی.

---

## 🛠️ Build & Development

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- Target platform build tools (Visual Studio 2022 C++ on Windows, GCC/Clang/GTK3 on Linux, Android SDK on Android)

### Quick Start

```bash
# 1. Clone repository
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. Install dependencies & generate i18n
flutter pub get
dart run slang

# 3. Download multi-platform Mihomo cores
dart run tool/download_all_cores.dart

# 4. Run application
flutter run
```

### Build Distribution Binaries

```bash
# Windows Release
flutter build windows --release

# macOS Release (Universal DMG and Portable Zip)
flutter build macos --release
bash tool/package_macos.sh v1.2.0.1502

# Linux Release (Builds and packages Deb, RPM, AppImage, Arch & Tarball)
flutter build linux --release
bash tool/package_linux.sh v1.2.0.1502

# Android APK
flutter build apk --release

# iOS Release (Build unsigned IPA for TrollStore & Sideloading)
flutter build ios --release --no-codesign
bash tool/package_ios.sh v1.2.0.1502
```

### 🍏 iOS Installation & Sideloading Guide

Wmimo provides an all-in-one unsigned `.ipa` package (`Wmimo-iOS-universal-*.ipa`) containing the main app and the embedded `PlugIns/wmimoService.appex` (PacketTunnel NetworkExtension).

#### 1. TrollStore (Highly Recommended ⭐⭐⭐⭐⭐)
- **Supported iOS Versions**: iOS 14.0 – 17.0 (excluding 17.0.1+).
- **Key Advantages**:
  - **100% Free, No Apple ID, No 7-day expiration, Never revoked**.
  - Grants native `NetworkExtension` entitlements automatically via CoreTrust exploit for full system-wide VPN proxy functionality.
- **How to Install**:
  1. Download `Wmimo-iOS-universal-*.ipa` from [Releases](https://github.com/aimy1/Wmimo/releases);
  2. Open the file in Safari or share via AirDrop to your iPhone;
  3. Tap Share -> **"Open with TrollStore"** -> **"Install"**;
  4. Launch Wmimo and allow the VPN configuration when prompted.

#### 2. Sideloading Utilities (AltStore / SideStore / Sideloadly / Enterprise Certs)
- **Supported Versions**: iOS 17.0.1 and newer.
- **Notes**: Free personal Apple IDs may have restrictions on NetworkExtension profiles; using paid developer accounts or enterprise certificates is advised for system VPN support.

#### 3. Local Xcode Deployment
- Connect your iPhone to your Mac, open `ios/Runner.xcworkspace` in Xcode, sign with your Apple ID, and deploy directly to your device.

---

## 🚀 Automated CI/CD Releases

Automated multi-platform packaging is handled seamlessly via GitHub Actions (`.github/workflows/release.yml`):

- **Windows x64 / ARM64**: Inno Setup Installer (`.exe`) + Portable Zip (`.zip`)
- **macOS Universal (Apple Silicon & Intel)**: DMG Drag-and-Drop (`.dmg`) + Portable Zip (`.zip`)
- **Linux (All Distros)**: Debian (`.deb`) + RedHat (`.rpm`) + Universal (`.AppImage`) + Arch (`.pkg.tar.zst`) + Portable (`.tar.gz`)
- **Android**: Split ABIs (`arm64-v8a`, `armeabi-v7a`, `x86_64`) + Universal APK
- **iOS**: Universal IPA (`.ipa`) tailored for TrollStore permanent installation and sideloading tools
- **Checksums**: Auto-generated `SHA256SUMS.txt` for security verification.

---

## 🙏 Acknowledgements

We express our heartfelt gratitude to the open-source community:

- 🌟 **Special thanks to [GooRingX (vowe)](https://github.com/GooRingX)** for outstanding open-source contributions and design inspiration!
- 🚀 **Special thanks to [Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** team for the state-of-the-art core engine.
- 💙 **Thanks to [Flutter](https://flutter.dev/)** team and community for the cross-platform UI framework.

---

## 📬 Contact & Bug Reports

If you encounter any bugs, crashes, or have feature requests, please contact the author or open an issue:

- 💬 **Telegram Channel**: [t.me/wmimoapp](https://t.me/wmimoapp)
- 📧 **Author Email**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- 🐛 **GitHub Issues**: [Submit an Issue](https://github.com/aimy1/Wmimo/issues)

---

## 📄 License

This project is licensed under the **GPL-3.0 License**. See the [LICENSE](LICENSE) file for details.
