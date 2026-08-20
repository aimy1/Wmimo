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
  </p>
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
| 📱 **Android** | ✅ **Ready** | Universal APK & Split ABIs (`arm64-v8a`, `v7a`, `x86_64`) | VpnService driver integration, compact mobile UI, background persistence. |
| 🍎 **macOS** | 🚧 **In Progress** | DMG Installer | NetworkExtension daemon architecture in development. |
| 🍏 **iOS** | 🚧 **In Progress** | IPA | NetworkExtension framework integration. |

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
  - Collapsible proxy group boards for streamlined node navigation.
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

# Linux Release (Builds and packages Deb, RPM, AppImage, Arch & Tarball)
flutter build linux --release
bash tool/package_linux.sh v1.0.32

# Android APK
flutter build apk --release
```

---

## 🚀 Automated CI/CD Releases

Automated multi-platform packaging is handled seamlessly via GitHub Actions (`.github/workflows/release.yml`):

- **Windows x64 / ARM64**: Inno Setup Installer (`.exe`) + Portable Zip (`.zip`)
- **Linux (All Distros)**: Debian (`.deb`) + RedHat (`.rpm`) + Universal (`.AppImage`) + Arch (`.pkg.tar.zst`) + Portable (`.tar.gz`)
- **Android**: Split ABIs (`arm64-v8a`, `armeabi-v7a`, `x86_64`) + Universal APK
- **Checksums**: Auto-generated `SHA256SUMS.txt` for security verification.

---

## 🙏 Acknowledgements

We express our heartfelt gratitude to the open-source community:

- 🌟 **Special thanks to [GooRingX (vowe)](https://github.com/GooRingX)** for outstanding open-source contributions and design inspiration!
- 🚀 **Special thanks to [Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** team for the state-of-the-art core engine.
- 💙 **Thanks to [Flutter](https://flutter.dev/)** team and community for the cross-platform UI framework.

---

## 💖 Sponsorship & Donation

If you enjoy Wmimo, consider buying the author a coffee:

- **Token / Currency**: `USDT`
- **Network / Chain**: `APTOS`
- **Address**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 License

This project is licensed under the **GPL-3.0 License**. See the [LICENSE](LICENSE) file for details.
