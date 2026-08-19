# Wmimo

<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" />
  <h3>现代化跨平台代理客户端 (Modern Cross-Platform Proxy Client)</h3>
  <p>基于 Flutter 与 Clash/Mihomo 内核打造，支持 Android、iOS、Windows、macOS、Linux 与 Web 全平台。</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.47.0-blue?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>
</div>

---

## ✨ 核心特性 (Key Features)

- 🚀 **全平台覆盖**：全面支持 Android、iOS、Windows、macOS、Linux 及 Web PWA。
- ⚡ **高性能内核**：深度集成 Clash / Mihomo 核心，提供超低延迟与极速吞吐。
- 🎨 **全新 UI 排版**：
  - 采用 16px 现代圆角微卡片体系与天青蓝品牌视觉规范；
  - 仪表化实时流量与总流量指示面板；
  - 胶囊分段模式切换器（规则 / 全局 / 直连）；
  - 模块化设置卡片体系与快捷网络诊断工具。
- 🛡️ **丰富协议支持**：支持 Shadowsocks, VMess, VLESS, Trojan, Hysteria, TUIC, WireGuard 等丰富协议。
- 🔄 **多机场与订阅管理**：支持一键导入、自动更新、流量统计与订阅到期提醒。
- 📊 **可视化 Web 控制台**：内置 Zashboard 仪表板与在线控制面板。

---

## 🛠️ 构建与开发 (Build & Development)

### 环境要求 (Prerequisites)
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- 对应目标平台编译工具链（Visual Studio / Xcode / Android Studio）

### 快速开始 (Getting Started)

```bash
# 1. 克隆代码仓库
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. 安装依赖
flutter pub get

# 3. 生成所有平台图标 (可选)
dart run tool/generate_all_icons.dart

# 4. 运行调试
flutter run
```

---

## 📦 平台编译指南 (Platform Build Commands)

```bash
# Windows
flutter build windows --release

# Android
flutter build apk --release
flutter build appbundle --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release

# iOS
flutter build ipa --release
```

---

## 📄 开源许可证 (License)

本项目基于开源协议分发。详细信息请参阅相关许可证文档。
