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
</div>

---

## 📌 Platform Support & Status

| Platform | Status | Package Types | Highlights |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **Production Ready** | Setup Installer (`.exe`) & Portable (`.zip`) | Full desktop sidebar, rich system tray menu, real-time speed & traffic chart, TUN mode, system proxy, auto-update. |
| 🐧 **Linux** | ✅ **Ready** | Debian Package (`.deb`) & Portable (`.tar.gz`) | Native GTK3 desktop shell, system tray integration, embedded Mihomo service daemon. |
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

# Linux Release
flutter build linux --release

# Android APK
flutter build apk --release
```

---

## 🚀 Automated CI/CD Releases

Automated multi-platform packaging is handled seamlessly via GitHub Actions (`.github/workflows/release.yml`):

- **Windows x64 / ARM64**: Inno Setup Installer (`.exe`) + Portable Zip (`.zip`)
- **Linux x64**: Debian Package (`.deb`) + Portable Bundle (`.tar.gz`)
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
</div>

---

## 📌 平台支持与开发进度

| 平台 (Platform) | 状态 (Status) | 软件包类型 (Package) | 功能说明 |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **已基本完成** | 安装包 (`.exe`) 与 绿色便携包 (`.zip`) | 完整桌面侧边栏、全功能系统托盘（实时网速、分流模式切换、节点测速）、TUN 虚拟网卡模式、自动更新。 |
| 🐧 **Linux** | ✅ **已就绪** | Debian 安装包 (`.deb`) 与 便携压缩包 (`.tar.gz`) | 原生 GTK3 界面、系统托盘常驻、内嵌 Linux 版 Mihomo 守护核心。 |
| 📱 **Android** | ✅ **已就绪** | 通用 APK 与 分架构包 (`arm64-v8a`, `v7a`, `x86_64`) | 系统级 VpnService 驱动、紧凑移动端 UI、后台保活。 |
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
  - 支持可折叠的代理组卡片，大幅提升节点选择效率。
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

# Linux Release (生成 Linux 桌面二进制)
flutter build linux --release

# Android Release (生成 APK 安装包)
flutter build apk --release
```

---

## 🚀 持续集成与自动化发布 (CI/CD)

本项目配置了完整的 GitHub Actions 自动化工作流（`.github/workflows/release.yml`）：

- **Windows x64 / ARM64**：Inno Setup 安装包 (`.exe`) + 绿色便携包 (`.zip`)
- **Linux x64**：Debian 安装包 (`.deb`) + 绿色便携包 (`.tar.gz`)
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
</div>

---

## 📌 平台支援與開發進度

| 平台 (Platform) | 狀態 (Status) | 軟體包類型 (Package) | 功能說明 |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **已基本完成** | 安裝包 (`.exe`) 與 綠色便攜包 (`.zip`) | 完整桌面側邊欄、全功能系統工具列（即時網速、分流模式切換、節點測速）、TUN 虛擬網卡模式、自動更新。 |
| 🐧 **Linux** | ✅ **已就緒** | Debian 安裝包 (`.deb`) 與 便攜壓縮包 (`.tar.gz`) | 原生 GTK3 介面、系統工具列常駐、內嵌 Linux 版 Mihomo 守護核心。 |
| 📱 **Android** | ✅ **已就緒** | 通用 APK 與 分架構包 (`arm64-v8a`, `v7a`, `x86_64`) | 系統級 VpnService 驅動、緊湊行動端 UI、背景保活。 |
| 🍎 **macOS** | 🚧 **開發中** | DMG 安裝映像 | NetworkExtension 架構與桌面端協議適配中。 |
| 🍏 **iOS** | 🚧 **開發中** | IPA | NetworkExtension 架構適配中。 |

---

## ✨ 核心特性

- 🎨 **現代化精緻 UI**：
  - 遵循 18px 圓角微卡片體系與天青藍品牌設計語言，簡約而不失質感；
  - 原生支援淺色（Light）與深空深色（Dark）雙主題無縫切換；
  - 響應式自適應佈局（小屏緊湊行動模式與大屏桌面側邊欄模式連動）。
