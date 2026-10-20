import 'dart:io';

void main() {
  final langBar = """
<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---
""";

  // ==========================================
  // 1. English (README.md)
  // ==========================================
  final enContent = """# Wmimo

$langBar

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
""";

  // ==========================================
  // 2. Simplified Chinese (README.zh-CN.md)
  // ==========================================
  final zhCnContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>新一代现代化跨平台 Clash / Mihomo 桌面与移动端代理客户端</strong></p>
  <p align="center">基于 Flutter 与高性能 Mihomo (Meta) 核心倾力打造。兼具极速转发性能、现代艺术级设计美学与全协议代理能力。</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>下载安装</b></a> •
    <a href="#核心特性"><b>核心特性</b></a> •
    <a href="#快速上手"><b>快速上手</b></a> •
    <a href="#本地编译与开发"><b>本地编译</b></a> •
    <a href="https://t.me/wmimoapp"><b>官方社区</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo 浅色主题" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo 深色主题" width="370" />
  </p>
  <sub><em>18px 极简微卡片设计体系 · 实时平滑流量贝塞尔曲线监控 · TUN & 系统代理双模式（浅色 & 深色原生双主题）</em></sub>
</div>

---

## 核心特性

- **艺术级微卡片界面与原生双主题**：
  - 遵循 18px 精致圆角微卡片布局体系与天青蓝品牌视觉，高级通透，现代干练；
  - 完美原生支持极简明亮（Light）与深空黑（Dark）双主题无缝平滑切换；
  - 响应式自适应设计：大屏桌面自适应宽屏侧边栏，小屏移动端紧凑人体工学布局。
- **高性能 Mihomo (Meta) 核心深度驱动**：
  - 全协议矩阵覆盖：**Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH, Direct** 等；
  - 独立后台 Isolate 并发清洗节点与分流规则，启动过程 **零界面冻结（Zero UI Freeze）**，内存占用极低。
- **智能分流路由与系统级双代理模式**：
  - 出站模式秒级切换：**规则分流 (Rule)** / **全局代理 (Global)** / **直接连接 (Direct)**；
  - 双引擎灵活调度：**TUN 虚拟网卡模式**（透明接管操作系统全量流量）与 **系统代理模式**（免提权快捷冲浪）；
  - 精细化应用分流：Android 分应用代理（黑白名单）与 Windows UWP Loopback 免除工具。
- **深度实时流量监控与智能诊断套件**：
  - 仪表盘实时平滑贝塞尔流量曲线图，支持 1m / 5m / 15m / 30m / 60m 多时间跨度自如缩放；
  - 实时出口 IP、地理位置与 ISP 归属信息卡片，一键测速、轻触复制与隐私脱敏保护；
  - 订阅套餐用量实时进度条与到期时间精准倒计时；
  - 全套排障套件：路由规则树查看、内核实时控制台日志、全节点并发 Ping 测速与网络连通性诊断。
- **深度操作系统级原生融合**：
  - **Windows**：原生系统托盘右键菜单自动同步跟随 App 深浅色主题，托盘图标动态显示实时上下行网速，启用现代 `comctl32 v6` 视觉样式；
  - **Android**：前台服务通知栏常驻（带当前状态、快捷断开按钮），支持下拉状态栏 Quick Settings 快速开关磁贴，应用内多语言实时联动；
  - **macOS**：原生状态栏自适应 Template 图标支持与系统代理无缝接管。
- **智能多通道无缝自动更新**：
  - 支持 `stable`（正式稳定通道）与 `beta`（测试预览通道）自由切换；
  - 后台静默高速下载、SHA-256 哈希完整性校验与安全原地覆盖升级。
- **真正 100% 完整 9 国语言覆盖**：
  - 简体中文、繁體中文、English、日本語、한국어、Русский、Español、العربية、فارسی 全语言 705 个词条全量对齐，无任何缺失。

---

## 快速上手

1. **下载安装**：前往 [Releases 页面](https://github.com/aimy1/Wmimo/releases) 下载适用于您系统的安装包；
2. **导入订阅**：进入「订阅配置」界面，粘贴您的 Clash / Mihomo 订阅链接或导入本地 YAML 规则文件；
3. **开启连接**：在「首页」轻触顶部开关即可开启代理。
   - *Windows 提示*：如需使用 **TUN 模式**，请右键选择【以管理员身份运行】应用；若日常免特权运行，直接开启 **系统代理模式** 即可畅快联网。

---

## 本地编译与开发

### 环境准备
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- 对应目标平台编译套件（Windows 需 Visual Studio 2022 C++，Linux 需 GTK3/Clang/CMake，Android 需 Android SDK）

### 开发命令速查

```bash
# 1. 克隆代码库
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. 安装依赖并自动生成多语言代码
flutter pub get
dart run slang

# 3. 下载全平台预编译 Mihomo 核心
dart run tool/download_all_cores.dart

# 4. 本地启动调试
flutter run

# 5. 编译正式发布包
flutter build windows --release   # Windows
flutter build apk --release       # Android
flutter build linux --release     # Linux
flutter build macos --release     # macOS
```

---

## Star 增长趋势

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## 致谢

- **[GooRingX (vowe)](https://github.com/GooRingX)**：感谢杰出的开源贡献、设计思路与灵感指导。
- **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**：感谢团队提供的高性能、全协议通用代理核心。
- **[Flutter](https://flutter.dev/)**：感谢团队与开源社区提供的跨平台应用开发框架。

---

## 社区交流与反馈

- **Telegram 频道与交流群**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **联系邮箱**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **问题反馈与需求提案**: [提交 GitHub Issue](https://github.com/aimy1/Wmimo/issues)

---

## 开源许可证

本项目基于 **GPL-3.0** 开源许可证分发与使用。详细条款请参阅 [LICENSE](LICENSE) 文件。
""";

  // ==========================================
  // 3. Traditional Chinese (README.zh-TW.md)
  // ==========================================
  final zhTwContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>新一代現代化跨平台 Clash / Mihomo 桌面與行動端代理客戶端</strong></p>
  <p align="center">基於 Flutter 與高效能 Mihomo (Meta) 核心傾力打造。兼具極速轉發效能、現代藝術級設計美學與全協議代理能力。</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>下載安裝</b></a> •
    <a href="#核心特性"><b>核心特性</b></a> •
    <a href="#快速上手"><b>快速上手</b></a> •
    <a href="#本地編譯與開發"><b>本地編譯</b></a> •
    <a href="https://t.me/wmimoapp"><b>官方社群</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo 淺色主題" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo 深色主題" width="370" />
  </p>
  <sub><em>18px 極簡微卡片設計體系 · 即時平滑流量貝塞爾曲線監控 · TUN & 系統代理雙模式（淺色 & 深色原生雙主題）</em></sub>
</div>

---

## 核心特性

- **藝術級微卡片介面與原生雙主題**：
  - 遵循 18px 精緻圓角微卡片排版體系與天青藍品牌視覺，現代高雅；
  - 原生支援極簡明亮（Light）與深邃暗黑（Dark）雙主題無縫切換；
  - 響應式自適應設計：桌面端寬螢幕側邊欄，行動端單手人體工學佈局。
- **高效能 Mihomo (Meta) 核心驅動**：
  - 全協議支援：**Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH, Direct** 等；
  - 獨立後台 Isolate 平行處理節點與規則流，啟動過程 **零介面凍結（Zero UI Freeze）**，超低記憶體佔用。
- **智慧分流路由與系統級雙代理模式**：
  - 出站模式快速切換：**規則分流 (Rule)** / **全域代理 (Global)** / **直接連線 (Direct)**；
  - 雙引擎彈性調度：**TUN 虛擬網卡模式**（透明接管全系統流量）與 **系統代理模式**（免特權快速連線）；
  - 應用程式分流：Android 依應用程式代理（黑白名單）與 Windows UWP Loopback 免除工具。
- **即時流量監控與智慧診斷套件**：
  - 儀表板即時平滑貝塞爾流量曲線圖，支援 1m / 5m / 15m / 30m / 60m 跨度縮放；
  - 即時出口 IP、地理位置與 ISP 歸屬資訊卡片，一鍵測速與隱私脫敏保護；
  - 訂閱套餐用量即時進度條與到期時間精準倒數；
  - 完整診斷套件：路由規則檢視、核心即時主控台日誌、全節點平行測速與網路連通性診斷。
- **深度作業系統級原生整合**：
  - **Windows**：原生系統匣右鍵選單自動同步跟隨 App 深淺色主題，系統匣圖示動態顯示即時網速，現代 `comctl32 v6` 渲染；
  - **Android**：前景服務通知欄常駐（具即時狀態與中斷按鈕），支援下拉快捷開關磁貼，多語言即時聯動；
  - **macOS**：原生選單列自適應 Template 圖示支援與系統代理自動化。
- **智慧多通道無縫自動更新**：
  - 支援 `stable`（正式穩定通道）與 `beta`（測試預覽通道）自由切換；
  - 後台靜默高速下載、SHA-256 哈希完整性校驗與原地升級。
- **真正 100% 完整 9 國語言支援**：
  - 繁體中文、簡體中文、English、日本語、한국어、Русский、Español、العربية、فارسی 9 種語言 705 個詞條全量對齊。

---

## 快速上手

1. **下載安裝**：至 [Releases 頁面](https://github.com/aimy1/Wmimo/releases) 下載適用於您系統的安裝包；
2. **匯入訂閱**：進入「訂閱配置」介面，貼上您的 Clash / Mihomo 訂閱連結或匯入本地 YAML 設定檔；
3. **開啟連線**：在「首頁」輕觸頂部開關即可開啟代理。
   - *Windows 提示*：如需使用 **TUN 模式**，請按右鍵選擇【以管理員身分執行】應用；若日常免特權執行，直接開啟 **系統代理模式** 即可順暢連線。

---

## 本地編譯與開發

```bash
# 1. 複製程式碼庫
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. 安裝相依套件並產生多語言程式碼
flutter pub get
dart run slang

# 3. 下載全平台 Mihomo 核心
dart run tool/download_all_cores.dart

# 4. 本地啟動除錯
flutter run

# 5. 編譯正式發行套件
flutter build windows --release   # Windows
flutter build apk --release       # Android
flutter build linux --release     # Linux
flutter build macos --release     # macOS
```

---

## Star 成長趨勢

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## 致謝

- **[GooRingX (vowe)](https://github.com/GooRingX)**：感謝傑出的開源貢獻與設計指導。
- **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**：感謝團隊提供的高效能核心。
- **[Flutter](https://flutter.dev/)**：感謝團隊與社群提供的優秀跨平台框架支援。

---

## 社群交流與回饋

- **Telegram 官方頻道**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **聯絡信箱**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **問題回報**: [提交 GitHub Issue](https://github.com/aimy1/Wmimo/issues)

---

## 開源授權

本專案採用 **GPL-3.0** 授權條款開源分發。詳細內容請參閱 [LICENSE](LICENSE) 檔案。
""";

  // ==========================================
  // 4. Japanese (README.ja.md)
  // ==========================================
  final jaContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>次世代クロスプラットフォーム Clash / Mihomo プロキシクライアント</strong></p>
  <p align="center">Flutter と高性能 Mihomo (Meta) コアで構築。圧倒的なスピード、洗練されたモダンUI、そして豊富な全プロトコル対応を実現。</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>ダウンロード</b></a> •
    <a href="#主な機能"><b>主な機能</b></a> •
    <a href="#クイックスタート"><b>クイックスタート</b></a> •
    <a href="https://t.me/wmimoapp"><b>コミュニティ</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo ライトテーマ" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo ダークテーマ" width="370" />
  </p>
  <sub><em>18px マイクロカードデザイン、リアルタイムのベジェ曲線トラフィックモニター、高度なネットワーク診断（ライト＆ダーク両対応）</em></sub>
</div>

---

## 主な機能

- **洗練されたマイクロカードUIとネイティブデュアルテーマ**:
  - 美しい18px角丸マイクロカードレイアウトと洗練されたシアンブルーのアクセントカラー。
  - クリーンなライトテーマと深みのあるダークテーマをシームレスに切り替え。
  - 大画面デスクトップサイドバーとモバイル向けエルゴノミックレイアウトに自動適応。
- **高性能 Mihomo (Meta) コア**:
  - **Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH, Direct** などを完全サポート。
  - ノード解析とソートをバックグラウンド Isolate で非同期処理 — **起動時の画面フリーズゼロ (Zero UI Freeze)**。
- **柔軟なルーティングとデュアルプロキシエンジン**:
  - ワンタップでルーティング切替: **ルール分流 (Rule)** / **グローバル (Global)** / **ダイレクト (Direct)**。
  - **TUN 仮想アダプターモード**（システム全体の透過プロキシ）と **システムプロキシモード**（権限不要の軽快接続）。
  - Android アプリ別プロキシ設定、Windows UWP Loopback 免除ユーティリティ。
- **リアルタイムトラフィック監視と総合ネットワーク診断**:
  - 1分/5分/15分/30分/60分のマルチスパンに対応した滑らかなベジェ曲線トラフィックグラフ。
  - 出口 IP、地域、ISP 情報を瞬時に取得し、プライバシー保護のマスキングとワンタップコピーに対応。
  - サブスクリプション通信量の進捗バーと有効期限カウントダウン。
- **OSネイティブ機能とのシームレスな統合**:
  - **Windows**: アプリのテーマに自動追従するタスクトレイメニュー、トレイアイコンでのリアルタイム速度表示、`comctl32 v6` スタイル。
  - **Android**: フォアグラウンド通知によるワンタップ切断、クイック設定タイル、多言語リアルタイム同期。
  - **macOS**: メニューバーの Template アイコン対応。
- **完全な 9 言語ネイティブ対応**:
  - 簡体字中国語、繁体字中国語、英語、日本語、韓国語、ロシア語、スペイン語、アラビア語、ペルシャ語の 705 キーを完全カバー。

---

## クイックスタート

1. **ダウンロード**: [Releases ページ](https://github.com/aimy1/Wmimo/releases) からお使いのOSに合ったパッケージを入手します。
2. **サブスクリプション登録**: 「サブスクリプション」画面でリンクを貼り付けるか YAML プロファイルを読み込みます。
3. **接続**: 「ホーム」画面の接続トグルをタップするだけで高速プロキシ通信が始まります。
   - *Windows の注意点*: **TUN モード** を使用する場合は右クリックから【管理者として実行】してください。通常利用は **システムプロキシモード** の利用を推奨します。

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## コミュニティとサポート

- **Telegram 公式チャンネル**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **お問い合わせ**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **バグ報告・提案**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## ライセンス

本プロジェクトは **GPL-3.0 ライセンス** のもとで公開されています。詳細は [LICENSE](LICENSE) をご覧ください。
""";

  // ==========================================
  // 5. Korean (README.ko.md)
  // ==========================================
  final koContent = """# Wmimo

$langBar

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
    <img src="docs/preview_light.png" alt="Wmimo 라이트 모드" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo 다크 모드" width="370" />
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
""";

  // ==========================================
  // 6. Russian (README.ru.md)
  // ==========================================
  final ruContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>Современный кроссплатформенный клиент Clash / Mihomo нового поколения</strong></p>
  <p align="center">Создан на базе Flutter и ядра Mihomo. Обеспечивает бескомпромиссную скорость, элегантный дизайн и поддержку всех современных протоколов.</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>Скачать</b></a> •
    <a href="#возможности"><b>Возможности</b></a> •
    <a href="#быстрый-старт"><b>Быстрый старт</b></a> •
    <a href="https://t.me/wmimoapp"><b>Сообщество</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo Светлая тема" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo Темная тема" width="370" />
  </p>
  <sub><em>Эстетика микро-карточек 18px, плавный график трафика Безье и диагностика сети (Светлая и Темная темы)</em></sub>
</div>

---

## Возможности

- **Эстетичный интерфейс и нативная смена тем**:
  - Закругления карточек 18px и фирменный акцентный циан.
  - Плавное и чистое переключение между светлой и глубокой темной темами.
  - Адаптивный интерфейс для больших мониторов и смартфонов.
- **Ядро Mihomo (Meta) с полной поддержкой протоколов**:
  - Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH, Direct.
  - Парсинг узлов в фоновом Isolate — **полное отсутствие зависаний интерфейса (Zero UI Freeze)**.
- **Интеллектуальная маршрутизация и два режима работы**:
  - Быстрое переключение: **По правилам (Rule)** / **Глобальный (Global)** / **Прямой (Direct)**.
  - **Режим TUN-адаптера** (прозрачный системный перехват) и **Системный прокси** (без прав администратора).
  - Раздельное туннелирование приложений на Android и исключение UWP на Windows.
- **Мониторинг трафика и диагностический центр**:
  - Графики трафика Безье в реальном времени (1м / 5м / 15м / 30м / 60м).
  - Карточка проверки внешнего IP, локации и провайдера в один клик.
  - Счетчик расхода тарифного плана и срока действия подписки.
- **Глубокая интеграция с операционными системами**:
  - **Windows**: Нативное меню трея подстраивается под тему приложения, динамическая индикация скорости в трее, стиль `comctl32 v6`.
  - **Android**: Уведомление службы с кнопкой отключения, плитка быстрых настроек, синхронизация языка.
  - **macOS**: Нативная иконка в строке меню Template.
- **100% локализация на 9 языков**:
  - Полное покрытие 705 ключей: Русский, Английский, Китайский (упр/трад), Японский, Корейский, Испанский, Арабский, Персидский.

---

## Быстрый старт

1. **Скачать**: Перейдите в [Релизы](https://github.com/aimy1/Wmimo/releases) и скачайте нужный файл.
2. **Импорт**: В разделе «Подписки» вставьте ссылку на подписку Clash/Mihomo.
3. **Подключение**: Включите тумблер на главном экране.
   - *Совет для Windows*: Для **TUN-режима** запускайте Wmimo от имени администратора; для повседневного использования отлично подходит **Системный прокси**.

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## Сообщество

- **Telegram-канал**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **Email**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **Сообщить об ошибке**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## Лицензия

Проект распространяется под лицензией **GPL-3.0**. Подробности в файле [LICENSE](LICENSE).
""";

  // ==========================================
  // 7. Spanish (README.es.md)
  // ==========================================
  final esContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>Cliente GUI de proxy multiplataforma de nueva generación para Clash / Mihomo</strong></p>
  <p align="center">Construido con Flutter y el núcleo de alto rendimiento Mihomo. Diseñado para ofrecer máxima velocidad, elegancia moderna y compatibilidad total de protocolos.</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>Descargar</b></a> •
    <a href="#características"><b>Características</b></a> •
    <a href="#inicio-rápido"><b>Inicio rápido</b></a> •
    <a href="https://t.me/wmimoapp"><b>Comunidad</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo Tema Claro" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo Tema Oscuro" width="370" />
  </p>
  <sub><em>Diseño refinado de micro-tarjetas de 18px, curvas de tráfico Bézier en tiempo real y diagnósticos completos (Temas Claro y Oscuro)</em></sub>
</div>

---

## Características

- **Interfaz de micro-tarjetas y doble tema nativo**:
  - Sistema de tarjetas con esquinas redondeadas de 18px y acento azul cian.
  - Transición fluida entre el modo claro y el modo oscuro profundo.
  - Diseño adaptable para escritorios de pantalla ancha y dispositivos móviles.
- **Núcleo Mihomo (Meta) de ultra rendimiento**:
  - Compatible con Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard y Direct.
  - Procesamiento asíncrono en Isolate en segundo plano — **cero congelamiento de interfaz (Zero UI Freeze)**.
- **Enrutamiento inteligente y dos motores de proxy**:
  - Conmutación rápida: **Por reglas (Rule)** / **Global** / **Directo (Direct)**.
  - **Modo Adaptador Virtual TUN** y **Modo Proxy del Sistema** sin privilegios elevados.
  - Proxy por aplicación en Android y herramienta UWP Loopback en Windows.
- **Telemetría en tiempo real y suite de diagnóstico**:
  - Gráfico de ondas Bézier con intervalos ajustables (1m / 5m / 15m / 30m / 60m).
  - Tarjeta de información de IP pública, ubicación y proveedor con copia rápida.
  - Barra de progreso de consumo de datos y cuenta regresiva de expiración.
- **Integración profunda con el sistema operativo**:
  - **Windows**: Menú de bandeja nativo adaptable al tema, medidor de velocidad dinámico, estilo moderno `comctl32 v6`.
  - **Android**: Notificación de servicio con desconexión rápida, mosaico de ajustes rápidos y sincronización de idiomas.
  - **macOS**: Icono de barra de menús en modo Template.
- **100% traducido a 9 idiomas**:
  - Cobertura completa en Español, Inglés, Chino (simplificado/tradicional), Japonés, Coreano, Ruso, Árabe y Persa.

---

## Inicio rápido

1. **Descargar**: Vaya a la sección de [Releases](https://github.com/aimy1/Wmimo/releases) y descargue el instalador de su sistema.
2. **Importar**: En «Suscripciones», pegue su enlace de Clash/Mihomo.
3. **Conectar**: Active el interruptor principal en la pantalla de inicio.
   - *Nota para Windows*: Para usar el **Modo TUN**, ejecute la aplicación como administrador; para navegación diaria, use el **Modo Proxy del Sistema**.

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## Comunidad y contacto

- **Canal de Telegram**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **Correo del desarrollador**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **Reportar errores**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## Licencia

Este proyecto está bajo la licencia **GPL-3.0**. Consulte el archivo [LICENSE](LICENSE) para más información.
""";

  // ==========================================
  // 8. Arabic (README.ar.md)
  // ==========================================
  final arContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>عميل بروكسي حديث متعدد المنصات لـ Clash / Mihomo بواجهة رسومية من الجيل التالي</strong></p>
  <p align="center">تم تطويره باستخدام Flutter ونواة Mihomo عالية الأداء لتوفير سرعة فائقة وتصميم عصري ودعم شامل لجميع البروتوكولات.</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>تنزيل الإصدارات</b></a> •
    <a href="#الميزات-الرئيسية"><b>الميزات الرئيسية</b></a> •
    <a href="#البدء-السريع"><b>البدء السريع</b></a> •
    <a href="https://t.me/wmimoapp"><b>المجتمع</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo المظهر الفاتح" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo المظهر الداكن" width="370" />
  </p>
  <sub><em>تصميم عصري ببطاقات مصغرة 18px، مراقبة حركة المرور في الوقت الفعلي وأدوات تشخيص شاملة (المظهر الفاتح والداكن)</em></sub>
</div>

---

## الميزات الرئيسية

- **واجهة بطاقات متطورة ومظهر مزدوج أصيل**:
  - تصميم دقيق بحواف مستديرة 18px مع لمسات زرقاء سماوية أنيقة.
  - دعم أصلي وسلس للمظهرين الفاتح (Light) والداكن (Dark).
  - تخطيط متكيف للشاشات الكبيرة والهواتف المحمولة.
- **نواة Mihomo فائقة السرعة**:
  - دعم جميع البروتوكولات: Shadowsocks وVMess وVLESS وTrojan وHysteria 1/2 وTUIC وWireGuard.
  - معالجة غير متزامنة في الخلفية — **انعدام تام لتجمد الواجهة (Zero UI Freeze)**.
- **توجيه ذكي ومحركا وكيل**:
  - تبديل فوري لأنماط الخروج: **القواعد (Rule)** / **شامل (Global)** / **مباشر (Direct)**.
  - **وضع محول الشبكة الظاهرية TUN** و **وضع وكيل النظام**.
  - وكيل لكل تطبيق على Android وأداة UWP Loopback على Windows.
- **مراقبة حركة البيانات في الوقت الفعلي**:
  - رسم بياني لحركة البيانات في الوقت الفعلي مع خيارات فترات زمنية متعددة.
  - بطاقة الاستعلام الفوري عن عنوان IP والموقع ومزود الخدمة.
  - شريط تقدم استهلاك الباقة والعد التنازلي لانتهاء الصلاحية.
- **تكامل عميق مع أنظمة التشغيل**:
  - **Windows**: قائمة شريط المهام متكيفة مع مظهر التطبيق، وعرض حي لسرعة الشبكة، ودعم `comctl32 v6`.
  - **Android**: إشعار دائم مع زر قطع اتصال سريع، وبلاطة الإعدادات السريعة، وتزامن اللغة فورياً.
  - **macOS**: دعم أيقونة شريط القوائم التكيفية Template.
- **دعم كامل لـ 9 لغات عالمية**:
  - تغطية بنسبة 100% لـ 705 مفتاح ترجمة عبر اللغات المدعومة.

---

## البدء السريع

1. **التنزيل**: حمّل الحزمة المناسبة لنظامك من صفحة [الإصدارات](https://github.com/aimy1/Wmimo/releases).
2. **استيراد الاشتراك**: افتح قسم «الاشتراكات» والصق رابط اشتراك Clash/Mihomo.
3. **الاتصال**: اضغط على زر التبديل في الصفحة الرئيسية لبدء التوجيه.
   - *ملاحظة لنظام Windows*: لاستخدام **وضع TUN**، يرجى تشغيل التطبيق كمسؤول؛ وللاستخدام اليومي يكفي **وضع وكيل النظام**.

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## المجتمع

- **قناة تيليجرام الرسمية**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **البريد الإلكتروني**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **الإبلاغ عن المشكلات**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## الترخيص

هذا المشروع مرخص بموجب **رخصة جنو العمومية v3.0 (GPL-3.0)**. انظر ملف [LICENSE](LICENSE) للمزيد من التفاصيل.
""";

  // ==========================================
  // 9. Persian (README.fa.md)
  // ==========================================
  final faContent = """# Wmimo

$langBar

<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>کلاینت مدرن، سریع و چندسکویی پروکسی Clash / Mihomo با رابط کاربری نسل جدید</strong></p>
  <p align="center">طراحی شده با Flutter و هسته قدرتمند Mihomo. ترکیبی از سرعت بی‌نظیر، زیبایی مدرن و پشتیبانی از کلیه پروتکل‌های پروکسی.</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>دانلود فایل‌های نصبی</b></a> •
    <a href="#ویژگیهای-کلیدی"><b>ویژگی‌های کلیدی</b></a> •
    <a href="#شروع-سریع"><b>شروع سریع</b></a> •
    <a href="https://t.me/wmimoapp"><b>انجمن</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo تم روشن" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo تم تاریک" width="370" />
  </p>
  <sub><em>طراحی کارت‌های میکرو ۱۸ پیکسلی، نمودار روان و لحظه‌ای ترافیک و ابزارهای جامع عیب‌یابی شبکه (تم روشن و تاریک)</em></sub>
</div>

---

## ویژگی‌های کلیدی

- **رابط کاربری هنری با کارت‌های میکرو و دو تم اختصاصی**:
  - گوشه‌های گرد ۱۸ پیکسلی به همراه المان‌های آبی فیروزه‌ای چشم‌نواز.
  - پشتیبانی روان و سریع از دو حالت روشن (Light) و تاریک عمیق (Dark).
  - طراحی واکنش‌گرا متناسب با نمایشگرهای عریض دسکتاپ و صفحات لمسی موبایل.
- **هسته قدرتمند Mihomo (Meta)**:
  - پشتیبانی از تمام پروتکل‌ها: Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard و Direct.
  - پردازش غیرهمزمان در پس‌زمینه — **بدون هیچ‌گونه هنگ یا افت فریم در رابط کاربری (Zero UI Freeze)**.
- **مسیریابی هوشمند و دو حالت پروکسی**:
  - تغییر سریع حالت: **بر اساس قوانین (Rule)** / **سراسری (Global)** / **مستقیم (Direct)**.
  - انعطاف‌پذیری دوگانه: **حالت آداپتور مجازی TUN** و **پروکسی سیستمی (System Proxy)**.
  - تفکیک ترافیک برنامه‌ها در اندروید و ابزار معافیت Loopback در ویندوز.
- **نمودار ترافیک لحظه‌ای و ابزارهای تحلیل شبکه**:
  - نمودار موجی نرم بزیه در بازه‌های مختلف (۱، ۵، ۱۵، ۳۰ و ۶۰ دقیقه).
  - کارت نمایش آی‌پی خروجی، موقعیت مکانی و رساننده اینترنت با کپی آسان.
  - نمایش میزان مصرف ترافیک و روزهای باقی‌مانده از اشتراک.
- **یکپارچگی عمیق با سیستم‌عامل‌ها**:
  - **Windows**: منوی کلیک راست سینی ویندوز هماهنگ با تم برنامه، نمایش لحظه‌ای سرعت دانلود/آپلود در آیکون، سبک مدرن `comctl32 v6`.
  - **Android**: اعلان دائمی با دکمه قطع اتصال سریع، کاشی تنظیمات سریع (Quick Settings) و هماهنگی همزمان زبان.
  - **macOS**: پشتیبانی از آیکون نوار وضعیت Template.
- **پوشش ۱۰۰ درصدی برای ۹ زبان**:
  - پشتیبانی کامل از زبان‌های فارسی، انگلیسی، چینی (ساده/سنتی)، ژاپنی، کره‌ای، روسی، اسپانیایی و عربی.

---

## شروع سریع

1. **دانلود**: بسته متناسب با سیستم‌عامل خود را از بخش [Releases](https://github.com/aimy1/Wmimo/releases) دریافت کنید.
2. **افزودن اشتراک**: در بخش «اشتراک‌ها»، لینک اشتراک Clash/Mihomo را جای‌گذاری کنید.
3. **اتصال**: کلید اتصال در بالای صفحه اصلی را لمس کنید تا ارتباط پروکسی برقرار شود.
   - *نکته ویندوز*: برای **حالت TUN**، برنامه را با کلیک راست و گزینه Run as administrator اجرا نمایید؛ برای استفاده روزمره **حالت پروکسی سیستم** نیز کافی خواهد بود.

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## جامعه و ارتباط

- **کانال رسمی تلگرام**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **ایمیل**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **گزارش باگ و اشکالات**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## مجوز

این پروژه تحت مجوز **GPL-3.0** منتشر شده است. برای جزئیات بیشتر به فایل [LICENSE](LICENSE) مراجعه کنید.
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
