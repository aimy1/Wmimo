import 'dart:io';

void main() {
  final langBar = """
<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---
""";

  // 1. English (README.md)
  final enContent = """# Wmimo

$langBar

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

# Linux Release (Builds and packages Deb, RPM, AppImage, Arch & Tarball)
flutter build linux --release
bash tool/package_linux.sh v1.1.5

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
""";

  // 2. Simplified Chinese (README.zh-CN.md)
  final zhCnContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>现代化跨平台 Clash / Mihomo 代理客户端</h3>
  <p>基于 Flutter 与 Mihomo 核心打造，提供极速、优雅、强大的全协议网络代理体验。</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="Wmimo 界面预览" width="380" />
  <br/>
  <sub><em>✨ 18px 微卡片设计美学、实时平滑流量监控与丰富网络诊断工具</em></sub>
</div>

---

## 📌 全平台与 Linux 各大发行版支持矩阵

| 平台 / 发行版 | 状态 | 软件包格式 | 功能与适配说明 |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **已基本完成** | 安装包 (`.exe`) 与 绿色便携包 (`.zip`) | 完整桌面侧边栏、全功能系统托盘（实时网速、分流模式切换、节点测速）、TUN 虚拟网卡模式、自动更新。 |
| 🐧 **Linux 通用免安装** | ✅ **已就绪** | 通用独立镜像 (`.AppImage`) 与 绿色便携包 (`.tar.gz`) | 单文件免安装，解压即用，完美兼容所有主流与轻量 Linux 发行版。 |
| 🐧 **Debian / Ubuntu / Mint / Deepin / UOS** | ✅ **已就绪** | Debian 安装包 (`.deb`) | 原生包管理器支持，自动注册桌面启动菜单、高清图标与系统服务。 |
| 🐧 **Fedora / RHEL / CentOS / openSUSE** | ✅ **已就绪** | RedHat 安装包 (`.rpm`) | 标准 RPM 格式封装，自动配置运行时依赖与桌面集成。 |
| 🐧 **Arch Linux / Manjaro / EndeavourOS** | ✅ **已就绪** | Pacman 二进制包 (`.pkg.tar.zst`) 与 `PKGBUILD` | 支持 pacman 一键安装与 AUR 脚本直接构建。 |
| 📱 **Android** | ✅ **已就绪** | 通用 APK 与 分架构包 (`arm64-v8a`, `v7a`, `x86_64`) | 系统级 VpnService 驱动、固定 Release 签名（支持无缝覆盖升级）、紧凑移动端 UI、后台保活。 |
| 🍎 **macOS** | 🚧 **开发中** | DMG 安装镜像 | NetworkExtension 架构与桌面端协议适配中。 |
| 🍏 **iOS** | 🚧 **开发中** | IPA | NetworkExtension 架构适配中。 |

---

## ✨ 核心特性

- 🎨 **现代化精致 UI**：
  - 遵循 18px 圆角微卡片体系与天青蓝品牌设计语言，简约而不失高级感；
  - 原生支持浅色（Light）与深空深色（Dark）双主题无缝切换；
  - 响应式自适应布局（小屏紧凑移动模式与大屏桌面侧边栏模式联动）。
- ⚡ **高性能 Mihomo 核心集成**：
  - 全面支持 Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard, Direct 等丰富协议；
  - 超低内存占用与多核高吞吐转发。
- 🔀 **全功能系统托盘右键菜单**：
  - 托盘图标状态与实时上下行网速动态展示；
  - 一键切换系统代理与 TUN 虚拟网卡模式；
  - 快速切换出站模式（规则分流 Rule / 全局代理 Global / 直接连接 Direct）；
  - 订阅一键更新与节点快速切换（带国旗标识与延迟展示）；
  - 快捷实用工具（复制终端代理命令、一键全节点延迟测速、查看核心日志等）。
- 📊 **可视化流量与连接监控**：
  - 仪表盘实时流量动效与多时间跨度（1m/5m/15m/30m/60m）平滑贝塞尔流量折线图；
  - 内置 IP 与 ISP 信息卡片，支持一键实时查询与轻触复制；
  - 订阅套餐流量进度条与到期时间倒计时；
  - 快捷实用工具集：路由规则、内核日志、网络检测、节点测速、运行时配置。
- 🚀 **智能多通道自动更新**：
  - 支持 `stable`（正式稳定通道）与 `beta`（测试预览通道）自由切换；
  - 后台静默下载安装包、SHA-256 完整性校验与安全原地覆盖升级。
- 🌍 **全语言国际化支持 (9 种语言)**：
  - 简体中文、English、繁體中文、日本語、한국어、Русский、Español、العربية、فارسی 全语言 100% 覆盖。

---

## 🛠️ 本地构建与开发

### 环境要求
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- 对应目标平台构建工具链（Windows 需 Visual Studio 2022 C++ 工具，Linux 需 GTK3/Clang/CMake，Android 需 Android SDK）

### 快速开始

```bash
# 1. 克隆代码仓库
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. 安装依赖并生成国际化代码
flutter pub get
dart run slang

# 3. 下载全平台 Mihomo 内核
dart run tool/download_all_cores.dart

# 4. 运行调试
flutter run
```

### 编译各平台 Release 版本

```bash
# Windows Release (生成 x64 安装程序与便携包)
flutter build windows --release

# Linux Release (一键打包 Deb, RPM, AppImage, Arch 与 Tarball)
flutter build linux --release
bash tool/package_linux.sh v1.1.5

# Android Release (生成 APK 安装包)
flutter build apk --release
```

---

## 🚀 持续集成与自动化发布 (CI/CD)

本项目配置了完整的 GitHub Actions 自动化工作流（`.github/workflows/release.yml`）：

- **Windows x64 / ARM64**：Inno Setup 安装包 (`.exe`) + 绿色便携包 (`.zip`)
- **Linux 全发行版支持**：Debian (`.deb`) + RedHat (`.rpm`) + AppImage (`.AppImage`) + Arch (`.pkg.tar.zst`) + 绿色包 (`.tar.gz`)
- **Android**：分架构 APK (`arm64-v8a`, `armeabi-v7a`, `x86_64`) + 通用版 APK
- **完整性验证**：自动生成包含所有产物的 `SHA256SUMS.txt` 校验和。

---

## 🙏 致谢与鸣谢

- 🌟 **特别鸣谢 [GooRingX (vowe)](https://github.com/GooRingX)** 的杰出开源贡献、设计思路与灵感指导！
- 🚀 **特别感谢 [Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** 团队提供的高性能、全协议通用代理核心。
- 💙 **感谢 [Flutter](https://flutter.dev/)** 团队与社区提供的跨平台 UI 框架支持。

---

## 💖 赞助与捐赠

如果 Wmimo 帮助到了你，欢迎请作者喝杯咖啡：

- **币种 (Currency)**: `USDT`
- **网络 (Network)**: `APTOS`
- **收款地址 (Address)**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 开源许可证

本项目基于 **GPL-3.0** 开源许可证分发与使用。详细条款请参阅 [LICENSE](LICENSE) 文件。
""";

  // 3. Traditional Chinese (README.zh-TW.md)
  final zhTwContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>現代化跨平台 Clash / Mihomo 代理客戶端</h3>
  <p>基於 Flutter 與 Mihomo 核心打造，提供極速、優雅、強大的全協議網路代理體驗。</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="Wmimo 介面預覽" width="380" />
  <br/>
  <sub><em>✨ 18px 微卡片設計美學、即時平滑流量監控與豐富網路診斷工具</em></sub>
</div>

---

## 📌 全平台與 Linux 各大發行版支援矩陣

| 平台 / 發行版 | 狀態 | 軟體包格式 | 功能與適配說明 |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **已基本完成** | 安裝包 (`.exe`) 與 綠色便攜包 (`.zip`) | 完整桌面側邊欄、全功能系統工具列（即時網速、分流模式切換、節點測速）、TUN 虛擬網卡模式、自動更新。 |
| 🐧 **Linux 通用免安裝** | ✅ **已就緒** | 通用獨立鏡像 (`.AppImage`) 與 便攜壓縮包 (`.tar.gz`) | 單檔案免安裝，解壓即用，完美相容所有主流 Linux 發行版。 |
| 🐧 **Debian / Ubuntu / Mint / Deepin / UOS** | ✅ **已就緒** | Debian 安裝包 (`.deb`) | 原生包管理器支援，自動註冊桌面啟動選單與圖示。 |
| 🐧 **Fedora / RHEL / CentOS / openSUSE** | ✅ **已就緒** | RedHat 安裝包 (`.rpm`) | 標準 RPM 格式封裝，自動配置依賴與桌面整合。 |
| 🐧 **Arch Linux / Manjaro** | ✅ **已就緒** | Pacman 二進位包 (`.pkg.tar.zst`) 與 `PKGBUILD` | 支援 pacman 一鍵安裝與 AUR 腳本直接建置。 |
| 📱 **Android** | ✅ **已就緒** | 通用 APK 與 分架構包 (`arm64-v8a`, `v7a`, `x86_64`) | 系統級 VpnService 驅動、固定 Release 簽名（支援無縫覆蓋升級）、緊湊行動端 UI、背景保活。 |
| 🍎 **macOS** | 🚧 **開發中** | DMG 安裝映像 | NetworkExtension 架構與桌面端協議適配中。 |
| 🍏 **iOS** | 🚧 **開發中** | IPA | NetworkExtension 架構適配中。 |

---

## 💖 贊助與支持

- **幣種 (Currency)**: `USDT`
- **網路 (Network)**: `APTOS`
- **收款地址 (Address)**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 開源授權

本專案基於 **GPL-3.0** 授權條款分發。詳見 [LICENSE](LICENSE) 文件。
""";

  // 4. Japanese (README.ja.md)
  final jaContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>モダンなクロスプラットフォーム Clash / Mihomo プロキシ GUI クライアント</h3>
  <p>Flutter と Mihomo コアをベースに構築され、高速でエレガント、強力な全プロトコルプロキシ体験を提供します。</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="Wmimo プレビュー" width="380" />
  <br/>
  <sub><em>✨ 洗練された 18px マイクロカード UI、リアルタイムトラフィック監視、豊富なネットワーク診断ツール</em></sub>
</div>

---

## 📌 プラットフォームのサポート状況

| プラットフォーム | ステータス | パッケージ形式 | 特徴 |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **本番利用可能** | インストーラー (`.exe`) / ポータブル (`.zip`) | デスクトップサイドバー、トレイメニュー、リアルタイムトラフィックチャート、TUNモード、自動更新。 |
| 🐧 **Linux** | ✅ **利用可能** | AppImage (`.AppImage`) / Debian (`.deb`) / RPM (`.rpm`) / ポータブル (`.tar.gz`) | ネイティブ GTK3 UI、システムトレイ対応、Linux版 Mihomo コア内蔵。 |
| 📱 **Android** | ✅ **利用可能** | ユニバーサル APK / 各 ABI 分割 APK | VpnService ドライバー統合、固定 Release 署名、モバイル最適化UI、バックグラウンド常駐。 |
| 🍎 **macOS** | 🚧 **開発中** | DMG インストーラー | NetworkExtension フレームワーク適応中。 |
| 🍏 **iOS** | 🚧 **開発中** | IPA | NetworkExtension フレームワーク適応中。 |

---

## ✨ 主な機能

- 🎨 **洗練されたモダン UI**: ライト/ダークモード、レスポンシブ適応型レイアウト（コンパクトモバイル＆デスクトップサイドバー）。
- ⚡ **高性能 Mihomo コア**: Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard などの全プロトコルを完全サポート。
- 🔀 **フル機能システムトレイ**: リアルタイム送受信速度表示、プロキシモード切り替え、ワンクリック遅延テスト、購読更新。
- 📊 **リアルタイム診断 & 監視**: ベジェ曲線トラフィックチャート、ワンクリック IP/ISP 情報取得、折りたたみ可能なプロキシグループ。
- 🚀 **マルチチャンネル自動更新**: `stable`（安定版）と `beta`（プレビュー版）の切り替えに対応。
- 🌍 **9言語の完全多言語対応**: 日本語、英語、簡体字中国語、繁体字中国語、韓国語、ロシア語、スペイン語、アラビア語、ペルシア語。

---

## 💖 寄付・サポート

- **通貨 (Token)**: `USDT`
- **ネットワーク (Network)**: `APTOS`
- **受取アドレス (Address)**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 ライセンス

本プロジェクトは **GPL-3.0** ライセンスの下で公開されています。
""";

  // 5. Korean (README.ko.md)
  final koContent = """# Wmimo

$langBar

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
""";

  // 6. Russian (README.ru.md)
  final ruContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>Современный кроссплатформенный GUI-клиент прокси Clash / Mihomo</h3>
  <p>Создан на Flutter с ядром Mihomo, обеспечивая сверхбыстрый, элегантный и мощный прокси-сервис.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="Wmimo Интерфейс" width="380" />
  <br/>
  <sub><em>✨ Эстетика микро-карточек 18px, мониторинг трафика в реальном времени и диагностика сети</em></sub>
</div>

---

## 📌 Поддержка платформ и дистрибутивов Linux

| Платформа | Статус | Формат пакетов | Описание |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **Готово** | Установщик (`.exe`) и Portable (`.zip`) | Боковая панель, меню в трее, график трафика, режим TUN, автообновление. |
| 🐧 **Linux** | ✅ **Готово** | AppImage (`.AppImage`), Debian (`.deb`), RPM (`.rpm`), Portable (`.tar.gz`) | Нативный интерфейс GTK3, интеграция с системным треем, встроенное ядро Mihomo. |
| 📱 **Android** | ✅ **Готово** | Universal APK и Split ABIs | Интеграция VpnService, постоянная подпись Release, адаптивный интерфейс. |
| 🍎 **macOS** | 🚧 **В разработке** | DMG установщик | Адаптация NetworkExtension в процессе. |
| 🍏 **iOS** | 🚧 **В разработке** | IPA | Интеграция NetworkExtension. |

---

## 💖 Поддержка и донаты

- **Валюта (Token)**: `USDT`
- **Сеть (Network)**: `APTOS`
- **Адрес (Address)**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 Лицензия

Проект распространяется под лицензией **GPL-3.0**. См. файл [LICENSE](LICENSE).
""";

  // 7. Spanish (README.es.md)
  final esContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>Cliente GUI de proxy moderno y multiplataforma para Clash / Mihomo</h3>
  <p>Desarrollado con Flutter y el núcleo Mihomo, ofreciendo una experiencia de proxy ultrarrápida, elegante y potente.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="Wmimo Vista Previa" width="380" />
  <br/>
  <sub><em>✨ Diseño moderno de micro-tarjetas de 18px, monitoreo de tráfico en tiempo real y herramientas de diagnóstico</em></sub>
</div>

---

## 📌 Matriz de soporte de plataformas y Linux

| Plataforma | Estado | Formatos soportados | Descripción |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **Listo para producción** | Instalador (`.exe`) y Portable (`.zip`) | Barra lateral, menú de bandeja del sistema, gráfico de velocidad en tiempo real, modo TUN, autoactualización. |
| 🐧 **Linux** | ✅ **Listo** | AppImage (`.AppImage`), Debian (`.deb`), RPM (`.rpm`), Portable (`.tar.gz`) | Interfaz GTK3 nativa, soporte de bandeja del sistema, núcleo Mihomo integrado. |
| 📱 **Android** | ✅ **Listo** | APK Universal y APKs por ABI | Integración VpnService, firma Release permanente, interfaz móvil compacta. |
| 🍎 **macOS** | 🚧 **En desarrollo** | Instalador DMG | Adaptación de NetworkExtension en progreso. |
| 🍏 **iOS** | 🚧 **En desarrollo** | IPA | Integración del framework NetworkExtension. |

---

## 💖 Donaciones y patrocinio

- **Moneda (Token)**: `USDT`
- **Red (Network)**: `APTOS`
- **Dirección (Address)**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 Licencia

Este proyecto está bajo la licencia **GPL-3.0**. Consulte el archivo [LICENSE](LICENSE).
""";

  // 8. Arabic (README.ar.md)
  final arContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>عميل بروكسي حديث متعدد المنصات لـ Clash / Mihomo بواجهة رسومية</h3>
  <p>تم بناؤه باستخدام Flutter ونواة Mihomo لتقديم تجربة وكيل سريعة وأنيقة وقوية.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="معاينة Wmimo" width="380" />
  <br/>
  <sub><em>✨ واجهة عصرية ببطاقات مصغرة 18px، مراقبة حركة المرور في الوقت الفعلي وأدوات تشخيص الشبكة</em></sub>
</div>

---

## 📌 دعم المنصات وتوزيعات Linux

| المنصة | الحالة | التنسيقات المدعومة | الوصف |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **جاهز** | مثبت (`.exe`) ومحمول (`.zip`) | شريط جانبي، قائمة شريط المهام، رسم بياني للسرعة، وضع TUN، تحديث تلقائي. |
| 🐧 **Linux** | ✅ **جاهز** | AppImage (`.AppImage`), Debian (`.deb`), RPM (`.rpm`), Portable (`.tar.gz`) | واجهة GTK3 أصلية، تكامل شريط المهام، نواة Mihomo مدمجة. |
| 📱 **Android** | ✅ **جاهز** | APK شامل و APK مقسم حسب المعمارية | تكامل VpnService، توقيع Release دائم، واجهة هاتف مضغوطة. |
| 🍎 **macOS** | 🚧 **قيد التطوير** | مثبت DMG | جاري تكييف بنية NetworkExtension. |
| 🍏 **iOS** | 🚧 **قيد التطوير** | IPA | جاري دمج إطار عمل NetworkExtension. |

---

## 💖 التبرع والدعم

- **العملة (Token)**: `USDT`
- **الشبكة (Network)**: `APTOS`
- **العنوان (Address)**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 الترخيص

هذا المشروع مرخص بموجب رخصة **GPL-3.0**. راجع ملف [LICENSE](LICENSE).
""";

  // 9. Persian (README.fa.md)
  final faContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>کلاینت گرافیکی مدرن و چندسکویی پروکسی Clash / Mihomo</h3>
  <p>ساخته شده با Flutter و هسته Mihomo، ارائه دهنده تجربه پروکسی فوق‌العاده سریع، زیبا و قدرتمند.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="پیش‌نمایش Wmimo" width="380" />
  <br/>
  <sub><em>✨ طراحی کارت‌های میکرو ۱۸ پیکسلی، مانیتورینگ بلادرنگ ترافیک و ابزارهای تشخیص شبکه</em></sub>
</div>

---

## 📌 وضعیت پشتیبانی از پلتفرم‌ها و لینوکس

| پلتفرم | وضعیت | فرمت بسته‌ها | توضیحات |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **آماده استفاده** | فایل نصبی (`.exe`) و قابل حمل (`.zip`) | نوار کناری دسکتاپ، منوی تسک‌بار، نمودار بلادرنگ ترافیک، حالت TUN، آپدیت خودکار. |
| 🐧 **Linux** | ✅ **آماده** | AppImage (`.AppImage`), Debian (`.deb`), RPM (`.rpm`), Portable (`.tar.gz`) | رابط GTK3 بومی، پشتیبانی از سینی سیستم، هسته داخلی Mihomo. |
| 📱 **Android** | ✅ **آماده** | APK عمومی و تفکیک شده بر اساس معماری | یکپارچه‌سازی درایور VpnService، امضای دائمی Release، رابط فشرده موبایل. |
| 🍎 **macOS** | 🚧 **در حال توسعه** | فایل نصبی DMG | سازگاری با چارچوب NetworkExtension. |
| 🍏 **iOS** | 🚧 **در حال توسعه** | IPA | سازگاری با چارچوب NetworkExtension. |

---

## 💖 حمایت مالی و دونیت

- **ارز (Token)**: `USDT`
- **شبکه (Network)**: `APTOS`
- **آدرس (Address)**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 مجوز

این پروژه تحت مجوز **GPL-3.0** منتشر شده است. برای اطلاعات بیشتر به فایل [LICENSE](LICENSE) مراجعه کنید.
""";

  final files = {
    'README.md': enContent,
    'README.zh-CN.md': zhCnContent,
    'README.zh-TW.md': zhTwContent,
    'README.ja.md': jaContent,
    'README.ko.md': koContent,
    'README.ru.md': ruContent,
    'README.es.md': esContent,
    'README.ar.md': arContent,
    'README.fa.md': faContent,
  };

  for (var entry in files.entries) {
    File(entry.key).writeAsStringSync(entry.value, flush: true);
    print('Updated ${entry.key}');
  }
}

