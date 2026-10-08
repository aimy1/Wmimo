# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>现代化跨平台 Clash / Mihomo 代理客户端</h3>
  <p>基于 Flutter 与 Mihomo 核心打造，提供极速、优雅、强大的全协议网络代理体验。</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram" alt="Telegram" /></a>
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
| 🍎 **macOS** | ✅ **已就绪** | 安装镜像 (`.dmg`) 与 绿色便携包 (`.zip`) | 完整桌面适配、菜单栏动态网速与系统托盘、系统代理与 TUN 模式（Touch ID / 管理员授权 SUID 4755）、自动更新。支持 GitHub Actions 自动化预编译与本地脚本一键打包。 |
| 🍏 **iOS** | ✅ **已就绪** | 通用 IPA (`.ipa`) 与 源码 | 包含主应用、`NetworkExtension` VPN 扩展与桌面小组件。提供通用未签名 IPA 分发包，完美支持 **TrollStore（巨魔商店）** 免证书、免 Apple ID、永久安装与系统级 VPN 分流；亦支持 AltStore / Sideloadly / 企业证书自签安装与本地 Xcode 联机调试。 |

> 💡 **平台发布策略说明**：
> 本项目原生支持 **Windows**、**macOS**、**Linux**、**Android** 与 **iOS** 全平台的官方自动化预编译与发布。
> - **macOS**：提供全自动化 GitHub Actions 编译发布与本地一键打包脚本，开箱即用支持 `.dmg` 与 `.zip`。
> - **iOS**：提供包含完整 `PlugIns/wmimoService.appex` 的通用 IPA 安装包。
>   - **TrollStore（巨魔商店，推荐）**：支持 iOS 14.0 ～ 17.0（不含 17.0.1+），直接下载 `.ipa` 导入即可一键永久安装，无需任何 Apple ID、无需 7 天续签，并自动具备系统底层 NetworkExtension VPN 运行权限。
>   - **其他自签工具（AltStore / SideStore / Sideloadly / 企业证书）**：适用于 iOS 17.0.1+ 高版本设备，可导入该 IPA 使用个人 Apple ID 或企业证书自签分发安装。
>   - **本地 Xcode 联机**：支持在 Mac 电脑使用 Xcode 打开 `ios/Runner.xcworkspace` 绑定个人证书直接安装到 iPhone。

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

# macOS Release (生成 Universal DMG 镜像与便携包)
flutter build macos --release
bash tool/package_macos.sh v1.2.1.1503

# Linux Release (一键打包 Deb, RPM, AppImage, Arch 与 Tarball)
flutter build linux --release
bash tool/package_linux.sh v1.2.1.1503

# Android Release (生成 APK 安装包)
flutter build apk --release

# iOS Release (生成通用未签名 IPA 安装包)
flutter build ios --release --no-codesign
bash tool/package_ios.sh v1.2.1.1503
```

### 🍏 iOS 端安装与使用指南

本项目针对 iOS 平台提供包含主程序与完整 `PlugIns/wmimoService.appex`（VPN 系统扩展）的通用 IPA 安装包（`Wmimo-iOS-universal-*.ipa`）。

#### 1. TrollStore（巨魔商店，强烈推荐 ⭐⭐⭐⭐⭐）
- **适用机型与系统**：iOS 14.0 ～ 17.0（不含 17.0.1 及更高版本）。
- **核心优势**：
  - **完全免证书、免 Apple ID、永久有效，永不掉签**；
  - TrollStore 自动通过系统 CoreTrust 机制赋予应用完整的底层 `NetworkExtension`（系统级 VPN）运行权限，无需任何付费开发者账号。
- **安装步骤**：
  1. 在 [Releases](https://github.com/aimy1/Wmimo/releases) 页面下载 `Wmimo-iOS-universal-*.ipa`；
  2. 使用 Safari 下载或通过 AirDrop 传送到 iPhone；
  3. 点击“分享”菜单 -> 选择 **“用 TrollStore 打开”** -> 点击 **“Install”**；
  4. 打开 Wmimo，允许添加 VPN 配置，即可正常开启系统代理与分流。

#### 2. 自签名工具（AltStore / SideStore / Sideloadly / 牛蛙助手 / 企业证书）
- **适用机型与系统**：iOS 17.0.1 及更高版本设备（不支持 TrollStore 的设备）。
- **使用说明**：
  - 下载 `.ipa` 后，导入自签工具进行签名安装；
  - **注意**：免费个人 Apple ID 签名受到苹果权限限制，可能无法开启系统级 VPN 隧道；建议使用具备完整 NetworkExtension 权限的个人付费开发者证书或企业证书签名分发。

#### 3. 本地 Xcode 源码联机部署
- 在 Mac 上克隆本项目并运行：
  ```bash
  open ios/Runner.xcworkspace
  ```
- 在 Xcode 的 Signing & Capabilities 中登录您的 Apple ID，选择开发者 Team，手机连上电脑后直接一键 Run 安装到真机。

---

## 🚀 持续集成与自动化发布 (CI/CD)

本项目配置了完整的 GitHub Actions 自动化工作流（`.github/workflows/release.yml`）：

- **Windows x64 / ARM64**：Inno Setup 安装包 (`.exe`) + 绿色便携包 (`.zip`)
- **macOS Universal (Apple Silicon & Intel)**：DMG 拖拽安装镜像 (`.dmg`) + 便携绿色包 (`.zip`)
- **Linux 全发行版支持**：Debian (`.deb`) + RedHat (`.rpm`) + AppImage (`.AppImage`) + Arch (`.pkg.tar.zst`) + 绿色包 (`.tar.gz`)
- **Android**：分架构 APK (`arm64-v8a`, `armeabi-v7a`, `x86_64`) + 通用版 APK
- **iOS**：通用未签名 IPA (`.ipa`)，完美适配 TrollStore 巨魔商店永久免签与各类自签工具
- **完整性验证**：自动生成包含所有产物的 `SHA256SUMS.txt` 校验和。

---

## 🙏 致谢与鸣谢

- 🌟 **特别鸣谢 [GooRingX (vowe)](https://github.com/GooRingX)** 的杰出开源贡献、设计思路与灵感指导！
- 🚀 **特别感谢 [Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** 团队提供的高性能、全协议通用代理核心。
- 💙 **感谢 [Flutter](https://flutter.dev/)** 团队与社区提供的跨平台 UI 框架支持。

---

## 📬 联系作者与 Bug 反馈

如果您在使用过程中遇到任何 Bug、异常崩溃或有功能改进建议，欢迎联系作者进行反馈：

- 💬 **Telegram 频道/讨论群**: [t.me/wmimoapp](https://t.me/wmimoapp)
- 📧 **联系邮箱**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- 🐛 **GitHub Issues**: [提交 Issue 反馈](https://github.com/aimy1/Wmimo/issues)

---

## 📄 开源许可证

本项目基于 **GPL-3.0** 开源许可证分发与使用。详细条款请参阅 [LICENSE](LICENSE) 文件。
