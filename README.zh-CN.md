# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


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
