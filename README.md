# Wmimo

<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>现代化跨平台代理客户端 (Modern Cross-Platform Proxy Client)</h3>
  <p>基于 Flutter 与 Clash / Mihomo 核心打造，提供极速、优雅、强大的全协议网络代理体验。</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=2563EB&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-blue?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>
</div>

---

## 📌 平台支持与开发进度 (Platform Status)

| 平台 (Platform) | 状态 (Status) | 说明 (Description) |
| :--- | :---: | :--- |
| 🪟 **Windows** | ✅ **已基本完成** | **功能完整，推荐日常主力使用**。包含完整的桌面侧边栏与原生质感 UI、全功能系统托盘菜单（实时上下行网速、代理模式切换、节点快捷切换、一键延迟测速、订阅一键更新等）、实时流量监控折线图、出站规则与连接管理。 |
| 📱 **Android** | 🚧 **开发与适配中** | 基础架构与界面已就绪，正在进行内核封装与 VPN 服务调优。 |
| 🍎 **macOS** | 🚧 **开发中** | 桌面端架构适配中。 |
| 🍏 **iOS** | 🚧 **开发中** | NetworkExtension 架构适配中。 |
| 🐧 **Linux** | 🚧 **开发中** | 桌面端协议与托盘适配中。 |

---

## 🙏 致谢与鸣谢 (Acknowledgements)

本项目在开发与演进过程中，深受开源社区众多优秀项目的启发与支持。在此向以下开发者和开源项目致以诚挚的感谢：

- 🌟 **特别鸣谢 [GooRingX (vowe)](https://github.com/GooRingX)** 的杰出开源贡献、设计思路与灵感指导！
- 🚀 **特别感谢 [Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** 团队提供的高性能、全协议通用代理核心。
- 💙 **感谢 [Flutter](https://flutter.dev/)** 团队与社区提供的跨平台 UI 框架支持。
- 🌐 **感谢所有为 Clash 开源生态做出贡献的开发者们！**

---

## ✨ 核心特性 (Key Features)

- 🎨 **现代化精致 UI**：
  - 遵循 16px 圆角微卡片体系与天青蓝品牌设计语言；
  - 原生支持浅色（Light）与深空深色（Dark）双主题无缝切换；
  - 现代化紧凑底部导航栏与桌面侧边栏联动。
- ⚡ **高性能 Mihomo 核心集成**：
  - 全面支持 Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard, Direct 等丰富协议；
  - 超低内存占用与高吞吐转发。
- 🔀 **全功能系统托盘右键菜单**：
  - 托盘图标状态与实时上下行网速动态展示；
  - 一键切换系统代理（System Proxy）与 TUN 虚拟网卡模式；
  - 快速切换出站模式（规则分流 Rule / 全局代理 Global / 直接连接 Direct）；
  - 订阅一键更新与节点快速切换（带国旗标识与延迟展示）；
  - 快捷实用工具（复制终端代理命令、一键全节点延迟测速、查看核心日志等）。
- 📈 **可视化流量与连接监控**：
  - 仪表盘实时流量动效与多时间跨度（1m/5m/15m/30m/60m）平滑贝塞尔流量折线图；
  - 活动连接追踪与分流规则明细查看。
- 🌍 **全语言国际化支持 (9 种语言)**：
  - 简体中文 (`zh-CN`)、繁體中文 (`zh-TW`)、English (`en`)、日本語 (`ja`)、한국어 (`ko`)、Русский (`ru`)、Español (`es`)、العربية (`ar`)、فارسی (`fa`)。

---

## 🛠️ 本地构建与开发 (Build & Development)

### 环境要求 (Prerequisites)
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- 对应目标平台的构建工具链（如 Visual Studio 2022 C++ 构建工具、Android SDK / NDK 等）

### 快速开始 (Getting Started)

```bash
# 1. 克隆代码仓库
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. 安装依赖并生成国际化代码
flutter pub get
dart run slang

# 3. 下载对应平台内核 (Windows 示例)
pwsh tool/download_core.ps1

# 4. 运行调试
flutter run
```

### 编译构建 (Platform Build Commands)

```bash
# Windows Release (生成绿色可执行程序)
flutter build windows --release

# Android Release (生成 APK 安装包)
flutter build apk --release
```

---

## 🚀 持续集成与自动化发布 (CI/CD Releases)

本项目配置了完整的 GitHub Actions 自动化工作流（`.github/workflows/release.yml`）：

- **自动触发**：当向仓库推送版本标签（例如 `git tag v1.0.30 && git push origin v1.0.30`）时，自动触发跨平台打包流水线。
- **构建产物**：
  - 🪟 **Windows x64 安装版**：`Wmimo-Windows-x64-Setup-v*.exe`（支持多语言选择、安装语言自动同步、开机启动与快捷方式设置）
  - 🪟 **Windows x64 绿色版**：`Wmimo-Windows-x64-v*.zip`（解压即用的便携式压缩包）
  - 🪟 **Windows ARM64 安装版**：`Wmimo-Windows-arm64-Setup-v*.exe`（面向 Snapdragon X / Surface Pro 等 ARM64 设备）
  - 🪟 **Windows ARM64 绿色版**：`Wmimo-Windows-arm64-v*.zip`（ARM64 便携版）
  - 📱 **Android 安装包**：`Wmimo-Android-v*.apk`（含通用包及 `arm64-v8a`、`armeabi-v7a`、`x86_64` 各 ABI 分包，内置系统级 VPN 驱动）
- **自动发布**：构建完成后自动生成 GitHub Release 并上传安装包文件。

---

## 📄 开源许可证 (License)

本项目基于 **GPL-3.0** 开源许可证分发与使用。详细条款请参阅 [LICENSE](LICENSE) 文件。
