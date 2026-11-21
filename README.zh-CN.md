<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---

<div align="center">
  <img src="assets/images/app_icon_256.png" width="112" height="112" alt="Wmimo Logo" />
  <h1>Wmimo</h1>
  <p><strong>新一代全平台 Clash / Mihomo 桌面与移动端代理客户端</strong></p>
  <p>基于 Flutter 与 Mihomo (v1.19.34) 核心构建。坚持数据零遥测与纯本地执行，集多跳链式代理、并发链路诊断、实时波形测速与系统级原生融合于一体。</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions/workflows/release.yml"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="CI Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://github.com/MetaCubeX/mihomo"><img src="https://img.shields.io/badge/Mihomo-v1.19.34-FF6B6B?style=flat-square" alt="Mihomo Core" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-%3E%3D3.35-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="#sec-platforms"><img src="https://img.shields.io/badge/Platforms-Win%20%7C%20macOS%20%7C%20Linux%20%7C%20Android%20%7C%20iOS-0EA5E9?style=flat-square" alt="Platforms" /></a>
    <a href="docs/BENCHMARKS.md"><img src="https://img.shields.io/badge/i18n-9%20Locales%20%C2%B7%20898%20Keys-10B981?style=flat-square" alt="i18n" /></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPL--3.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-%40wmimoapp-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><b>下载发布版</b></a> •
    <a href="#sec-platforms"><b>支持平台</b></a> •
    <a href="#sec-features"><b>核心能力</b></a> •
    <a href="#sec-architecture"><b>技术架构</b></a> •
    <a href="#sec-quickstart"><b>快速上手</b></a> •
    <a href="#sec-build"><b>源码编译</b></a> •
    <a href="#sec-security"><b>安全与许可</b></a> •
    <a href="#sec-community"><b>社区反馈</b></a>
  </p>
</div>

| 浅色主题 (Light) | 深色主题 (Dark) |
| :---: | :---: |
| <img src="docs/preview_light.png" alt="Wmimo Light Theme" width="380" /> | <img src="docs/preview_dark.png" alt="Wmimo Dark Theme" width="380" /> |

<p align="center"><sub><em>18px 极简微卡片仪表盘 · 实时贝塞尔流量曲线 · TUN / 系统代理双引擎 · 支持自定义首页卡片与横竖屏自适应</em></sub></p>

---

<a id="sec-platforms"></a>

## 支持平台与发布产物清单

| 操作系统 | 支持架构 | 官方发布包格式 | 平台专属特性 |
| :--- | :--- | :--- | :--- |
| **Windows** | `x64`, `arm64` | 安装程序 (`.exe`)、便携压缩包 (`.zip`) | 免特权系统代理、WHQL 签名 Wintun TUN（管理员）、UWP 回环豁免、深浅色同步托盘与实时网速、全局快捷键 |
| **macOS** | `Universal` (`arm64` + `x64`) | `.dmg` 镜像、便携压缩包 (`.zip`) | 安全服务提权与 TUN、系统代理、自适应菜单栏图标、iCloud Drive 云端备份同步、全局快捷键 |
| **Linux** | `x64`, `arm64` | `.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz` | `setcap` / 服务提权 TUN 模式、系统代理、GTK3 桌面集成、全局快捷键 |
| **Android** | `arm64-v8a`, `armeabi-v7a`, `x86_64` | 分架构 APK 与通用版 `.apk` | 不断流分应用代理热更新（黑白名单 + 免授权预设）、电池优化保活检测、快捷设置磁贴、前台通知控制 |
| **iOS** | `arm64` | 未签名 `.ipa`（巨魔 / 自签侧载） | Network Extension VPN 隧道、iCloud Drive 同步（详见 [Apple 开发指南](docs/APPLE_DEVELOPMENT.md)） |

