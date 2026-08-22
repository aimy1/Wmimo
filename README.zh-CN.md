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
  </p>
</div>

---

## 🔥 Beta 分支专属特性 (What's New in Beta)

> [!TIP]
> 当前分支为 **`beta` 测试预览分支**，包含了最新的协议支持、Linux 深度适配优化以及多项节点稳定性改进：

- 🔄 **全协议通用订阅转换器 (`SubscriptionConverter`)**：
  - 自动识别并解析 **Base64 订阅**与各类单节点链接（支持 `vmess://`、`vless://` (Reality/Vision)、`ss://`、`trojan://`、`hysteria2://` / `hy2://`、`tuic://` 等最新协议）；
  - 智能生成地区分组（🇭🇰 香港节点、🇯🇵 日本节点、🇸🇬 新加坡节点、🇹🇼 台湾节点、🇺🇸 美国节点、🇰🇷 韩国节点等）、`节点选择`、`自动选择`、`故障转移` 以及全局路由规则；
  - 允许在“添加配置”界面直接粘贴单节点链接或 Base64 文本快速导入。
- 🐧 **Linux 平台连接稳定性与工作目录权限优化**：
  - 将内核工作目录 `work_dir` 修正至用户主目录下的可读写路径 `~/.local/share/wmimo`，彻底解决 AppImage / 安装包环境下的只读权限与 `cache.db` 创建失败问题；
  - 启动连接前确保配置包含完整 `proxy-groups:` 结构，解决 Linux 下连接后节点消失的偶发问题。
- 🎯 **精准内核适配器过滤与代理保护**：
  - 精准过滤 Mihomo Meta 内部流控与规则适配器桩（如 `COMPATIBLE`、`PASS`、`PASS-RULE`、`REJECT-DROP`、`DIRECT`、`REJECT`、`DNS`），防止内置桩伪装为代理节点；
  - 确保测速（⚡）与卡片网格始终仅针对真实的机场代理节点生效，测速前后节点永远不会消失。
- 📦 **Linux 全主流发行版原生打包支持**：
  - 提供 AppImage（免安装即开即用）、Debian/Ubuntu (`.deb`)、Fedora/RHEL (`.rpm`)、Arch Linux (`.pkg.tar.zst` & `PKGBUILD`) 以及通用绿色便携包 (`.tar.gz`)。

---

## 📌 全平台与 Linux 各大发行版支持矩阵

| 平台 / 发行版 | 状态 | 软件包格式 | 功能与适配说明 |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **已基本完成** | 安装包 (`.exe`) 与 绿色便携包 (`.zip`) | 完整桌面侧边栏、全功能系统托盘（实时网速、分流模式切换、节点测速）、TUN 虚拟网卡模式、自动更新。 |
| 🐧 **Linux 通用免安装** | ✅ **已就绪** | 通用独立镜像 (`.AppImage`) 与 绿色便携包 (`.tar.gz`) | 单文件免安装，解压即用，完美兼容所有主流与轻量 Linux 发行版。 |
| 🐧 **Debian / Ubuntu / Mint / Deepin / UOS** | ✅ **已就绪** | Debian 安装包 (`.deb`) | 原生包管理器支持，自动注册桌面启动菜单、高清图标与系统服务。 |
| 🐧 **Fedora / RHEL / CentOS / openSUSE** | ✅ **已就绪** | RedHat 安装包 (`.rpm`) | 标准 RPM 格式封装，自动配置运行时依赖与桌面集成。 |
| 🐧 **Arch Linux / Manjaro / EndeavourOS** | ✅ **已就绪** | Pacman 二进制包 (`.pkg.tar.zst`) 与 `PKGBUILD` | 支持 pacman 一键安装与 AUR 脚本直接构建。 |
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

# Linux Release (一键打包 Deb, RPM, AppImage, Arch 与 Tarball)
flutter build linux --release
bash tool/package_linux.sh v1.0.33

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