- ⚡ **高性能 Mihomo 核心整合**：
  - 全面支援 Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard, Direct 等豐富協議；
  - 超低記憶體佔用與多核高吞吐轉發。
- 🔀 **全功能系統工具列右鍵選單**：
  - 工具列圖示狀態與即時上下行網速動態展示；
  - 一鍵切換系統代理與 TUN 虛擬網卡模式；
  - 快速切換出站模式（規則分流 Rule / 全局代理 Global / 直接連接 Direct）；
  - 訂閱一鍵更新與節點快速切換（帶國旗標識與延遲展示）。
- 📊 **可視化流量與連線監控**：
  - 儀表板即時流量動效與多時間跨度（1m/5m/15m/30m/60m）平滑貝塞爾流量折線圖；
  - 內建 IP 與 ISP 資訊卡片，支援一鍵即時查詢與輕觸複製；
  - 支援可折疊的代理組卡片，大幅提升節點選擇效率。
- 🚀 **智慧多通道自動更新**：
  - 支援 `stable`（正式穩定通道）與 `beta`（測試預覽通道）自由切換；
  - 背景靜默下載安裝包、SHA-256 完整性校驗與安全原地覆蓋升級。
- 🌍 **全語言國際化支援 (9 種語言)**：
  - 繁體中文、簡體中文、English、日本語、한국어、Русский、Español、العربية、فارسی 100% 完整支援。

---

## 🛠️ 本地建置與開發

```bash
# 1. 複製程式碼倉庫
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. 安裝依賴並產生國際化程式碼
flutter pub get
dart run slang

# 3. 下載全平台 Mihomo 核心
dart run tool/download_all_cores.dart

# 4. 執行偵錯
flutter run
```

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
</div>

---

## 📌 プラットフォームのサポート状況

| プラットフォーム | ステータス | パッケージ形式 | 特徴 |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **本番利用可能** | インストーラー (`.exe`) / ポータブル (`.zip`) | デスクトップサイドバー、トレイメニュー、リアルタイムトラフィックチャート、TUNモード、自動更新。 |
| 🐧 **Linux** | ✅ **利用可能** | Debian (`.deb`) / ポータブル (`.tar.gz`) | ネイティブ GTK3 UI、システムトレイ対応、Linux版 Mihomo コア内蔵。 |
| 📱 **Android** | ✅ **利用可能** | ユニバーサル APK / 各 ABI 分割 APK | VpnService ドライバー統合、モバイル最適化UI、バックグラウンド常駐。 |
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
</div>

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
""";

  // 6. Russian (README.ru.md)
  final ruContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>Современный кроссплатформенный GUI-клиент Clash / Mihomo</h3>
  <p>Создан на базе Flutter и ядра Mihomo, обеспечивая сверхбыструю, элегантную и мощную работу с прокси.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>
</div>

---

## 📌 Поддержка платформ

| Платформа | Статус | Форматы пакетов | Описание |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **Готово** | Установщик (`.exe`) и Портативная версия (`.zip`) | Боковая панель, трей с мониторингом скорости, TUN-режим, автообновление. |
| 🐧 **Linux** | ✅ **Готово** | Пакет Debian (`.deb`) и Архив (`.tar.gz`) | Нативный интерфейс GTK3, интеграция с треем, встроенное ядро Mihomo. |
| 📱 **Android** | ✅ **Готово** | Универсальный APK и раздельные ABI | Драйвер VpnService, оптимизированный интерфейс. |
| 🍎 **macOS** | 🚧 **В разработке** | DMG | Адаптация NetworkExtension. |
| 🍏 **iOS** | 🚧 **В разработке** | IPA | Адаптация NetworkExtension. |

---

## ✨ Основные возможности

- 🎨 **Современный интерфейс**: Светлая и темная темы, адаптивный дизайн (мобильный и десктопный интерфейс).
- ⚡ **Ядро Mihomo**: Поддержка Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard.
- 🔀 **Системный трей**: Скорость сети в реальном времени, переключение режимов (Rule/Global/Direct), тест задержки.
- 📊 **Мониторинг трафика**: Плавный график трафика, карточка IP/ISP в реальном времени, сворачиваемые группы прокси.
- 🚀 **Автообновление**: Каналы `stable` и `beta` с фоновой загрузкой и проверкой SHA-256.
- 🌍 **9 языков**: Русский, Английский, Китайский, Японский, Корейский, Испанский, Арабский, Персидский.

---

## 💖 Поддержать проект

- **Валюта**: `USDT`
- **Сеть**: `APTOS`
- **Адрес кошелька**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 Лицензия

Проект распространяется под лицензией **GPL-3.0**.
""";

  // 7. Spanish (README.es.md)
  final esContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>Cliente GUI de Proxy Clash / Mihomo Multiplataforma y Moderno</h3>
  <p>Construido con Flutter y el núcleo Mihomo, ofreciendo una experiencia de proxy rápida, elegante y potente.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>