> 请前往 [GitHub Releases](https://github.com/aimy1/Wmimo/releases) 下载对应平台安装包，并参考 [SECURITY.md](SECURITY.md) 校验 Android APK SHA-256 签名指纹与 Wintun 驱动签名。

---

<a id="sec-features"></a>

## 核心能力矩阵与特性详解

| 功能模块 | 核心能力摘要 |
| :--- | :--- |
| **Mihomo 路由内核** | `v1.19.34` • 覆盖 SS、VMess、VLESS (Reality)、Trojan、Hysteria 1/2、TUIC v5、WireGuard、SSH、Direct；独立 Isolate 解析订阅（5,000 节点仅 ~163 ms） |
| **多跳链式代理 `[Beta]`** | 基于 **`dialer-proxy`** 链式编排（入口策略/节点 ➔ 任意中转跳 ➔ 出口落地），支持拖拽换序、重复节点/策略组校验，`chain_proxies.json` 独立持久化不受订阅更新影响 |
| **移动端分应用代理** | 白名单空列表防漏流保护；VPN 运行期句柄平滑热替换无需重启核心；应用列表 + Launcher 去重探测与常用应用免授权预设 |
| **网络链路诊断 (`NetCheck`)** | 两阶段 5 步并发体检（自动过滤虚拟 TUN 网卡、DNS 与 Fake-IP `198.18.0.0/15` 检测、核心端口、代理/TUN 对齐、真实出口 204 握手含兜底）+ 并发单域名排查 + 一键自愈 |
| **内置网络测速 (`SpeedTest`)** | 多流并发 HTTP 下载/上传测速、同主机稳态 Ping/抖动采样、实时上下行双线波形曲线、场景评级（电竞/8K/会议）、选服并发延迟徽标与代理前置校验 |
| **备份与云端同步** | 支持 WebDAV、iCloud Drive（iOS/macOS）、本地与 URL 导入导出 `.zip`；纳入链式代理配置，预解压临时校验防毁损，严格防 Zip-Slip 路径穿越 |
| **微卡片 UI 与流量监控** | 原生浅色/深黑双主题、可定制首页卡片管理器、默认开启跟随屏幕旋转、1m–60m 多尺度贝塞尔流量波纹图、出口 IP 归属与隐私脱敏卡片 |
| **隐私零收集与 9 国语言** | 零广告与遥测 SDK，全链路本地运行；**9 种语言 × 898 词条 100% 对齐**，并内置全 9 语种独立《隐私政策》与《用户协议》视图 |

### 智能路由、多跳链式代理与诊断

- **双引擎出站调度**：支持 **规则 (Rule)** / **全局 (Global)** / **直连 (Direct)** 秒级切换，灵活搭配 **TUN 虚拟网卡** 与免特权 **系统代理**。
- **多跳链式代理 `[Beta]`**：通过 `dialer-proxy` 构建任意跳数拓扑，代理面板顶栏实时角标展示已启用链路数。
- **并发诊断与可视化测速**：快速定位 DNS 污染、端口冲突或残留系统代理隐患，并通过实时吞吐波形曲线与三阶段进度直观评估节点质量。

### 分平台设置体系与数据备份安全

- **因地制宜的设置层级**：主设置分为常规与内核、规则/链式与诊断、数据与同步、帮助与关于四大板块；桌面端集成快捷键与数据目录直达，Android 端提供电池优化保活与系统权限入口。
- **原子安全备份还原**：备份覆盖订阅、覆写补丁、分流模板与 `chain_proxies.json`；还原前先于缓存临时目录完整试解压，校验无误后再替换本地配置。
- **多通道自动更新**：自由切换 `stable` 与 `beta` 通道，下载自动执行 SHA-256 哈希完整性校验。

---

<a id="sec-architecture"></a>

## 技术栈与工程目录结构

| 架构层级 | 核心技术与职责 | 源码路径 |
| :--- | :--- | :--- |
| **UI 与交互层** | Flutter (`>= 3.35.0`)、18px 微卡片看板、Canvas 仪表盘/波形绘制、桌面/移动端自适应布局 | [`lib/screens/`](lib/screens/) |
| **业务模块与内核桥接** | 配置管理器（`SettingManager` / `ChainProxyManager` / `ProfileManager`）、Isolate 解析器 | [`lib/app/`](lib/app/) |
| **VPN 服务与系统层** | 跨平台服务封装、Android Kotlin（`WmimoVpnService.kt`）、macOS/Linux 安全提权 | [`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/)、[`android/`](android/) |
| **Rust 原生组件** | 高性能原生工具包工作区 | [`rust/`](rust/) |
| **多语言与合规文本** | Slang 强类型多语言代码生成（9 语种 × 898 词条）与全语种协议/隐私文本 | [`lib/i18n/`](lib/i18n/)、[`assets/txts/`](assets/txts/) |
| **CI 构建、打包与测试** | GitHub Actions 多平台自动化构建与打包脚本、单元测试与组件测试套件 | [`.github/workflows/release.yml`](.github/workflows/release.yml)、[`test/`](test/) |

---

<a id="sec-quickstart"></a>

## 三步快速上手

1. **下载安装**：前往 [GitHub Releases](https://github.com/aimy1/Wmimo/releases) 获取对应操作系统安装包。
2. **导入配置**：进入「订阅配置」，粘贴 Clash/Mihomo 订阅链接或导入本地 YAML 文件。
3. **连接使用**：点击「首页」主连接开关即可启用代理分流。

<details>
<summary><b>各平台使用与排障贴士（Windows / Android / macOS & Linux / iOS）</b></summary>

- **Windows**: 日常可直接使用免提权 **系统代理模式**；如需 **TUN 虚拟网卡** 全局接管，请右键「以管理员身份运行」。在 `wmimo.exe` 同级目录新建 `portable` 文件夹或在设置开启便携模式即可绿色运行。
- **Android**: 建议在系统设置中将 Wmimo 设为「忽略电池优化」以保证后台断流防护；进入 **分应用代理** 修改黑白名单后返回或在页面内应用即可热生效，无需断开内核重连。
- **macOS / Linux**: 开启 TUN 虚拟网卡首次需要授予核心服务权限，应用已通过安全的环境变量与标准输入通道调用系统授权弹窗。
- **iOS**: 发布产物为未签名 `.ipa`，可通过 TrollStore 巨魔或个人开发者证书重签安装，详见 [docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)。

</details>

---

<a id="sec-build"></a>

## 本地源码编译

### 前置依赖

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) 与 [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- 目标平台编译器：Visual Studio 2022 C++（Windows）、Xcode（macOS/iOS）、GTK3/Clang/CMake/Ninja（Linux）、Android SDK & NDK（Android）

### 常用命令

```bash
# 1. Clone repository
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. Fetch dependencies & generate i18n bindings
flutter pub get
dart run slang

# 3. Download prebuilt Mihomo cores
dart run tool/download_all_cores.dart

# 4. Run development build
flutter run

# 5. Build release artifacts
flutter build windows --release
flutter build macos --release
flutter build linux --release
flutter build apk --release
```

---

<a id="sec-benchmarks"></a>

## 性能基准与自动化验证

- **高吞吐订阅解析**：`~30,670 节点/秒` —— 后台 Isolate 解析与归类 `5,000` 个多协议节点仅耗时 `~163 ms`，不阻塞 UI 渲染帧。
- **极速格式探测**：`SubscriptionConverter.isClashYaml` 在 `1,000` 节点规模下仅耗时 `~1.4 ms`。
- **9 国语言零缺失**：**9/9 语种 × 898 词条 = 100.0% 覆盖率**，且 9 语种《隐私政策》与《用户协议》全部对齐。
- **本地一键验证**：依次运行 `flutter analyze --no-pub lib/ third_party/libclash_vpn_service/lib/ test/`、`flutter test test/benchmark_profile_scale_test.dart`、`flutter test test/i18n_integrity_test.dart` 与 `dart run tool/verify_i18n.dart`。

完整基准测试方法与硬件环境说明请参阅 [docs/BENCHMARKS.md](docs/BENCHMARKS.md)。

<details>
<summary><b>Star 增长趋势图</b></summary>

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

</details>

---

<a id="sec-security"></a>

## 隐私承诺、安全校验与开源许可

- **隐私零收集承诺**：所有路由、DNS 与诊断计算均在本机完成，无任何商业统计或追踪 SDK，详见 [assets/txts/privacy_policy_cn.txt](assets/txts/privacy_policy_cn.txt)。
- **官方产物验签**：请参阅 [SECURITY.md](SECURITY.md) 核对官方 Android APK SHA-256 签名证书指纹及 Wintun WHQL 签名说明。

### 开源协议

本项目依据 **GNU General Public License v3.0 (GPL-3.0-or-later)** 开源发布，详情见 [LICENSE](LICENSE)。

- **Rust Workspace 模块**：独立使用时采用 [MIT](rust/LICENSE-MIT) OR [Apache-2.0](rust/LICENSE-APACHE) 双重许可；随 Wmimo 编译分发时受 GPL-3.0 约束。
- **第三方组件与核心声明**：请参阅 [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) 与 [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)。

---

<a id="sec-community"></a>

## 致谢

- **[GooRingX (vowe)](https://github.com/GooRingX)** —— 感谢杰出的开源贡献、架构见解与设计灵感。
- **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** —— 感谢强大的跨平台代理内核与协议支持。
- **[Flutter](https://flutter.dev/)** —— 感谢现代化的跨平台 UI 框架与社区。

## 社区交流与支持

- **官方网站**: [wmimo.buzz](https://wmimo.buzz)
- **Telegram 官方频道**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **开发者邮箱**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **问题反馈 (Issues)**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)