</div>

---

## 📌 Estado de Plataformas

| Plataforma | Estado | Paquetes | Descripción |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **Listo** | Instalador (`.exe`) y Portable (`.zip`) | Barra lateral de escritorio, menú de bandeja del sistema, modo TUN, autoactualización. |
| 🐧 **Linux** | ✅ **Listo** | Paquete Debian (`.deb`) y Portable (`.tar.gz`) | Interfaz nativa GTK3, bandeja del sistema, daemon de núcleo Mihomo integrado. |
| 📱 **Android** | ✅ **Listo** | APK universal y por arquitecturas | Integración con VpnService, interfaz móvil optimizada. |
| 🍎 **macOS** | 🚧 **En desarrollo** | DMG | Integración con NetworkExtension en progreso. |
| 🍏 **iOS** | 🚧 **En desarrollo** | IPA | Integración con NetworkExtension en progreso. |

---

## ✨ Características Principales

- 🎨 **UI Moderna y Elegante**: Modos Claro y Oscuro, diseño adaptable (móvil y escritorio).
- ⚡ **Núcleo Mihomo**: Soporte completo para Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard.
- 🔀 **Bandeja del Sistema**: Velocidad en tiempo real, cambio de modos de proxy, prueba de latencia.
- 📊 **Monitoreo de Tráfico**: Gráficos Bézier de tráfico, tarjeta de información IP/ISP, grupos de proxies colapsables.
- 🚀 **Autoactualización Inteligente**: Canales `stable` y `beta` con verificación SHA-256.
- 🌍 **Soporte de 9 Idiomas**: Español, Inglés, Chino, Japonés, Coreano, Ruso, Árabe, Persa.

---

## 💖 Donaciones y Soporte

- **Moneda**: `USDT`
- **Red**: `APTOS`
- **Dirección**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 Licencia

Distribuido bajo la licencia **GPL-3.0**.
""";

  // 8. Arabic (README.ar.md)
  final arContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>عميل بروكسي حديث متعدد المنصات لـ Clash / Mihomo</h3>
  <p>تم بناؤه باستخدام Flutter ونواة Mihomo لتوفير تجربة بروكسي سريعة وأنيقة وقوية لجميع البروتوكولات.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>
</div>

---

## 📌 دعم المنصات

| المنصة | الحالة | نوع الحزمة | المميزات |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **جاهز** | مثبت (`.exe`) ومحمول (`.zip`) | شريط جانبي لسطح المكتب، قائمة شريط المهام، وضع TUN، تحديث تلقائي. |
| 🐧 **Linux** | ✅ **جاهز** | حزمة دبيان (`.deb`) ومحمول (`.tar.gz`) | واجهة GTK3 أصلية، تكامل مع شريط النظام، نواة Mihomo مدمجة. |
| 📱 **Android** | ✅ **جاهز** | APK شامل وحزم مخصصة لكل معمارية | محرك VpnService مدمج، واجهة هاتف مضغوطة. |
| 🍎 **macOS** | 🚧 **قيد التطوير** | مثبت DMG | جاري تكييف NetworkExtension. |
| 🍏 **iOS** | 🚧 **قيد التطوير** | IPA | جاري تكييف NetworkExtension. |

---

## ✨ المميزات الرئيسية

- 🎨 **واجهة مستخدم عصرية وأنيقة**: دعم كامل للوضع الداكن والفاتح، تصميم متكيف وسلس.
- ⚡ **نواة Mihomo عالية الأداء**: دعم كامل لجميع البروتوكولات (Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard).
- 🔀 **تكامل كامل مع شريط النظام**: عرض سرعة الرفع والتنزيل، تبديل أوضاع البروكسي بنقرة واحدة، اختبار الاستجابة (Ping).
- 📊 **مراقبة وتحليل حركة البيانات**: مخطط بياني فوري لحركة المرور، بطاقة معلومات IP و مزود الخدمة (ISP).
- 🚀 **تحديث تلقائي ذكي**: دعم قناتي `stable` (المستقرة) و `beta` (التجريبية).
- 🌍 **دعم 9 لغات عالمية**: العربية، الإنجليزية، الصينية، اليابانية، الكورية، الروسية، الإسبانية، الفارسية.

---

## 💖 التبرع والدعم

- **العملة**: `USDT`
- **الشبكة**: `APTOS`
- **العنوان**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 الترخيص

هذا المشروع مرخص بموجب **GPL-3.0**.
""";

  // 9. Persian / Farsi (README.fa.md)
  final faContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>کلاینت مدرن و چندسکویی پروکسی Clash / Mihomo</h3>
  <p>ساخته شده با فلاتر و هسته قدرتمند Mihomo برای ارائه تجربه سریع، زیبا و کامل پروکسی.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>
</div>

---

## 📌 وضعیت پلتفرم‌ها

| پلتفرم | وضعیت | فرمت پکیج | توضیحات |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **آماده استفاده** | فایل نصب (`.exe`) و پرتابل (`.zip`) | سایدبار دسکتاپ، منوی تسک‌بار کامل، حالت TUN، به‌روزرسانی خودکار. |
| 🐧 **Linux** | ✅ **آماده** | پکیج دبیان (`.deb`) و پرتابل (`.tar.gz`) | رابط کاربری بومی GTK3، آیکون سینی سیستم، هسته داخلی Mihomo لینوکس. |
| 📱 **Android** | ✅ **آماده** | APK عمومی و نسخه‌های تفکیک شده معماری | درایور VpnService سیستمی، رابط کاربری متناسب موبایل. |
| 🍎 **macOS** | 🚧 **در حال توسعه** | DMG | در حال پیاده‌سازی NetworkExtension. |
| 🍏 **iOS** | 🚧 **در حال توسعه** | IPA | در حال پیاده‌سازی NetworkExtension. |

---

## ✨ ویژگی‌های کلیدی

- 🎨 **رابط کاربری مدرن**: پشتیبانی از تم‌های روشن و تاریک، طراحی ریسپانسیو.
- ⚡ **هسته پرسرعت Mihomo**: پشتیبانی کامل از پروتکل‌های Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard.
- 🔀 **منوی تسک‌بار پیشرفته**: نمایش زنده سرعت دانلود و آپلود، تغییر سریع حالت‌های پروکسی، تست پینگ.
- 📊 **نظارت بر ترافیک**: نمودار ترافیک، کارت نمایش وضعیت IP و ISP، دسته‌بندی پروکسی‌ها با قابلیت جمع شدن.
- 🚀 **به‌روزرسانی خودکار چندکاناله**: انتخاب بین کانال‌های `stable` و `beta`.
- 🌍 **پشتیبانی از ۹ زبان بین‌المللی**: فارسی، انگلیسی، چینی، ژاپنی، کره‌ای، روسی، اسپانیایی، عربی.

---

## 💖 حمایت و دونیت

- **ارز**: `USDT`
- **شبکه**: `APTOS`
- **آدرس کیف پول**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 مجوز

این پروژه تحت مجوز **GPL-3.0** منتشر شده است.
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
    print('Generated \${entry.key} (\${entry.value.length} bytes)');
  }
}
