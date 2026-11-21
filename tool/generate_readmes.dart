import 'dart:io';

/// Structured localization bundle for generating synchronized multi-language READMEs.
class _ReadmeSpec {
  final String fileName;
  final String tagline;
  final String subtitle;
  final String navDownloads;
  final String navPlatforms;
  final String navFeatures;
  final String navArchitecture;
  final String navQuickStart;
  final String navBuild;
  final String navSecurity;
  final String navCommunity;
  final String lightCaption;
  final String darkCaption;
  final String previewNote;
  final String platformsTitle;
  final String colPlatform;
  final String colArch;
  final String colPackages;
  final String colHighlights;
  final List<(String, String, String, String)> platformRows;
  final String platformReleaseNote;
  final String featuresTitle;
  final String colModule;
  final String colCapability;
  final List<(String, String)> featureMatrix;
  final List<(String, List<String>)> featureDetails;
  final String archTitle;
  final String colLayer;
  final String colTech;
  final String colPath;
  final List<(String, String, String)> archRows;
  final String quickStartTitle;
  final List<String> quickSteps;
  final String tipsSummary;
  final List<(String, String)> platformTips;
  final String buildTitle;
  final String prereqHeading;
  final List<String> prereqs;
  final String commandsHeading;
  final String benchmarksTitle;
  final List<String> benchmarkBullets;
  final String benchmarksLinkText;
  final String starHistoryHeading;
  final String securityTitle;
  final List<String> securityBullets;
  final String ackTitle;
  final List<String> ackBullets;
  final String communityTitle;
  final String labelWebsite;
  final String labelTelegram;
  final String labelEmail;
  final String labelIssues;
  final String licenseTitle;
  final String licenseIntro;
  final List<String> licenseBullets;

  const _ReadmeSpec({
    required this.fileName,
    required this.tagline,
    required this.subtitle,
    required this.navDownloads,
    required this.navPlatforms,
    required this.navFeatures,
    required this.navArchitecture,
    required this.navQuickStart,
    required this.navBuild,
    required this.navSecurity,
    required this.navCommunity,
    required this.lightCaption,
    required this.darkCaption,
    required this.previewNote,
    required this.platformsTitle,
    required this.colPlatform,
    required this.colArch,
    required this.colPackages,
    required this.colHighlights,
    required this.platformRows,
    required this.platformReleaseNote,
    required this.featuresTitle,
    required this.colModule,
    required this.colCapability,
    required this.featureMatrix,
    required this.featureDetails,
    required this.archTitle,
    required this.colLayer,
    required this.colTech,
    required this.colPath,
    required this.archRows,
    required this.quickStartTitle,
    required this.quickSteps,
    required this.tipsSummary,
    required this.platformTips,
    required this.buildTitle,
    required this.prereqHeading,
    required this.prereqs,
    required this.commandsHeading,
    required this.benchmarksTitle,
    required this.benchmarkBullets,
    required this.benchmarksLinkText,
    required this.starHistoryHeading,
    required this.securityTitle,
    required this.securityBullets,
    required this.ackTitle,
    required this.ackBullets,
    required this.communityTitle,
    required this.labelWebsite,
    required this.labelTelegram,
    required this.labelEmail,
    required this.labelIssues,
    required this.licenseTitle,
    required this.licenseIntro,
    required this.licenseBullets,
  });
}

String _renderTable(List<String> headers, List<List<String>> rows) {
  final buf = StringBuffer();
  buf.writeln('| ${headers.join(' | ')} |');
  buf.writeln('| ${headers.map((_) => ':---').join(' | ')} |');
  for (final r in rows) {
    buf.writeln('| ${r.join(' | ')} |');
  }
  return buf.toString().trimRight();
}

String _renderReadme(_ReadmeSpec s) {
  final b = StringBuffer();

  // Top Language Bar
  b.writeln('''<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---

<div align="center">
  <img src="assets/images/app_icon_256.png" width="112" height="112" alt="Wmimo Logo" />
  <h1>Wmimo</h1>
  <p><strong>${s.tagline}</strong></p>
  <p>${s.subtitle}</p>

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
    <a href="https://github.com/aimy1/Wmimo/releases"><b>${s.navDownloads}</b></a> •
    <a href="#sec-platforms"><b>${s.navPlatforms}</b></a> •
    <a href="#sec-features"><b>${s.navFeatures}</b></a> •
    <a href="#sec-architecture"><b>${s.navArchitecture}</b></a> •
    <a href="#sec-quickstart"><b>${s.navQuickStart}</b></a> •
    <a href="#sec-build"><b>${s.navBuild}</b></a> •
    <a href="#sec-security"><b>${s.navSecurity}</b></a> •
    <a href="#sec-community"><b>${s.navCommunity}</b></a>
  </p>
</div>

| ${s.lightCaption} | ${s.darkCaption} |
| :---: | :---: |
| <img src="docs/preview_light.png" alt="Wmimo Light Theme" width="380" /> | <img src="docs/preview_dark.png" alt="Wmimo Dark Theme" width="380" /> |

<p align="center"><sub><em>${s.previewNote}</em></sub></p>

---
''');

  // 1. Supported Platforms & Release Artifacts
  b.writeln('<a id="sec-platforms"></a>\n');
  b.writeln('## ${s.platformsTitle}\n');
  b.writeln(
    _renderTable(
      [s.colPlatform, s.colArch, s.colPackages, s.colHighlights],
      s.platformRows.map((r) => [r.$1, r.$2, r.$3, r.$4]).toList(),
    ),
  );
  b.writeln('\n> ${s.platformReleaseNote}\n\n---\n');

  // 2. Core Features & Capabilities Matrix
  b.writeln('<a id="sec-features"></a>\n');
  b.writeln('## ${s.featuresTitle}\n');
  b.writeln(
    _renderTable(
      [s.colModule, s.colCapability],
      s.featureMatrix.map((r) => [r.$1, r.$2]).toList(),
    ),
  );
  b.writeln();
  for (final group in s.featureDetails) {
    b.writeln('### ${group.$1}\n');
    for (final bullet in group.$2) {
      b.writeln('- $bullet');
    }
    b.writeln();
  }
  b.writeln('---\n');

  // 3. Tech Stack & Project Structure
  b.writeln('<a id="sec-architecture"></a>\n');
  b.writeln('## ${s.archTitle}\n');
  b.writeln(
    _renderTable(
      [s.colLayer, s.colTech, s.colPath],
      s.archRows.map((r) => [r.$1, r.$2, r.$3]).toList(),
    ),
  );
  b.writeln('\n---\n');

  // 4. Quick Start & Platform Tips
  b.writeln('<a id="sec-quickstart"></a>\n');
  b.writeln('## ${s.quickStartTitle}\n');
  for (int i = 0; i < s.quickSteps.length; i++) {
    b.writeln('${i + 1}. ${s.quickSteps[i]}');
  }
  b.writeln('\n<details>\n<summary><b>${s.tipsSummary}</b></summary>\n');
  for (final tip in s.platformTips) {
    b.writeln('- **${tip.$1}**: ${tip.$2}');
  }
  b.writeln('\n</details>\n\n---\n');

  // 5. Build from Source
  b.writeln('<a id="sec-build"></a>\n');
  b.writeln('## ${s.buildTitle}\n');
  b.writeln('### ${s.prereqHeading}\n');
  for (final p in s.prereqs) {
    b.writeln('- $p');
  }
  b.writeln('\n### ${s.commandsHeading}\n');
  b.writeln('''```bash
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
''');

  // 6. Benchmarks & Quality Verification
  b.writeln('<a id="sec-benchmarks"></a>\n');
  b.writeln('## ${s.benchmarksTitle}\n');
  for (final item in s.benchmarkBullets) {
    b.writeln('- $item');
  }
  b.writeln('\n${s.benchmarksLinkText}\n');
  b.writeln('<details>\n<summary><b>${s.starHistoryHeading}</b></summary>\n');
  b.writeln(
    '[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)\n',
  );
  b.writeln('</details>\n\n---\n');

  // 7. Security, Privacy & License
  b.writeln('<a id="sec-security"></a>\n');
  b.writeln('## ${s.securityTitle}\n');
  for (final item in s.securityBullets) {
    b.writeln('- $item');
  }
  b.writeln('\n### ${s.licenseTitle}\n');
  b.writeln('${s.licenseIntro}\n');
  for (final l in s.licenseBullets) {
    b.writeln('- $l');
  }
  b.writeln('\n---\n');

  // 8. Acknowledgements & Community
  b.writeln('<a id="sec-community"></a>\n');
  b.writeln('## ${s.ackTitle}\n');
  for (final a in s.ackBullets) {
    b.writeln('- $a');
  }
  b.writeln('\n## ${s.communityTitle}\n');
  b.writeln('- **${s.labelWebsite}**: [wmimo.buzz](https://wmimo.buzz)');
  b.writeln('- **${s.labelTelegram}**: [t.me/wmimoapp](https://t.me/wmimoapp)');
  b.writeln('- **${s.labelEmail}**: [aisaniya@proton.me](mailto:aisaniya@proton.me)');
  b.writeln('- **${s.labelIssues}**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)');

  return b.toString();
}

void main() {
  final specs = <_ReadmeSpec>[
    // 1. English
    const _ReadmeSpec(
      fileName: 'README.md',
      tagline: 'Next-Generation Cross-Platform Clash / Mihomo GUI Proxy Client',
      subtitle:
          'Built with Flutter & Mihomo Core (v1.19.34). Designed for zero telemetry, multi-hop chaining, real-time diagnostics, and native OS integration across desktop and mobile.',
      navDownloads: 'Download',
      navPlatforms: 'Platforms',
      navFeatures: 'Features',
      navArchitecture: 'Architecture',
      navQuickStart: 'Quick Start',
      navBuild: 'Build',
      navSecurity: 'Security & License',
      navCommunity: 'Community',
      lightCaption: 'Light Mode',
      darkCaption: 'Dark Mode',
      previewNote:
          '18px micro-card dashboard, live Bezier throughput graph, dual TUN / System Proxy engines, and customizable home cards',
      platformsTitle: 'Supported Platforms & Release Artifacts',
      colPlatform: 'Platform',
      colArch: 'Architecture',
      colPackages: 'Release Packages',
      colHighlights: 'Platform Highlights',
      platformRows: [
        (
          '**Windows**',
          '`x64`, `arm64`',
          'Installer (`.exe`), Portable (`.zip`)',
          'Unprivileged System Proxy, WHQL-signed Wintun TUN (Admin), UWP Loopback helper, Dark/Light Tray & live speed, Global Hotkeys',
        ),
        (
          '**macOS**',
          '`Universal` (`arm64` + `x64`)',
          '`.dmg` Installer, Portable (`.zip`)',
          'Privileged service authorization (`osascript` env-safe), System Proxy & TUN, adaptive Menu Bar icon, iCloud Drive sync, Global Hotkeys',
        ),
        (
          '**Linux**',
          '`x64`, `arm64`',
          '`.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz`',
          '`setcap` / privileged service TUN, System Proxy, GTK3 desktop shell, Global Hotkeys',
        ),
        (
          '**Android**',
          '`arm64-v8a`, `armeabi-v7a`, `x86_64`',
          'Split ABI & Universal `.apk`',
          'Live hot-swap Per-App Proxy (Whitelist/Blacklist + presets), Battery Optimization Keep-Alive, Quick Settings Tile, Foreground notification',
        ),
        (
          '**iOS**',
          '`arm64`',
          'Unsigned `.ipa` (TrollStore / Sideload)',
          'Network Extension VPN tunnel & iCloud Drive backup sync (see [Apple Dev Guide](docs/APPLE_DEVELOPMENT.md))',
        ),
      ],
      platformReleaseNote:
          'Download official binaries from [GitHub Releases](https://github.com/aimy1/Wmimo/releases) and verify Android APK SHA-256 / Wintun signatures against [SECURITY.md](SECURITY.md).',
      featuresTitle: 'Core Capabilities & Feature Highlights',
      colModule: 'Module',
      colCapability: 'Key Capabilities',
      featureMatrix: [
        (
          '**Mihomo Routing Core**',
          '`v1.19.34` • Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH, Direct • Isolate YAML parser (`5,000` nodes in `~163 ms`)',
        ),
        (
          '**Multi-Hop Chain Proxy `[Beta]`**',
          'Built on **`dialer-proxy`** orchestration (`Entry ➔ Transit... ➔ Exit`), drag/swap hop ordering, anti-duplicate validation, atomic `chain_proxies.json` surviving subscription updates',
        ),
        (
          '**Mobile Per-App Proxy**',
          'Android allowlist/blocklist with empty-whitelist leak guard, live VPN interface hot-swap without restarting Mihomo, Launcher + system app deduplicated discovery & auth-free presets',
        ),
        (
          '**Network Diagnostics (`NetCheck`)**',
          '2-phase concurrent 5-step pipeline (NIC/gateway ignoring virtual TUN NICs, DNS & Fake-IP `198.18.0.0/15`, Core/Ports, Proxy/TUN, Active Node 204 probe) + Domain Query + One-Click Auto-Repair',
        ),
        (
          '**Speed Test Engine (`SpeedTest`)**',
          'Multi-stream HTTP download/upload, steady Ping & Jitter, real-time dual-series waveform chart, scenario grades (`Gaming / 8K / Calls`), concurrent CDN latency badges, proxy pre-flight check',
        ),
        (
          '**Backup & Sync**',
          'WebDAV, iCloud Drive (iOS/macOS), local & URL `.zip` export/restore; includes `chain_proxies.json`, optional-file resilience, pre-staged atomic restore & Zip-Slip protection',
        ),
        (
          '**Micro-Card UI & Telemetry**',
          'Light & OLED Dark themes, customizable Home Cards Manager, Auto-Orientation enabled by default, multi-span Bezier traffic wave (`1m–60m`), egress IP/Geo/ISP with privacy masking',
        ),
        (
          '**Privacy & Localization**',
          'Zero telemetry/analytics SDKs, strict local execution, **9 languages × 898 keys (100% parity)** plus dedicated 9-language Privacy Policy & User Agreement views',
        ),
      ],
      featureDetails: [
        (
          'Routing, Chain Proxy & Diagnostics',
          [
            '**Outbound Modes & Dual Engine**: Instant switching between **Rule**, **Global**, and **Direct** over either **TUN Mode** or unprivileged **System Proxy Mode**.',
            '**Multi-Hop Chain Proxy `[Beta]`**: Link policy groups or individual relays into arbitrary multi-hop `dialer-proxy` topologies with real-time enabled badge on the Proxy Board.',
            '**Concurrent Diagnostics & Speed Test**: Diagnose DNS pollution, Fake-IP, port conflicts, zombie OS proxies, and live multi-stream download/upload curves with steady Ping/Jitter calibration.',
          ],
        ),
        (
          'OS Integration, Settings & Backup Safety',
          [
            '**Platform-Tailored Settings**: Consolidated 4-section hierarchy separating Desktop tools (Global Hotkeys, data folder shortcut) and Mobile controls (Android Battery Optimization Keep-Alive, System App Permissions, live Per-App Proxy).',
            '**Safe Atomic Backup & Restore**: Archives profiles, patches, diversion templates, settings, and `chain_proxies.json`; extracts to a temporary staging directory to verify archive integrity before touching active configs.',
            '**Multi-Channel Updates**: Switch between `stable` and `beta` channels with SHA-256 package verification.',
          ],
        ),
      ],
      archTitle: 'Architecture & Project Layout',
      colLayer: 'Layer',
      colTech: 'Technology / Responsibility',
      colPath: 'Location',
      archRows: [
        (
          '**UI & Screens**',
          'Flutter (`>= 3.35.0`), micro-card dashboard, Canvas charts, responsive Desktop/Mobile shell',
          '[`lib/screens/`](lib/screens/)',
        ),
        (
          '**App Modules & State**',
          'Config managers (`SettingManager`, `ChainProxyManager`, `ProfileManager`), Isolate parser',
          '[`lib/app/`](lib/app/)',
        ),
        (
          '**VPN & Native Bridge**',
          'Cross-platform service wrapper, Android Kotlin (`WmimoVpnService.kt`), macOS/Linux elevation',
          '[`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/), [`android/`](android/)',
        ),
        (
          '**Rust Crates**',
          'Native performance/utility workspace crates',
          '[`rust/`](rust/)',
        ),
        (
          '**i18n & Legal Assets**',
          'Slang-generated strongly typed translations (9 locales × 898 keys) & policy documents',
          '[`lib/i18n/`](lib/i18n/), [`assets/txts/`](assets/txts/)',
        ),
        (
          '**CI, Packaging & Benchmarks**',
          'Multi-platform release pipeline, Arch/Windows installers, automated test suites',
          '[`.github/workflows/release.yml`](.github/workflows/release.yml), [`test/`](test/)',
        ),
      ],
      quickStartTitle: 'Quick Start',
      quickSteps: [
        '**Download & Install**: Grab the matching package for your OS from [GitHub Releases](https://github.com/aimy1/Wmimo/releases).',
        '**Import Profile**: Open `Subscriptions` and paste a Clash/Mihomo URL or import a local YAML file.',
        '**Connect**: Toggle the master switch on `Overview` to start routing immediately.',
      ],
      tipsSummary: 'Platform-Specific Setup Notes (Windows / Android / macOS & Linux / iOS)',
      platformTips: [
        (
          'Windows',
          'Use **System Proxy Mode** without elevation, or right-click **Run as administrator** for WHQL Wintun **TUN Mode**. Create a `portable` folder beside `wmimo.exe` (or toggle Portable Mode in settings) for self-contained storage.',
        ),
        (
          'Android',
          'Grant VPN permission on first connect. In Settings, whitelist Wmimo from **Battery Optimization** for background keep-alive and configure **Per-App Proxy** (live hot-swap supported without reconnecting core).',
        ),
        (
          'macOS & Linux',
          'TUN mode requests one-time service authorization via secure stdin (`sudo -S`) or system prompt (`osascript` / `pkexec`).',
        ),
        (
          'iOS',
          'Distributed as unsigned `.ipa` for TrollStore or personal sideloading; see [docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md) for App Group & signing details.',
        ),
      ],
      buildTitle: 'Build from Source',
      prereqHeading: 'Prerequisites',
      prereqs: [
        '[Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) & [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)',
        'Platform toolchains: Visual Studio 2022 C++ (Windows), Xcode (macOS/iOS), GTK3/Clang/CMake/Ninja (Linux), Android SDK & NDK (Android)',
      ],
      commandsHeading: 'Commands',
      benchmarksTitle: 'Performance & Automated Verification',
      benchmarkBullets: [
        '**Subscription Parsing**: `~30,670 nodes/s` — `5,000` multi-protocol nodes parsed & grouped in `~163 ms` inside a background Isolate.',
        '**Format Fast-Path**: `SubscriptionConverter.isClashYaml` detects `1,000` nodes in `~1.4 ms`.',
        '**i18n Parity**: **9/9 locales × 898 keys = 100.0% coverage** (`0` missing keys, `0` empty values) + 9 localized Privacy Policies (`assets/txts/`).',
        '**Reproduce Locally**: Run `flutter analyze --no-pub lib/ third_party/libclash_vpn_service/lib/ test/`, `flutter test test/benchmark_profile_scale_test.dart`, `flutter test test/i18n_integrity_test.dart`, and `dart run tool/verify_i18n.dart`.',
      ],
      benchmarksLinkText: 'Full benchmark methodology & hardware details: [docs/BENCHMARKS.md](docs/BENCHMARKS.md).',
      starHistoryHeading: 'Star History',
      securityTitle: 'Security, Privacy & Licensing',
      securityBullets: [
        '**Zero Data Collection**: Strictly local execution; zero analytics, crash telemetry, or ad SDKs. Read full terms in [assets/txts/privacy_policy_en.txt](assets/txts/privacy_policy_en.txt).',
        '**Artifact Authenticity**: Verify official Android APK SHA-256 certificate fingerprints and WHQL Wintun notices in [SECURITY.md](SECURITY.md).',
      ],
      licenseTitle: 'License',
      licenseIntro:
        'Licensed under the **GNU General Public License v3.0 (GPL-3.0-or-later)**. See [LICENSE](LICENSE).',
      licenseBullets: [
        '**Rust Workspace Crates**: Dual-licensed under [MIT](rust/LICENSE-MIT) OR [Apache-2.0](rust/LICENSE-APACHE) standalone, and GPL-3.0 when distributed as part of Wmimo.',
        '**Third-Party & Core Components**: See [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) and [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md).',
      ],
      ackTitle: 'Acknowledgements',
      ackBullets: [
        '**[GooRingX (vowe)](https://github.com/GooRingX)** — architectural insights and open-source inspiration.',
        '**[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** — high-performance core routing & protocol engine.',
        '**[Flutter](https://flutter.dev/)** — cross-platform UI framework.',
      ],
      communityTitle: 'Community & Feedback',
      labelWebsite: 'Official Website',
      labelTelegram: 'Telegram Channel',
      labelEmail: 'Author Email',
      labelIssues: 'Issue Tracker',
    ),

    // 2. Simplified Chinese (README.zh-CN.md)
    const _ReadmeSpec(
      fileName: 'README.zh-CN.md',
      tagline: '新一代全平台 Clash / Mihomo 桌面与移动端代理客户端',
      subtitle:
          '基于 Flutter 与 Mihomo (v1.19.34) 核心构建。坚持数据零遥测与纯本地执行，集多跳链式代理、并发链路诊断、实时波形测速与系统级原生融合于一体。',
      navDownloads: '下载发布版',
      navPlatforms: '支持平台',
      navFeatures: '核心能力',
      navArchitecture: '技术架构',
      navQuickStart: '快速上手',
      navBuild: '源码编译',
      navSecurity: '安全与许可',
      navCommunity: '社区反馈',
      lightCaption: '浅色主题 (Light)',
      darkCaption: '深色主题 (Dark)',
      previewNote:
          '18px 极简微卡片仪表盘 · 实时贝塞尔流量曲线 · TUN / 系统代理双引擎 · 支持自定义首页卡片与横竖屏自适应',
      platformsTitle: '支持平台与发布产物清单',
      colPlatform: '操作系统',
      colArch: '支持架构',
      colPackages: '官方发布包格式',
      colHighlights: '平台专属特性',
      platformRows: [
        (
          '**Windows**',
          '`x64`, `arm64`',
          '安装程序 (`.exe`)、便携压缩包 (`.zip`)',
          '免特权系统代理、WHQL 签名 Wintun TUN（管理员）、UWP 回环豁免、深浅色同步托盘与实时网速、全局快捷键',
        ),
        (
          '**macOS**',
          '`Universal` (`arm64` + `x64`)',
          '`.dmg` 镜像、便携压缩包 (`.zip`)',
          '安全服务提权与 TUN、系统代理、自适应菜单栏图标、iCloud Drive 云端备份同步、全局快捷键',
        ),
        (
          '**Linux**',
          '`x64`, `arm64`',
          '`.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz`',
          '`setcap` / 服务提权 TUN 模式、系统代理、GTK3 桌面集成、全局快捷键',
        ),
        (
          '**Android**',
          '`arm64-v8a`, `armeabi-v7a`, `x86_64`',
          '分架构 APK 与通用版 `.apk`',
          '不断流分应用代理热更新（黑白名单 + 免授权预设）、电池优化保活检测、快捷设置磁贴、前台通知控制',
        ),
        (
          '**iOS**',
          '`arm64`',
          '未签名 `.ipa`（巨魔 / 自签侧载）',
          'Network Extension VPN 隧道、iCloud Drive 同步（详见 [Apple 开发指南](docs/APPLE_DEVELOPMENT.md)）',
        ),
      ],
      platformReleaseNote:
          '请前往 [GitHub Releases](https://github.com/aimy1/Wmimo/releases) 下载对应平台安装包，并参考 [SECURITY.md](SECURITY.md) 校验 Android APK SHA-256 签名指纹与 Wintun 驱动签名。',
      featuresTitle: '核心能力矩阵与特性详解',
      colModule: '功能模块',
      colCapability: '核心能力摘要',
      featureMatrix: [
        (
          '**Mihomo 路由内核**',
          '`v1.19.34` • 覆盖 SS、VMess、VLESS (Reality)、Trojan、Hysteria 1/2、TUIC v5、WireGuard、SSH、Direct；独立 Isolate 解析订阅（5,000 节点仅 ~163 ms）',
        ),
        (
          '**多跳链式代理 `[Beta]`**',
          '基于 **`dialer-proxy`** 链式编排（入口策略/节点 ➔ 任意中转跳 ➔ 出口落地），支持拖拽换序、重复节点/策略组校验，`chain_proxies.json` 独立持久化不受订阅更新影响',
        ),
        (
          '**移动端分应用代理**',
          '白名单空列表防漏流保护；VPN 运行期句柄平滑热替换无需重启核心；应用列表 + Launcher 去重探测与常用应用免授权预设',
        ),
        (
          '**网络链路诊断 (`NetCheck`)**',
          '两阶段 5 步并发体检（自动过滤虚拟 TUN 网卡、DNS 与 Fake-IP `198.18.0.0/15` 检测、核心端口、代理/TUN 对齐、真实出口 204 握手含兜底）+ 并发单域名排查 + 一键自愈',
        ),
        (
          '**内置网络测速 (`SpeedTest`)**',
          '多流并发 HTTP 下载/上传测速、同主机稳态 Ping/抖动采样、实时上下行双线波形曲线、场景评级（电竞/8K/会议）、选服并发延迟徽标与代理前置校验',
        ),
        (
          '**备份与云端同步**',
          '支持 WebDAV、iCloud Drive（iOS/macOS）、本地与 URL 导入导出 `.zip`；纳入链式代理配置，预解压临时校验防毁损，严格防 Zip-Slip 路径穿越',
        ),
        (
          '**微卡片 UI 与流量监控**',
          '原生浅色/深黑双主题、可定制首页卡片管理器、默认开启跟随屏幕旋转、1m–60m 多尺度贝塞尔流量波纹图、出口 IP 归属与隐私脱敏卡片',
        ),
        (
          '**隐私零收集与 9 国语言**',
          '零广告与遥测 SDK，全链路本地运行；**9 种语言 × 898 词条 100% 对齐**，并内置全 9 语种独立《隐私政策》与《用户协议》视图',
        ),
      ],
      featureDetails: [
        (
          '智能路由、多跳链式代理与诊断',
          [
            '**双引擎出站调度**：支持 **规则 (Rule)** / **全局 (Global)** / **直连 (Direct)** 秒级切换，灵活搭配 **TUN 虚拟网卡** 与免特权 **系统代理**。',
            '**多跳链式代理 `[Beta]`**：通过 `dialer-proxy` 构建任意跳数拓扑，代理面板顶栏实时角标展示已启用链路数。',
            '**并发诊断与可视化测速**：快速定位 DNS 污染、端口冲突或残留系统代理隐患，并通过实时吞吐波形曲线与三阶段进度直观评估节点质量。',
          ],
        ),
        (
          '分平台设置体系与数据备份安全',
          [
            '**因地制宜的设置层级**：主设置分为常规与内核、规则/链式与诊断、数据与同步、帮助与关于四大板块；桌面端集成快捷键与数据目录直达，Android 端提供电池优化保活与系统权限入口。',
            '**原子安全备份还原**：备份覆盖订阅、覆写补丁、分流模板与 `chain_proxies.json`；还原前先于缓存临时目录完整试解压，校验无误后再替换本地配置。',
            '**多通道自动更新**：自由切换 `stable` 与 `beta` 通道，下载自动执行 SHA-256 哈希完整性校验。',
          ],
        ),
      ],
      archTitle: '技术栈与工程目录结构',
      colLayer: '架构层级',
      colTech: '核心技术与职责',
      colPath: '源码路径',
      archRows: [
        (
          '**UI 与交互层**',
          'Flutter (`>= 3.35.0`)、18px 微卡片看板、Canvas 仪表盘/波形绘制、桌面/移动端自适应布局',
          '[`lib/screens/`](lib/screens/)',
        ),
        (
          '**业务模块与内核桥接**',
          '配置管理器（`SettingManager` / `ChainProxyManager` / `ProfileManager`）、Isolate 解析器',
          '[`lib/app/`](lib/app/)',
        ),
        (
          '**VPN 服务与系统层**',
          '跨平台服务封装、Android Kotlin（`WmimoVpnService.kt`）、macOS/Linux 安全提权',
          '[`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/)、[`android/`](android/)',
        ),
        (
          '**Rust 原生组件**',
          '高性能原生工具包工作区',
          '[`rust/`](rust/)',
        ),
        (
          '**多语言与合规文本**',
          'Slang 强类型多语言代码生成（9 语种 × 898 词条）与全语种协议/隐私文本',
          '[`lib/i18n/`](lib/i18n/)、[`assets/txts/`](assets/txts/)',
        ),
        (
          '**CI 构建、打包与测试**',
          'GitHub Actions 多平台自动化构建与打包脚本、单元测试与组件测试套件',
          '[`.github/workflows/release.yml`](.github/workflows/release.yml)、[`test/`](test/)',
        ),
      ],
      quickStartTitle: '三步快速上手',
      quickSteps: [
        '**下载安装**：前往 [GitHub Releases](https://github.com/aimy1/Wmimo/releases) 获取对应操作系统安装包。',
        '**导入配置**：进入「订阅配置」，粘贴 Clash/Mihomo 订阅链接或导入本地 YAML 文件。',
        '**连接使用**：点击「首页」主连接开关即可启用代理分流。',
      ],
      tipsSummary: '各平台使用与排障贴士（Windows / Android / macOS & Linux / iOS）',
      platformTips: [
        (
          'Windows',
          '日常可直接使用免提权 **系统代理模式**；如需 **TUN 虚拟网卡** 全局接管，请右键「以管理员身份运行」。在 `wmimo.exe` 同级目录新建 `portable` 文件夹或在设置开启便携模式即可绿色运行。',
        ),
        (
          'Android',
          '建议在系统设置中将 Wmimo 设为「忽略电池优化」以保证后台断流防护；进入 **分应用代理** 修改黑白名单后返回或在页面内应用即可热生效，无需断开内核重连。',
        ),
        (
          'macOS / Linux',
          '开启 TUN 虚拟网卡首次需要授予核心服务权限，应用已通过安全的环境变量与标准输入通道调用系统授权弹窗。',
        ),
        (
          'iOS',
          '发布产物为未签名 `.ipa`，可通过 TrollStore 巨魔或个人开发者证书重签安装，详见 [docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)。',
        ),
      ],
      buildTitle: '本地源码编译',
      prereqHeading: '前置依赖',
      prereqs: [
        '[Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) 与 [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)',
        '目标平台编译器：Visual Studio 2022 C++（Windows）、Xcode（macOS/iOS）、GTK3/Clang/CMake/Ninja（Linux）、Android SDK & NDK（Android）',
      ],
      commandsHeading: '常用命令',
      benchmarksTitle: '性能基准与自动化验证',
      benchmarkBullets: [
        '**高吞吐订阅解析**：`~30,670 节点/秒` —— 后台 Isolate 解析与归类 `5,000` 个多协议节点仅耗时 `~163 ms`，不阻塞 UI 渲染帧。',
        '**极速格式探测**：`SubscriptionConverter.isClashYaml` 在 `1,000` 节点规模下仅耗时 `~1.4 ms`。',
        '**9 国语言零缺失**：**9/9 语种 × 898 词条 = 100.0% 覆盖率**，且 9 语种《隐私政策》与《用户协议》全部对齐。',
        '**本地一键验证**：依次运行 `flutter analyze --no-pub lib/ third_party/libclash_vpn_service/lib/ test/`、`flutter test test/benchmark_profile_scale_test.dart`、`flutter test test/i18n_integrity_test.dart` 与 `dart run tool/verify_i18n.dart`。',
      ],
      benchmarksLinkText: '完整基准测试方法与硬件环境说明请参阅 [docs/BENCHMARKS.md](docs/BENCHMARKS.md)。',
      starHistoryHeading: 'Star 增长趋势图',
      securityTitle: '隐私承诺、安全校验与开源许可',
      securityBullets: [
        '**隐私零收集承诺**：所有路由、DNS 与诊断计算均在本机完成，无任何商业统计或追踪 SDK，详见 [assets/txts/privacy_policy_cn.txt](assets/txts/privacy_policy_cn.txt)。',
        '**官方产物验签**：请参阅 [SECURITY.md](SECURITY.md) 核对官方 Android APK SHA-256 签名证书指纹及 Wintun WHQL 签名说明。',
      ],
      licenseTitle: '开源协议',
      licenseIntro:
        '本项目依据 **GNU General Public License v3.0 (GPL-3.0-or-later)** 开源发布，详情见 [LICENSE](LICENSE)。',
      licenseBullets: [
        '**Rust Workspace 模块**：独立使用时采用 [MIT](rust/LICENSE-MIT) OR [Apache-2.0](rust/LICENSE-APACHE) 双重许可；随 Wmimo 编译分发时受 GPL-3.0 约束。',
        '**第三方组件与核心声明**：请参阅 [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) 与 [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)。',
      ],
      ackTitle: '致谢',
      ackBullets: [
        '**[GooRingX (vowe)](https://github.com/GooRingX)** —— 感谢杰出的开源贡献、架构见解与设计灵感。',
        '**[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** —— 感谢强大的跨平台代理内核与协议支持。',
        '**[Flutter](https://flutter.dev/)** —— 感谢现代化的跨平台 UI 框架与社区。',
      ],
      communityTitle: '社区交流与支持',
      labelWebsite: '官方网站',
      labelTelegram: 'Telegram 官方频道',
      labelEmail: '开发者邮箱',
      labelIssues: '问题反馈 (Issues)',
    ),

    // 3. Traditional Chinese (README.zh-TW.md)
    const _ReadmeSpec(
      fileName: 'README.zh-TW.md',
      tagline: '新一代全平台 Clash / Mihomo 桌面與行動端代理用戶端',
      subtitle:
          '基於 Flutter 與 Mihomo (v1.19.34) 核心打造。堅持資料零遙測與純本機執行，結合多跳鏈式代理、並發鏈路診斷、即時波形測速與作業系統級原生整合。',
      navDownloads: '下載發布版',
      navPlatforms: '支援平台',
      navFeatures: '核心能力',
      navArchitecture: '技術架構',
      navQuickStart: '快速上手',
      navBuild: '原始碼編譯',
      navSecurity: '安全與授權',
      navCommunity: '社群回饋',
      lightCaption: '淺色主題 (Light)',
      darkCaption: '深色主題 (Dark)',
      previewNote:
          '18px 極簡微卡片儀表板 · 即時貝茲流量曲線 · TUN / 系統代理雙引擎 · 支援自訂首頁卡片與螢幕自動旋轉',
      platformsTitle: '支援平台與發布產物清單',
      colPlatform: '作業系統',
      colArch: '支援架構',
      colPackages: '官方發布套件',
      colHighlights: '平台專屬特性',
      platformRows: [
        (
          '**Windows**',
          '`x64`, `arm64`',
          '安裝程式 (`.exe`)、可攜壓縮檔 (`.zip`)',
          '免權限系統代理、WHQL 簽章 Wintun TUN（系統管理員）、UWP 迴環豁免、深淺色同步系統匣與即時網速、全域快速鍵',
        ),
        (
          '**macOS**',
          '`Universal` (`arm64` + `x64`)',
          '`.dmg` 映像檔、可攜壓縮檔 (`.zip`)',
          '安全服務授權與 TUN、系統代理、自適應選單列圖示、iCloud Drive 雲端同步、全域快速鍵',
        ),
        (
          '**Linux**',
          '`x64`, `arm64`',
          '`.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz`',
          '`setcap` / 服務授權 TUN 模式、系統代理、GTK3 桌面整合、全域快速鍵',
        ),
        (
          '**Android**',
          '`arm64-v8a`, `armeabi-v7a`, `x86_64`',
          '分架構 APK 與通用版 `.apk`',
          '不斷線分應用代理熱切換（黑白名單 + 免授權預設）、電池最佳化保活偵測、快速設定磚、前景通知控制',
        ),
        (
          '**iOS**',
          '`arm64`',
          '未簽章 `.ipa`（TrollStore / 側載）',
          'Network Extension VPN 通道、iCloud Drive 備份同步（詳見 [Apple 開發指南](docs/APPLE_DEVELOPMENT.md)）',
        ),
      ],
      platformReleaseNote:
          '請至 [GitHub Releases](https://github.com/aimy1/Wmimo/releases) 下載對應安裝檔，並參考 [SECURITY.md](SECURITY.md) 驗證 Android APK SHA-256 憑證指紋與 Wintun 簽章。',
      featuresTitle: '核心能力矩陣與特性詳解',
      colModule: '功能模組',
      colCapability: '核心能力摘要',
      featureMatrix: [
        (
          '**Mihomo 路由核心**',
          '`v1.19.34` • 涵蓋 SS、VMess、VLESS (Reality)、Trojan、Hysteria 1/2、TUIC v5、WireGuard、SSH、Direct；獨立 Isolate 解析訂閱（5,000 節點僅 ~163 ms）',
        ),
        (
          '**多跳鏈式代理 `[Beta]`**',
          '採用 **`dialer-proxy`** 鏈式編排（入口策略/節點 ➔ 任意中繼跳 ➔ 出口落地），支援拖曳換序、防重複節點檢查，`chain_proxies.json` 獨立持久化',
        ),
        (
          '**行動端分應用代理**',
          '白名單空清單防漏流保護；VPN 執行期間平滑熱替換無需重啟核心；應用清單與 Launcher 去重合併及免授權常用預設',
        ),
        (
          '**網路鏈路診斷 (`NetCheck`)**',
          '兩階段 5 步並發體檢（過濾虛擬 TUN 網卡、DNS 與 Fake-IP 偵測、核心連接埠、代理/TUN 對齊、真實出口 204 握手含備援）+ 並發單網域排查 + 一鍵自癒',
        ),
        (
          '**內建網路測速 (`SpeedTest`)**',
          '多執行緒 HTTP 下載/上傳測速、穩態 Ping 與抖動採樣、即時雙線頻寬波形圖、場景評級（電競/8K/視訊）、並發節點延遲標記與代理前置檢查',
        ),
        (
          '**備份與雲端同步**',
          '支援 WebDAV、iCloud Drive、本機與 URL `.zip` 匯出還原；納入 `chain_proxies.json`，具備預解壓暫存驗證與 Zip-Slip 防護',
        ),
        (
          '**微卡片 UI 與監控**',
          '淺色/深黑雙主題、首頁卡片管理、預設開啟螢幕自動旋轉、1m–60m 貝茲流量波紋圖、出口 IP 歸屬與隱私遮罩卡片',
        ),
        (
          '**零遙測與 9 國語言**',
          '零廣告與分析遙測 SDK，純本機運作；**9 語言 × 898 詞條 100% 對齊**，並內建全 9 語系獨立《隱私權政策》與《使用者協議》',
        ),
      ],
      featureDetails: [
        (
          '智慧路由、多跳鏈式代理與診斷',
          [
            '**雙引擎與模式切換**：支援 **規則 (Rule)** / **全域 (Global)** / **直連 (Direct)** 快速切換，自由選用 **TUN** 或免權限 **系統代理**。',
            '**多跳鏈式代理 `[Beta]`**：透過 `dialer-proxy` 建立多跳拓撲，代理面板頂列即時顯示已啟用鏈數角標。',
            '**並發診斷與測速可視化**：精準定位 DNS 汙染、連接埠衝突與殘留系統代理，並以即時上下行波形圖展現真實吞吐能力。',
          ],
        ),
        (
          '跨平台設定階層與原子備份安全',
          [
            '**分平台設定整理**：四大分組清晰歸納；桌面端聚焦全域快速鍵與資料目錄，Android 端提供電池最佳化與系統權限管理捷徑。',
            '**原子安全還原**：還原前先於暫存目錄驗證解壓完整性，確認無誤後再停止核心並覆蓋設定。',
            '**雙通道自動更新**：支援 `stable` 與 `beta` 通道切換並進行 SHA-256 雜湊驗證。',
          ],
        ),
      ],
      archTitle: '技術堆疊與專案架構',
      colLayer: '架構層',
      colTech: '技術與職責',
      colPath: '路徑',
      archRows: [
        ('**UI 與頁面層**', 'Flutter (`>= 3.35.0`)、微卡片儀表板、Canvas 圖表與響應式版面', '[`lib/screens/`](lib/screens/)'),
        ('**核心模組與狀態**', '`SettingManager`、`ChainProxyManager`、`ProfileManager` 與 Isolate 解析器', '[`lib/app/`](lib/app/)'),
        ('**VPN 與原生橋接**', '跨平台服務封裝、Android Kotlin (`WmimoVpnService.kt`)、macOS/Linux 授權', '[`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/)、[`android/`](android/)'),
        ('**Rust 工作區**', '高效能原生工具組件', '[`rust/`](rust/)'),
        ('**多語言與法務資源**', 'Slang 強型別翻譯（9 語系 × 898 詞條）與隱私權/條款檔案', '[`lib/i18n/`](lib/i18n/)、[`assets/txts/`](assets/txts/)'),
        ('**CI、打包與測試**', 'GitHub Actions 多平台自動發行流程與測試套件', '[`.github/workflows/release.yml`](.github/workflows/release.yml)、[`test/`](test/)'),
      ],
      quickStartTitle: '快速上手',
      quickSteps: [
        '**下載安裝**：從 [GitHub Releases](https://github.com/aimy1/Wmimo/releases) 下載對應平台的安裝套件。',
        '**匯入設定檔**：於「訂閱設定」貼上 Clash/Mihomo 訂閱連結或匯入本機 YAML。',
        '**啟用連線**：點擊「首頁」主開關即可開始安全分流。',
      ],
      tipsSummary: '各平台設定提示（Windows / Android / macOS & Linux / iOS）',
      platformTips: [
        ('Windows', '免權限可直接用系統代理；TUN 模式需右鍵「以系統管理員身分執行」。於同目錄建立 `portable` 資料夾即啟用可攜模式。'),
        ('Android', '建議允許忽略電池最佳化確保背景穩定運作；分應用代理支援執行期熱套用。'),
        ('macOS / Linux', 'TUN 模式會透過安全的標準輸入與系統授權對話框請求服務權限。'),
        ('iOS', '提供未簽章 `.ipa` 供 TrollStore 或自簽安裝，詳見 [docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)。'),
      ],
      buildTitle: '從原始碼編譯',
      prereqHeading: '環境需求',
      prereqs: [
        '[Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) 與 [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)',
        '各平台建置工具鏈（VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK & NDK）',
      ],
      commandsHeading: '建置指令',
      benchmarksTitle: '效能基準與自動化驗證',
      benchmarkBullets: [
        '**訂閱解析吞吐**：`~30,670 節點/秒`（背景 Isolate 解析 `5,000` 節點僅需 `~163 ms`）。',
        '**格式快速判斷**：`isClashYaml` 檢測 `1,000` 節點僅需 `~1.4 ms`。',
        '**i18n 完整度**：**9 語系 × 898 詞條 = 100.0%**，且 9 語系《隱私權政策》全數齊全。',
        '**本機驗證**：執行 `flutter analyze --no-pub lib/ third_party/libclash_vpn_service/lib/ test/`、`flutter test test/benchmark_profile_scale_test.dart`、`flutter test test/i18n_integrity_test.dart` 與 `dart run tool/verify_i18n.dart`。',
      ],
      benchmarksLinkText: '完整基準報告請參閱 [docs/BENCHMARKS.md](docs/BENCHMARKS.md)。',
      starHistoryHeading: 'Star 成長趨勢圖',
      securityTitle: '隱私保護、安全驗證與授權條款',
      securityBullets: [
        '**零資料蒐集**：純本機執行且無任何商業追蹤 SDK，詳見 [assets/txts/privacy_policy_zh_tw.txt](assets/txts/privacy_policy_zh_tw.txt)。',
        '**發行檔驗證**：Android APK SHA-256 指紋與 Wintun WHQL 簽章說明請見 [SECURITY.md](SECURITY.md)。',
      ],
      licenseTitle: '開源授權',
      licenseIntro: '本專案採 **GNU General Public License v3.0 (GPL-3.0-or-later)** 授權，詳見 [LICENSE](LICENSE)。',
      licenseBullets: [
        '**Rust Workspace**：獨立使用採 [MIT](rust/LICENSE-MIT) / [Apache-2.0](rust/LICENSE-APACHE)，隨 Wmimo 散佈時受 GPL-3.0 約束。',
        '**第三方與核心授權**：詳見 [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) 與 [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)。',
      ],
      ackTitle: '致謝',
      ackBullets: [
        '**[GooRingX (vowe)](https://github.com/GooRingX)** —— 感謝開源貢獻與設計靈感。',
        '**[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** —— 感謝高效能跨平台代理核心。',
        '**[Flutter](https://flutter.dev/)** —— 感謝現代跨平台框架支援。',
      ],
      communityTitle: '社群與回饋',
      labelWebsite: '官方網站',
      labelTelegram: 'Telegram 官方頻道',
      labelEmail: '作者信箱',
      labelIssues: '問題回報',
    ),

    // 4. Japanese (README.ja.md)
    const _ReadmeSpec(
      fileName: 'README.ja.md',
      tagline: '次世代クロスプラットフォーム Clash / Mihomo GUI プロキシクライアント',
      subtitle:
          'Flutter と Mihomo コア (v1.19.34) により構築。テレメトリゼロの完全ローカル動作に加え、マルチホップチェーン、並列ネットワーク診断、リアルタイム波形速度測定を搭載。',
      navDownloads: 'ダウンロード',
      navPlatforms: '対応OS',
      navFeatures: '主要機能',
      navArchitecture: 'アーキテクチャ',
      navQuickStart: 'クイックスタート',
      navBuild: 'ビルド',
      navSecurity: 'セキュリティ',
      navCommunity: 'コミュニティ',
      lightCaption: 'ライトモード',
      darkCaption: 'ダークモード',
      previewNote:
          '18px マイクロカードUI · ベジェ曲線トラフィックモニター · TUN / システムプロキシ両対応 · ホームカードカスタマイズ',
      platformsTitle: '対応プラットフォームと配布パッケージ',
      colPlatform: 'OS',
      colArch: 'アーキテクチャ',
      colPackages: '配布形式',
      colHighlights: '主なプラットフォーム機能',
      platformRows: [
        ('**Windows**', '`x64`, `arm64`', 'インストーラー (`.exe`)、ポータブル (`.zip`)', '権限不要のシステムプロキシ、WHQL 署名 Wintun TUN、UWP ループバック免除、トレイ速度表示、グローバルホットキー'),
        ('**macOS**', '`Universal` (`arm64` + `x64`)', '`.dmg`、ポータブル (`.zip`)', '安全な特権ヘルパー/TUN、メニューバー適応アイコン、iCloud Drive 同期、グローバルホットキー'),
        ('**Linux**', '`x64`, `arm64`', '`.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz`', '`setcap` / サービス権限 TUN、システムプロキシ、GTK3 デスクトップ統合、グローバルホットキー'),
        ('**Android**', '`arm64-v8a`, `armeabi-v7a`, `x86_64`', 'ABI 分割 APK・ユニバーサル `.apk`', '無停止アプリ別プロキシホットスワップ、バッテリー最適化除外チェック、クイック設定タイル、フォアグラウンド通知'),
        ('**iOS**', '`arm64`', '未署名 `.ipa`（TrollStore / サイドロード）', 'Network Extension VPN トンネル・iCloud 同期（[Apple 開発ガイド](docs/APPLE_DEVELOPMENT.md)参照）'),
      ],
      platformReleaseNote:
          '公式バイナリは [GitHub Releases](https://github.com/aimy1/Wmimo/releases) から入手し、[SECURITY.md](SECURITY.md) の APK SHA-256 フィンガープリントで検証できます。',
      featuresTitle: '主要機能一覧',
      colModule: 'モジュール',
      colCapability: '概要',
      featureMatrix: [
        ('**Mihomo コア (`v1.19.34`)**', 'SS / VMess / VLESS Reality / Trojan / Hysteria 1/2 / TUIC v5 / WireGuard / SSH • Isolate 並列 YAML 解析（5,000 ノード ~163 ms）'),
        ('**マルチホップチェーン `[Beta]`**', '**`dialer-proxy`** ベースで任意の中継ホップを構成可能（ドラッグ並替・重複検証・`chain_proxies.json` 永続化）'),
        ('**アプリ別プロキシ (Android)**', '空ホワイトリストの通信漏れ防止、コア再起動なしのホットスワップ、Launcher 連携＆プリセット'),
        ('**ネットワーク診断 (`NetCheck`)**', '2段階5ステップ並列診断（仮想 TUN 除外、DNS/Fake-IP 判定、ポート・プロキシ整合、出口 204 テスト）+ ドメイン調査 + ワンクリック修復'),
        ('**速度測定 (`SpeedTest`)**', 'マルチストリーム計測、安定 Ping/Jitter、リアルタイム送受信波形グラフ、用途別評価（ゲーム/8K/通話）、CDN 遅延一括測定'),
        ('**バックアップと同期**', 'WebDAV / iCloud Drive / ZIP インポート・エクスポート（`chain_proxies.json` 含む一時展開検証 & Zip-Slip 防御）'),
        ('**UI・テレメトリ監視**', 'ライト/ダーク両テーマ、ホームカード管理、画面自動回転デフォルト有効、IP・ISP プライバシーマスク表示'),
        ('**プライバシー＆9言語対応**', '広告・追跡 SDK ゼロ、**9言語 × 898 キー（100%一致）**、9言語プライバシーポリシー搭載'),
      ],
      featureDetails: [
        (
          'ルーティング・診断・高速測定',
          [
            '**デュアルエンジン**: Rule / Global / Direct の即時切替と TUN / システムプロキシに対応。',
            '**可視化ツール群**: 並列診断パイプラインと波形グラフ付き速度測定で回線状態を正確に把握。',
          ],
        ),
      ],
      archTitle: '技術スタックと構成',
      colLayer: 'レイヤー',
      colTech: '技術 / 役割',
      colPath: 'ディレクトリ',
      archRows: [
        ('**UI / 画面**', 'Flutter (`>= 3.35.0`)、マイクロカード、Canvas グラフ', '[`lib/screens/`](lib/screens/)'),
        ('**コア状態管理**', '設定・チェーン・プロファイル管理、Isolate パーサー', '[`lib/app/`](lib/app/)'),
        ('**VPN / ネイティブ**', 'サービスラッパー、Android Kotlin (`WmimoVpnService.kt`)、OS 特権連携', '[`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/)、[`android/`](android/)'),
        ('**Rust クレート**', 'ネイティブユーティリティワークスペース', '[`rust/`](rust/)'),
        ('**i18n / ポリシー**', 'Slang 生成翻訳（9言語 × 898 キー）および規約文書', '[`lib/i18n/`](lib/i18n/)、[`assets/txts/`](assets/txts/)'),
      ],
      quickStartTitle: 'クイックスタート',
      quickSteps: [
        '**ダウンロード**: [GitHub Releases](https://github.com/aimy1/Wmimo/releases) から OS 用パッケージを入手。',
        '**プロファイル追加**: 「サブスクリプション」で URL またはローカル YAML をインポート。',
        '**接続**: ホーム画面のスイッチをオンにして通信を開始します。',
      ],
      tipsSummary: 'プラットフォーム別のヒント (Windows / Android / macOS・Linux / iOS)',
      platformTips: [
        ('Windows', '通常は権限不要のシステムプロキシ、TUN モードは管理者として実行してください。`portable` フォルダでポータブル動作に対応。'),
        ('Android', 'バッテリー最適化の除外設定を推奨。アプリ別プロキシは接続中も即時反映されます。'),
        ('iOS', '未署名 `.ipa` で配布（詳細は [docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)）。'),
      ],
      buildTitle: 'ソースからビルド',
      prereqHeading: '前提条件',
      prereqs: [
        '[Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) & [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)',
        '各 OS ビルドツール (VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK)',
      ],
      commandsHeading: 'ビルド手順',
      benchmarksTitle: 'ベンチマークと品質検証',
      benchmarkBullets: [
        '**サブスクリプション解析**: `~30,670 ノード/秒`（5,000 ノードを ~163 ms でバックグラウンド解析）。',
        '**多言語カバレッジ**: **9言語 × 898 キー = 100.0%**（[docs/BENCHMARKS.md](docs/BENCHMARKS.md)）。',
      ],
      benchmarksLinkText: '詳細手順: [docs/BENCHMARKS.md](docs/BENCHMARKS.md)',
      starHistoryHeading: 'Star 推移グラフ',
      securityTitle: 'セキュリティ・プライバシー・ライセンス',
      securityBullets: [
        '**データ収集ゼロ**: [assets/txts/privacy_policy_ja.txt](assets/txts/privacy_policy_ja.txt)',
        '**署名・証明書検証**: [SECURITY.md](SECURITY.md)',
      ],
      licenseTitle: 'ライセンス',
      licenseIntro: '**GNU General Public License v3.0 (GPL-3.0-or-later)** に基づき公開（[LICENSE](LICENSE)）。',
      licenseBullets: [
        'Rust クレート: 単体では [MIT](rust/LICENSE-MIT) / [Apache-2.0](rust/LICENSE-APACHE)、同梱配布時は GPL-3.0。',
        'サードパーティ表記: [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) / [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)',
      ],
      ackTitle: '謝辞',
      ackBullets: [
        '**[GooRingX (vowe)](https://github.com/GooRingX)**',
        '**[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**',
        '**[Flutter](https://flutter.dev/)**',
      ],
      communityTitle: 'コミュニティ',
      labelWebsite: '公式サイト',
      labelTelegram: 'Telegram チャンネル',
      labelEmail: 'メール',
      labelIssues: 'Issue トラッカー',
    ),

    // 5. Korean (README.ko.md)
    const _ReadmeSpec(
      fileName: 'README.ko.md',
      tagline: '차세대 크로스 플랫폼 Clash / Mihomo GUI 프록시 클라이언트',
      subtitle:
          'Flutter와 Mihomo 코어(v1.19.34) 기반으로 제작되었습니다. 데이터 수집 제로 원칙과 멀티홉 체인 프록시, 병렬 네트워크 진단, 실시간 파형 속도 측정을 제공합니다.',
      navDownloads: '다운로드',
      navPlatforms: '지원 플랫폼',
      navFeatures: '핵심 기능',
      navArchitecture: '아키텍처',
      navQuickStart: '빠른 시작',
      navBuild: '소스 빌드',
      navSecurity: '보안 및 라이선스',
      navCommunity: '커뮤니티',
      lightCaption: '라이트 모드',
      darkCaption: '다크 모드',
      previewNote:
          '18px 마이크로 카드 대시보드 · 실시간 베지어 트래픽 차트 · TUN / 시스템 프록시 듀얼 엔진',
      platformsTitle: '지원 플랫폼 및 릴리스 패키지',
      colPlatform: '플랫폼',
      colArch: '아키텍처',
      colPackages: '배포 형식',
      colHighlights: '주요 OS 통합 기능',
      platformRows: [
        ('**Windows**', '`x64`, `arm64`', '설치 파일(`.exe`), 포터블(`.zip`)', '비권한 시스템 프록시, WHQL Wintun TUN, UWP 루프백, 트레이 속도 및 테마 동기화, 전역 단축키'),
        ('**macOS**', '`Universal` (`arm64` + `x64`)', '`.dmg`, 포터블(`.zip`)', '안전한 서비스 권한 상승/TUN, 적응형 메뉴 막대 아이콘, iCloud Drive 동기화, 전역 단축키'),
        ('**Linux**', '`x64`, `arm64`', '`.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz`', '`setcap` / 서비스 TUN, 시스템 프록시, GTK3 데스크톱 통합, 전역 단축키'),
        ('**Android**', '`arm64-v8a`, `armeabi-v7a`, `x86_64`', 'ABI 분할 APK 및 유니버설 `.apk`', '무중단 앱별 프록시 핫스왑, 배터리 최적화 제외 확인, 빠른 설정 타일, 포그라운드 알림'),
        ('**iOS**', '`arm64`', '미서명 `.ipa` (TrollStore / 사이드로딩)', 'Network Extension VPN 및 iCloud 동기화 ([Apple 개발 가이드](docs/APPLE_DEVELOPMENT.md))'),
      ],
      platformReleaseNote:
          '[GitHub Releases](https://github.com/aimy1/Wmimo/releases)에서 다운로드하고 [SECURITY.md](SECURITY.md)에서 APK SHA-256 지문을 확인하세요.',
      featuresTitle: '핵심 기능 매트릭스',
      colModule: '모듈',
      colCapability: '핵심 기능',
      featureMatrix: [
        ('**Mihomo 라우팅 코어**', '`v1.19.34` • SS, VMess, VLESS Reality, Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH • Isolate YAML 파서 (`5,000`개 노드 `~163 ms`)'),
        ('**멀티홉 체인 프록시 `[Beta]`**', '**`dialer-proxy`** 기반 다단계 홉 구성, 드래그/스왑 순서 변경, 중복 검사, 구독 업데이트에도 유지되는 `chain_proxies.json`'),
        ('**모바일 앱별 프록시**', '빈 화이트리스트 누수 차단, 코어 재시작 없는 실시간 핫스왑, Launcher 통합 검색 및 무권한 프리셋'),
        ('**네트워크 진단 (`NetCheck`)**', '2단계 5항목 병렬 진단(가상 TUN 제외, DNS/Fake-IP 점검, 포트, 프록시/TUN, 출구 204 핸드셰이크) + 도메인 검사 + 원클릭 자동 복구'),
        ('**속도 측정 (`SpeedTest`)**', '다중 스트림 HTTP 속도 측정, 안정적 Ping/Jitter, 실시간 송수신 파형 그래프, 시나리오 등급, CDN 지연시간 배지'),
        ('**백업 및 동기화**', 'WebDAV, iCloud Drive, 로컬/URL `.zip` 백업(체인 프록시 포함, 임시 스테이징 검증 및 Zip-Slip 차단)'),
        ('**UI 및 모니터링**', '라이트/다크 테마, 홈 카드 관리, 화면 회전 기본 활성화, 1m–60m 트래픽 차트, 출구 IP 마스킹'),
        ('**개인정보 및 9개 언어**', '텔레메트리/광고 SDK 제로, **9개 언어 × 898개 키 100% 일치** 및 9개 언어 개인정보 처리방침'),
      ],
      featureDetails: [
        ('라우팅 · 진단 · 백업 안정성', [
          '**이중 프록시 엔진**: Rule / Global / Direct 모드와 TUN / 시스템 프록시 즉각 전환.',
          '**원자적 복원 검증**: 백업 복원 시 임시 폴더에서 압축 해제를 먼저 검증한 뒤 기존 설정을 안전하게 교체합니다.',
        ]),
      ],
      archTitle: '아키텍처 및 프로젝트 구조',
      colLayer: '계층',
      colTech: '역할',
      colPath: '경로',
      archRows: [
        ('**UI 및 화면**', 'Flutter (`>= 3.35.0`), 마이크로 카드 UI, Canvas 차트', '[`lib/screens/`](lib/screens/)'),
        ('**모듈 및 상태**', '설정/체인/프로필 관리자, Isolate 파서', '[`lib/app/`](lib/app/)'),
        ('**VPN 및 네이티브**', '서비스 브리지, Android Kotlin (`WmimoVpnService.kt`)', '[`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/), [`android/`](android/)'),
        ('**Rust 크레이트**', '네이티브 유틸리티 워크스페이스', '[`rust/`](rust/)'),
        ('**i18n 및 정책**', 'Slang 번역(9언어 × 898키) 및 개인정보 처리방침', '[`lib/i18n/`](lib/i18n/), [`assets/txts/`](assets/txts/)'),
      ],
      quickStartTitle: '빠른 시작',
      quickSteps: [
        '**다운로드**: [GitHub Releases](https://github.com/aimy1/Wmimo/releases)에서 OS 설치 파일을 받습니다.',
        '**구독 가져오기**: 구독 메뉴에 Clash/Mihomo 링크 또는 로컬 YAML을 추가합니다.',
        '**연결**: 홈 상단 스위치를 켜서 라우팅을 시작합니다.',
      ],
      tipsSummary: '플랫폼별 팁 (Windows / Android / macOS·Linux / iOS)',
      platformTips: [
        ('Windows', '일반 브라우징은 시스템 프록시, TUN 모드는 관리자 권한 실행이 필요합니다. `portable` 폴더 생성 시 포터블 모드로 동작합니다.'),
        ('Android', '배터리 최적화 제외 설정을 권장하며, 앱별 프록시는 연결 중에도 즉시 핫스왑 적용됩니다.'),
        ('iOS', '미서명 `.ipa`로 배포됩니다([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)).'),
      ],
      buildTitle: '소스에서 빌드',
      prereqHeading: '필수 환경',
      prereqs: [
        '[Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) & [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)',
        '플랫폼별 빌드 도구 (VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK)',
      ],
      commandsHeading: '빌드 명령어',
      benchmarksTitle: '성능 벤치마크 및 검증',
      benchmarkBullets: [
        '**구독 파싱**: `~30,670 노드/초` (백그라운드 Isolate에서 `5,000` 노드 `~163 ms` 처리).',
        '**국제화 커버리지**: **9개 언어 × 898개 키 = 100.0%** ([docs/BENCHMARKS.md](docs/BENCHMARKS.md)).',
      ],
      benchmarksLinkText: '자세한 방법론: [docs/BENCHMARKS.md](docs/BENCHMARKS.md)',
      starHistoryHeading: 'Star 히스토리',
      securityTitle: '보안, 개인정보 및 라이선스',
      securityBullets: [
        '**데이터 수집 제로**: [assets/txts/privacy_policy_ko.txt](assets/txts/privacy_policy_ko.txt)',
        '**인증서 및 서명 검증**: [SECURITY.md](SECURITY.md)',
      ],
      licenseTitle: '라이선스',
      licenseIntro: '**GNU General Public License v3.0 (GPL-3.0-or-later)** ([LICENSE](LICENSE)).',
      licenseBullets: [
        'Rust 크레이트: 단독 [MIT](rust/LICENSE-MIT) / [Apache-2.0](rust/LICENSE-APACHE), Wmimo 배포 시 GPL-3.0.',
        '서드파티 고지: [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md), [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)',
      ],
      ackTitle: '감사의 말',
      ackBullets: [
        '**[GooRingX (vowe)](https://github.com/GooRingX)**',
        '**[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**',
        '**[Flutter](https://flutter.dev/)**',
      ],
      communityTitle: '커뮤니티 및 피드백',
      labelWebsite: '공식 웹사이트',
      labelTelegram: 'Telegram 채널',
      labelEmail: '이메일',
      labelIssues: '이슈 트래커',
    ),

    // 6. Russian (README.ru.md)
    const _ReadmeSpec(
      fileName: 'README.ru.md',
      tagline: 'Кроссплатформенный GUI-клиент Clash / Mihomo нового поколения',
      subtitle:
          'Построен на Flutter и ядре Mihomo (v1.19.34). Нулевая телеметрия, многошаговые цепочки прокси, параллельная диагностика и замер скорости с живым графиком.',
      navDownloads: 'Скачать',
      navPlatforms: 'Платформы',
      navFeatures: 'Возможности',
      navArchitecture: 'Архитектура',
      navQuickStart: 'Быстрый старт',
      navBuild: 'Сборка',
      navSecurity: 'Безопасность',
      navCommunity: 'Сообщество',
      lightCaption: 'Светлая тема',
      darkCaption: 'Тёмная тема',
      previewNote:
          'Карточный интерфейс 18px · График трафика Безье · Двойной движок TUN / Системный прокси',
      platformsTitle: 'Поддерживаемые платформы и релизы',
      colPlatform: 'Платформа',
      colArch: 'Архитектура',
      colPackages: 'Форматы сборок',
      colHighlights: 'Ключевые возможности',
      platformRows: [
        ('**Windows**', '`x64`, `arm64`', 'Установщик (`.exe`), Portable (`.zip`)', 'Системный прокси без прав, Wintun WHQL TUN (Админ), UWP Loopback, трей со скоростью, горячие клавиши'),
        ('**macOS**', '`Universal` (`arm64` + `x64`)', '`.dmg`, Portable (`.zip`)', 'Безопасная авторизация сервиса/TUN, адаптивная иконка меню, iCloud Drive, глобальные клавиши'),
        ('**Linux**', '`x64`, `arm64`', '`.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz`', '`setcap` / TUN, системный прокси, GTK3 интерфейс, глобальные горячие клавиши'),
        ('**Android**', '`arm64-v8a`, `armeabi-v7a`, `x86_64`', 'Раздельные ABI и Universal `.apk`', 'Горячее переключение прокси по приложениям без рестарта ядра, контроль оптимизации батареи, плитка QS'),
        ('**iOS**', '`arm64`', 'Неподписанный `.ipa` (TrollStore / Sideload)', 'Network Extension VPN и синхронизация iCloud Drive ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md))'),
      ],
      platformReleaseNote:
          'Скачивайте релизы на [GitHub Releases](https://github.com/aimy1/Wmimo/releases) и проверяйте подписи APK (SHA-256) / Wintun по [SECURITY.md](SECURITY.md).',
      featuresTitle: 'Ключевые возможности',
      colModule: 'Модуль',
      colCapability: 'Описание',
      featureMatrix: [
        ('**Ядро Mihomo (`v1.19.34`)**', 'SS, VMess, VLESS Reality, Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH • Парсинг в Isolate (`5 000` узлов за `~163 мс`)'),
        ('**Многошаговые цепочки `[Beta]`**', 'Оркестрация **`dialer-proxy`** (вход ➔ транзит... ➔ выход), перетаскивание шагов, защита от дублей, хранение в `chain_proxies.json`'),
        ('**Прокси по приложениям (Android)**', 'Защита от утечки при пустом белом списке, горячая смена интерфейса VPN без перезапуска ядра, пресеты приложений'),
        ('**Диагностика (`NetCheck`)**', '5-этапный параллельный конвейер (фильтрация TUN-адаптеров, проверка DNS и Fake-IP, порты, прокси/TUN, рукопожатие) + автоисправление'),
        ('**Тест скорости (`SpeedTest`)**', 'Многопоточная загрузка/отдача HTTP, точный Ping/Jitter, живой график скорости, оценки сценариев и задержки серверов'),
        ('**Резервное копирование**', 'WebDAV, iCloud Drive, локальный/URL `.zip`, включая `chain_proxies.json`, предварительная распаковка в буфер и защита от Zip-Slip'),
        ('**UI и телеметрия**', 'Светлая/тёмная темы, менеджер карточек главной страницы, автоповорот включён по умолчанию, маска IP'),
        ('**Приватность и 9 языков**', 'Ноль трекеров и рекламных SDK, **9 языков × 898 ключей (100%)** и 9 локализованных политик конфиденциальности'),
      ],
      featureDetails: [
        ('Маршрутизация и надёжность', [
          '**Двойной движок**: мгновенное переключение Rule / Global / Direct в режимах TUN и системного прокси.',
          '**Атомарное восстановление**: проверка архива во временной папке перед заменой рабочих конфигураций.',
        ]),
      ],
      archTitle: 'Архитектура и структура кода',
      colLayer: 'Уровень',
      colTech: 'Назначение',
      colPath: 'Каталог',
      archRows: [
        ('**UI и экраны**', 'Flutter (`>= 3.35.0`), карточки, Canvas-графики', '[`lib/screens/`](lib/screens/)'),
        ('**Логика и состояние**', 'Менеджеры настроек/цепочек/профилей, парсер Isolate', '[`lib/app/`](lib/app/)'),
        ('**VPN и нативный слой**', 'Обёртка сервиса, Android Kotlin (`WmimoVpnService.kt`)', '[`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/), [`android/`](android/)'),
        ('**Rust Crates**', 'Нативные модули рабочего пространства', '[`rust/`](rust/)'),
        ('**i18n и документы**', 'Slang (9 языков × 898 ключей) и политики конфиденциальности', '[`lib/i18n/`](lib/i18n/), [`assets/txts/`](assets/txts/)'),
      ],
      quickStartTitle: 'Быстрый старт',
      quickSteps: [
        '**Установка**: скачайте сборку для вашей ОС с [GitHub Releases](https://github.com/aimy1/Wmimo/releases).',
        '**Импорт профиля**: добавьте ссылку подписки или YAML-файл в разделе подписок.',
        '**Подключение**: активируйте главный переключатель на главном экране.',
      ],
      tipsSummary: 'Советы по платформам (Windows / Android / macOS и Linux / iOS)',
      platformTips: [
        ('Windows', 'Системный прокси работает без прав администратора; для TUN запустите от имени администратора. Для портативного режима создайте папку `portable`.'),
        ('Android', 'Рекомендуется исключить Wmimo из оптимизации батареи; изменения правил по приложениям применяются на лету.'),
        ('iOS', 'Распространяется как неподписанный `.ipa` ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)).'),
      ],
      buildTitle: 'Сборка из исходников',
      prereqHeading: 'Требования',
      prereqs: [
        '[Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) и [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)',
        'Инструменты сборки платформы (VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK)',
      ],
      commandsHeading: 'Команды',
      benchmarksTitle: 'Производительность и тесты',
      benchmarkBullets: [
        '**Парсинг подписок**: `~30 670 узлов/с` (`5 000` узлов за `~163 мс` в Isolate).',
        '**Покрытие i18n**: **9/9 языков × 898 ключей = 100.0%** ([docs/BENCHMARKS.md](docs/BENCHMARKS.md)).',
      ],
      benchmarksLinkText: 'Подробный отчёт: [docs/BENCHMARKS.md](docs/BENCHMARKS.md).',
      starHistoryHeading: 'История звёзд (Star History)',
      securityTitle: 'Безопасность, приватность и лицензия',
      securityBullets: [
        '**Нулевой сбор данных**: [assets/txts/privacy_policy_ru.txt](assets/txts/privacy_policy_ru.txt)',
        '**Проверка отпечатков**: [SECURITY.md](SECURITY.md)',
      ],
      licenseTitle: 'Лицензия',
      licenseIntro: '**GNU General Public License v3.0 (GPL-3.0-or-later)** ([LICENSE](LICENSE)).',
      licenseBullets: [
        'Rust Crates: [MIT](rust/LICENSE-MIT) / [Apache-2.0](rust/LICENSE-APACHE) отдельно, GPL-3.0 в составе Wmimo.',
        'Сторонние компоненты: [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md), [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)',
      ],
      ackTitle: 'Благодарности',
      ackBullets: [
        '**[GooRingX (vowe)](https://github.com/GooRingX)**',
        '**[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**',
        '**[Flutter](https://flutter.dev/)**',
      ],
      communityTitle: 'Сообщество',
      labelWebsite: 'Официальный сайт',
      labelTelegram: 'Telegram-канал',
      labelEmail: 'Почта автора',
      labelIssues: 'Трекер задач',
    ),

    // 7. Spanish (README.es.md)
    const _ReadmeSpec(
      fileName: 'README.es.md',
      tagline: 'Cliente Proxy Multiplataforma Clash / Mihomo de Nueva Generación',
      subtitle:
          'Desarrollado con Flutter y el núcleo Mihomo (v1.19.34). Ejecución estrictamente local sin telemetría, proxy en cadena multisalto, diagnóstico concurrente y test de velocidad con gráfico en vivo.',
      navDownloads: 'Descargar',
      navPlatforms: 'Plataformas',
      navFeatures: 'Funciones',
      navArchitecture: 'Arquitectura',
      navQuickStart: 'Inicio Rápido',
      navBuild: 'Compilar',
      navSecurity: 'Seguridad',
      navCommunity: 'Comunidad',
      lightCaption: 'Modo Claro',
      darkCaption: 'Modo Oscuro',
      previewNote:
          'Tarjetas minimalistas de 18px · Gráfico Bezier en vivo · Motor dual TUN y Proxy del Sistema',
      platformsTitle: 'Plataformas Compatibles y Paquetes',
      colPlatform: 'Plataforma',
      colArch: 'Arquitectura',
      colPackages: 'Paquetes Oficiales',
      colHighlights: 'Funciones Destacadas',
      platformRows: [
        ('**Windows**', '`x64`, `arm64`', 'Instalador (`.exe`), Portable (`.zip`)', 'Proxy del sistema sin elevación, Wintun TUN firmado WHQL (Admin), exención UWP, bandeja adaptable, atajos globales'),
        ('**macOS**', '`Universal` (`arm64` + `x64`)', '`.dmg`, Portable (`.zip`)', 'Autorización segura de servicio/TUN, icono en barra de menú, iCloud Drive, atajos globales'),
        ('**Linux**', '`x64`, `arm64`', '`.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz`', '`setcap` / TUN, Proxy del sistema, interfaz GTK3, atajos globales'),
        ('**Android**', '`arm64-v8a`, `armeabi-v7a`, `x86_64`', 'APKs por ABI y Universal `.apk`', 'Proxy por App en caliente sin reiniciar núcleo, optimización de batería, ajuste rápido QS'),
        ('**iOS**', '`arm64`', '`.ipa` sin firmar (TrollStore / Sideload)', 'Túnel VPN Network Extension y sincronización iCloud ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md))'),
      ],
      platformReleaseNote:
          'Descargue los binarios desde [GitHub Releases](https://github.com/aimy1/Wmimo/releases) y verifique las firmas APK (SHA-256) y Wintun en [SECURITY.md](SECURITY.md).',
      featuresTitle: 'Matriz de Capacidades y Características',
      colModule: 'Módulo',
      colCapability: 'Capacidades Clave',
      featureMatrix: [
        ('**Núcleo Mihomo (`v1.19.34`)**', 'SS, VMess, VLESS Reality, Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH • Análisis en Isolate (`5,000` nodos en `~163 ms`)'),
        ('**Proxy en Cadena `[Beta]`**', 'Basado en **`dialer-proxy`** multisalto, reordenamiento de saltos, validación antiduplicados, persistencia en `chain_proxies.json`'),
        ('**Proxy por App (Android)**', 'Protección ante lista blanca vacía, intercambio en vivo sin reiniciar Mihomo, preajustes sin permisos adicionales'),
        ('**Diagnóstico (`NetCheck`)**', 'Pipeline concurrente de 5 pasos (filtra adaptadores TUN, DNS/Fake-IP, puertos, proxy/TUN, nodo activo) + consulta de dominio y autorreparación'),
        ('**Test de Velocidad (`SpeedTest`)**', 'Descarga/subida multihilo HTTP, Ping/Jitter estable, gráfico de ondas en vivo, calificación por uso y latencia de servidores CDN'),
        ('**Copias y Sincronización**', 'WebDAV, iCloud Drive, exportación/restauración `.zip` con `chain_proxies.json`, verificación previa y protección Zip-Slip'),
        ('**UI Personalizable**', 'Temas claro/oscuro, gestor de tarjetas en inicio, rotación automática habilitada por defecto, máscara de IP'),
        ('**Privacidad e Idiomas**', 'Cero SDKs de telemetría/publicidad; **9 idiomas × 898 claves (100%)** y 9 políticas de privacidad locales'),
      ],
      featureDetails: [
        ('Enrutamiento y Seguridad', [
          '**Motor Dual**: Cambio instantáneo entre Reglas / Global / Directo usando TUN o Proxy del Sistema.',
          '**Restauración Segura**: Comprueba la integridad del archivo ZIP en una carpeta temporal antes de sobrescribir configuraciones.',
        ]),
      ],
      archTitle: 'Arquitectura del Proyecto',
      colLayer: 'Capa',
      colTech: 'Responsabilidad',
      colPath: 'Ubicación',
      archRows: [
        ('**Interfaz UI**', 'Flutter (`>= 3.35.0`), tarjetas y gráficos Canvas', '[`lib/screens/`](lib/screens/)'),
        ('**Estado y Módulos**', 'Gestores de configuración, cadenas y perfiles', '[`lib/app/`](lib/app/)'),
        ('**VPN y Nativo**', 'Servicio multiplataforma, Android Kotlin (`WmimoVpnService.kt`)', '[`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/), [`android/`](android/)'),
        ('**Rust Workspace**', 'Crates nativos auxiliares', '[`rust/`](rust/)'),
        ('**i18n y Textos Legales**', 'Slang (9 idiomas × 898 claves) y políticas de privacidad', '[`lib/i18n/`](lib/i18n/), [`assets/txts/`](assets/txts/)'),
      ],
      quickStartTitle: 'Inicio Rápido',
      quickSteps: [
        '**Descargar**: Obtenga el instalador en [GitHub Releases](https://github.com/aimy1/Wmimo/releases).',
        '**Importar Suscripción**: Pegue su enlace Clash/Mihomo o archivo YAML en Suscripciones.',
        '**Conectar**: Active el interruptor principal en la vista general.',
      ],
      tipsSummary: 'Notas por Plataforma (Windows / Android / macOS y Linux / iOS)',
      platformTips: [
        ('Windows', 'El proxy del sistema no requiere privilegios; ejecute como administrador para modo TUN. Use la carpeta `portable` para modo portátil.'),
        ('Android', 'Excluya Wmimo de la optimización de batería; los cambios de Proxy por App se aplican en vivo.'),
        ('iOS', 'Distribuido como `.ipa` sin firmar ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)).'),
      ],
      buildTitle: 'Compilar desde el Código Fuente',
      prereqHeading: 'Requisitos',
      prereqs: [
        '[Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) y [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)',
        'Herramientas nativas (VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK)',
      ],
      commandsHeading: 'Comandos',
      benchmarksTitle: 'Rendimiento y Verificación',
      benchmarkBullets: [
        '**Análisis de nodos**: `~30,670 nodos/s` (`5,000` nodos en `~163 ms` vía Isolate).',
        '**Cobertura i18n**: **9/9 idiomas × 898 claves = 100.0%** ([docs/BENCHMARKS.md](docs/BENCHMARKS.md)).',
      ],
      benchmarksLinkText: 'Metodología completa en [docs/BENCHMARKS.md](docs/BENCHMARKS.md).',
      starHistoryHeading: 'Historial de Estrellas',
      securityTitle: 'Seguridad, Privacidad y Licencia',
      securityBullets: [
        '**Cero Recopilación de Datos**: [assets/txts/privacy_policy_es.txt](assets/txts/privacy_policy_es.txt)',
        '**Autenticidad de Binarios**: [SECURITY.md](SECURITY.md)',
      ],
      licenseTitle: 'Licencia',
      licenseIntro: 'Bajo licencia **GNU General Public License v3.0 (GPL-3.0-or-later)** ([LICENSE](LICENSE)).',
      licenseBullets: [
        'Rust Crates: [MIT](rust/LICENSE-MIT) / [Apache-2.0](rust/LICENSE-APACHE) independientes; GPL-3.0 junto con Wmimo.',
        'Componentes de terceros: [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md), [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)',
      ],
      ackTitle: 'Agradecimientos',
      ackBullets: [
        '**[GooRingX (vowe)](https://github.com/GooRingX)**',
        '**[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**',
        '**[Flutter](https://flutter.dev/)**',
      ],
      communityTitle: 'Comunidad y Soporte',
      labelWebsite: 'Sitio Web',
      labelTelegram: 'Canal de Telegram',
      labelEmail: 'Correo',
      labelIssues: 'Reportar Problemas',
    ),

    // 8. Arabic (README.ar.md)
    const _ReadmeSpec(
      fileName: 'README.ar.md',
      tagline: 'عميل وكيل Clash / Mihomo متعدد المنصات من الجيل الجديد',
      subtitle:
          'مبني باستخدام Flutter ونواة Mihomo (v1.19.34). تنفيذ محلي بالكامل بدون تتبع، مع وكيل متسلسل متعدد القفزات، وتشخيص متزامن للشبكة، واختبار سرعة برسم بياني حي.',
      navDownloads: 'التحميل',
      navPlatforms: 'المنصات',
      navFeatures: 'المميزات',
      navArchitecture: 'البنية',
      navQuickStart: 'البدء السريع',
      navBuild: 'البناء',
      navSecurity: 'الأمان والترخيص',
      navCommunity: 'المجتمع',
      lightCaption: 'الوضع الفاتح',
      darkCaption: 'الوضع الداكن',
      previewNote:
          'تصميم بطاقات 18px · رسم بياني حي لحركة البيانات · محرك مزدوج TUN ووكيل النظام',
      platformsTitle: 'المنصات المدعومة وحزم الإصدار',
      colPlatform: 'النظام',
      colArch: 'المعمارية',
      colPackages: 'حزم التنزيل',
      colHighlights: 'أبرز المزايا',
      platformRows: [
        ('**Windows**', '`x64`, `arm64`', 'مثبت (`.exe`)، نسخة محمولة (`.zip`)', 'وكيل نظام بدون صلاحيات، Wintun WHQL TUN (مسؤول)، أداة UWP، شريط مهام متكيف، اختصارات عامة'),
        ('**macOS**', '`Universal` (`arm64` + `x64`)', '`.dmg`، محمولة (`.zip`)', 'تفويض خدمة آمن/TUN، أيقونة شريط قوائم متكيفة، مزامنة iCloud Drive، اختصارات عامة'),
        ('**Linux**', '`x64`, `arm64`', '`.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz`', '`setcap` / TUN، وكيل النظام، واجهة GTK3، اختصارات عامة'),
        ('**Android**', '`arm64-v8a`, `armeabi-v7a`, `x86_64`', 'ملفات APK حسب المعمارية ونسخة شاملة `.apk`', 'تبديل فوري لوكيل التطبيقات دون إعادة تشغيل النواة، استثناء البطارية، لوحة الإعدادات السريعة'),
        ('**iOS**', '`arm64`', 'ملف `.ipa` غير موقع (TrollStore / Sideload)', 'نفق Network Extension VPN ومزامنة iCloud ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md))'),
      ],
      platformReleaseNote:
          'حمّل الإصدارات من [GitHub Releases](https://github.com/aimy1/Wmimo/releases) وتحقق من بصمات APK SHA-256 وWintun في [SECURITY.md](SECURITY.md).',
      featuresTitle: 'مصفوفة القدرات والمميزات الأساسية',
      colModule: 'الوحدة',
      colCapability: 'أبرز القدرات',
      featureMatrix: [
        ('**نواة Mihomo (`v1.19.34`)**', 'SS, VMess, VLESS Reality, Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH • تحليل عبر Isolate (`5,000` عقدة في `~163 ms`)'),
        ('**الوكيل المتسلسل `[Beta]`**', 'يعتمد على **`dialer-proxy`** متعدد القفزات، إعادة ترتيب القفزات، منع التكرار، حفظ مستقل في `chain_proxies.json`'),
        ('**وكيل التطبيقات (Android)**', 'حماية من تسرب القائمة البيضاء الفارغة، تحديث فوري أثناء تشغيل VPN، قوائم تطبيقات جاهزة بدون أذونات إضافية'),
        ('**تشخيص الشبكة (`NetCheck`)**', 'فحص متزامن من 5 مراحل (تصفية محولات TUN، فحص DNS وFake-IP، المنافذ، الوكيل/TUN، العقدة النشطة) + إصلاح تلقائي بضغطة واحدة'),
        ('**اختبار السرعة (`SpeedTest`)**', 'تحميل/رفع متعدد المسارات، قياس Ping/Jitter دقيق، منحنى سرعة حي، تقييم الاستخدام، وفحص زمن استجابة الخوادم'),
        ('**النسخ الاحتياطي والمزامنة**', 'WebDAV وiCloud Drive وتصدير/استيراد `.zip` مع `chain_proxies.json`، استخراج تجريبي آمن وحماية Zip-Slip'),
        ('**الواجهة والمراقبة**', 'الوضع الفاتح والداكن، إدارة بطاقات الرئيسية، تدوير الشاشة مفعّل افتراضياً، إخفاء عنوان IP'),
        ('**الخصوصية و9 لغات**', 'بدون أي حزم تتبع أو إعلانات؛ **9 لغات × 898 مفتاحاً (100%)** مع 9 سياسات خصوصية مترجمة'),
      ],
      featureDetails: [
        ('التوجيه والنسخ الآمن', [
          '**المحرك المزدوج**: التبديل الفوري بين القواعد والشامل والمباشر عبر TUN أو وكيل النظام.',
          '**الاستعادة الآمنة**: فحص سلامة الأرشيف في مجلد مؤقت قبل استبدال الإعدادات الحالية.',
        ]),
      ],
      archTitle: 'البنية التقنية للمشروع',
      colLayer: 'الطبقة',
      colTech: 'الدور والتقنية',
      colPath: 'المسار',
      archRows: [
        ('**الواجهة والشاشات**', 'Flutter (`>= 3.35.0`)، بطاقات، رسوم Canvas', '[`lib/screens/`](lib/screens/)'),
        ('**المنطق والإدارة**', 'مديرو الإعدادات والسلاسل والاشتراكات', '[`lib/app/`](lib/app/)'),
        ('**VPN والطبقة الأصلية**', 'وسيط الخدمة، Android Kotlin (`WmimoVpnService.kt`)', '[`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/), [`android/`](android/)'),
        ('**حزم Rust**', 'وحدات أصلية عالية الأداء', '[`rust/`](rust/)'),
        ('**الترجمة والوثائق**', 'Slang (9 لغات × 898 مفتاحاً) والسياسات', '[`lib/i18n/`](lib/i18n/), [`assets/txts/`](assets/txts/)'),
      ],
      quickStartTitle: 'البدء السريع',
      quickSteps: [
        '**التنزيل**: احصل على حزمة نظامك من [GitHub Releases](https://github.com/aimy1/Wmimo/releases).',
        '**استيراد الاشتراك**: أضف رابط Clash/Mihomo أو ملف YAML من قسم الاشتراكات.',
        '**الاتصال**: فعّل المفتاح الرئيسي في الواجهة الرئيسية.',
      ],
      tipsSummary: 'إرشادات المنصات (Windows / Android / macOS وLinux / iOS)',
      platformTips: [
        ('Windows', 'يعمل وكيل النظام بدون صلاحيات مسؤول؛ يتطلب وضع TUN التشغيل كمسؤول. أنشئ مجلد `portable` للوضع المحمول.'),
        ('Android', 'يُنصح باستثناء التطبيق من تحسين البطارية؛ تغييرات وكيل التطبيقات تُطبّق فوراً.'),
        ('iOS', 'يتوفر كملف `.ipa` غير موقع ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)).'),
      ],
      buildTitle: 'البناء من المصدر',
      prereqHeading: 'المتطلبات',
      prereqs: [
        '[Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) و[Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)',
        'أدوات بناء المنصة (VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK)',
      ],
      commandsHeading: 'الأوامر',
      benchmarksTitle: 'معايير الأداء والتحقق',
      benchmarkBullets: [
        '**سرعة التحليل**: `~30,670 عقدة/ث` (`5,000` عقدة خلال `~163 ms`).',
        '**اكتمال اللغات**: **9/9 لغات × 898 مفتاحاً = 100.0%** ([docs/BENCHMARKS.md](docs/BENCHMARKS.md)).',
      ],
      benchmarksLinkText: 'تفاصيل الاختبارات: [docs/BENCHMARKS.md](docs/BENCHMARKS.md).',
      starHistoryHeading: 'تاريخ النجوم (Star History)',
      securityTitle: 'الأمان والخصوصية والترخيص',
      securityBullets: [
        '**عدم جمع البيانات**: [assets/txts/privacy_policy_ar.txt](assets/txts/privacy_policy_ar.txt)',
        '**التحقق من البصمات**: [SECURITY.md](SECURITY.md)',
      ],
      licenseTitle: 'الترخيص',
      licenseIntro: 'مرخص بموجب **GNU General Public License v3.0 (GPL-3.0-or-later)** ([LICENSE](LICENSE)).',
      licenseBullets: [
        'حزم Rust: [MIT](rust/LICENSE-MIT) أو [Apache-2.0](rust/LICENSE-APACHE) منفردة، وGPL-3.0 ضمن Wmimo.',
        'مكونات الطرف الثالث: [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md)، [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)',
      ],
      ackTitle: 'شكر وتقدير',
      ackBullets: [
        '**[GooRingX (vowe)](https://github.com/GooRingX)**',
        '**[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**',
        '**[Flutter](https://flutter.dev/)**',
      ],
      communityTitle: 'المجتمع والدعم',
      labelWebsite: 'الموقع الرسمي',
      labelTelegram: 'قناة Telegram',
      labelEmail: 'البريد الإلكتروني',
      labelIssues: 'الإبلاغ عن المشكلات',
    ),

    // 9. Persian (README.fa.md)
    const _ReadmeSpec(
      fileName: 'README.fa.md',
      tagline: 'کلاینت پروکسی چندپلتفرمی Clash / Mihomo نسل جدید',
      subtitle:
          'ساخته‌شده با Flutter و هسته Mihomo (v1.19.34). اجرای کاملاً محلی بدون تله‌متری، پروکسی زنجیره‌ای چندگامی، عیب‌یابی هم‌زمان شبکه و تست سرعت با نمودار موجی زنده.',
      navDownloads: 'دانلود',
      navPlatforms: 'پلتفرم‌ها',
      navFeatures: 'امکانات',
      navArchitecture: 'معماری',
      navQuickStart: 'شروع سریع',
      navBuild: 'ساخت از سورس',
      navSecurity: 'امنیت و مجوز',
      navCommunity: 'انجمن',
      lightCaption: 'حالت روشن',
      darkCaption: 'حالت تاریک',
      previewNote:
          'طراحی کارت ۱۸px · نمودار ترافیک زنده · موتور دوگانه TUN و پروکسی سیستم',
      platformsTitle: 'پلتفرم‌های پشتیبانی‌شده و فایل‌های انتشار',
      colPlatform: 'سیستم‌عامل',
      colArch: 'معماری',
      colPackages: 'بسته‌های انتشار',
      colHighlights: 'ویژگی‌های بومی',
      platformRows: [
        ('**Windows**', '`x64`, `arm64`', 'نصاب (`.exe`)، نسخه قابل‌حمل (`.zip`)', 'پروکسی سیستم بدون دسترسی ادمین، Wintun WHQL TUN، ابزار UWP، سینی با سرعت زنده، کلیدهای میانبر'),
        ('**macOS**', '`Universal` (`arm64` + `x64`)', '`.dmg`، قابل‌حمل (`.zip`)', 'احراز هویت امن سرویس/TUN، آیکون تطبیقی نوار منو، همگام‌سازی iCloud Drive، کلیدهای میانبر'),
        ('**Linux**', '`x64`, `arm64`', '`.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz`', '`setcap` / TUN، پروکسی سیستم، پوسته GTK3، کلیدهای میانبر'),
        ('**Android**', '`arm64-v8a`, `armeabi-v7a`, `x86_64`', 'APK تفکیک‌شده و نسخه جامع `.apk`', 'تغییر زنده پروکسی برنامه‌ای بدون ری‌استارت هسته، معافیت بهینه‌سازی باتری، کاشی تنظیمات سریع'),
        ('**iOS**', '`arm64`', '`.ipa` امضانشده (TrollStore / Sideload)', 'تونل VPN اکستنشن شبکه و همگام‌سازی iCloud ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md))'),
      ],
      platformReleaseNote:
          'فایل‌های رسمی را از [GitHub Releases](https://github.com/aimy1/Wmimo/releases) دریافت کرده و اثرانگشت SHA-256 را با [SECURITY.md](SECURITY.md) تطبیق دهید.',
      featuresTitle: 'ماتریس قابلیت‌ها و ویژگی‌های کلیدی',
      colModule: 'بخش',
      colCapability: 'قابلیت‌های اصلی',
      featureMatrix: [
        ('**هسته Mihomo (`v1.19.34`)**', 'SS, VMess, VLESS Reality, Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH • تجزیه در Isolate (`5,000` گره در `~163 ms`)'),
        ('**پروکسی زنجیره‌ای `[Beta]`**', 'مبتنی بر **`dialer-proxy`** چندگامی، جابه‌جایی گام‌ها، جلوگیری از گره تکراری، ذخیره مستقل در `chain_proxies.json`'),
        ('**پروکسی برنامه‌ای (Android)**', 'محافظت لیست سفید خالی، تعویض زنده رابط VPN بدون توقف هسته، پیش‌تنظیمات بدون نیاز به مجوز'),
        ('**عیب‌یابی شبکه (`NetCheck`)**', 'پایپ‌لاین هم‌زمان ۵ مرحله‌ای (فیلتر TUN مجازی، بررسی DNS و Fake-IP، پورت‌ها، پروکسی/TUN، گره خروجی) + تعمیر خودکار'),
        ('**تست سرعت (`SpeedTest`)**', 'تست چندجریانی HTTP، سنجش دقیق Ping/Jitter، نمودار موجی لحظه‌ای، رتبه‌بندی کاربردی و تاخیر سرورها'),
        ('**پشتیبان‌گیری و همگام‌سازی**', 'WebDAV، iCloud Drive، فایل `.zip` شامل `chain_proxies.json` با بررسی موقت پیش از بازیابی و محافظت Zip-Slip'),
        ('**رابط کاربری و مانیتورینگ**', 'پوسته روشن/تاریک، مدیریت کارت‌های خانه، چرخش خودکار صفحه به‌طور پیش‌فرض، ماسک حریم خصوصی IP'),
        ('**حریم خصوصی و ۹ زبان**', 'بدون SDK تبلیغاتی/تله‌متری؛ **۹ زبان × ۸۹۸ کلید (۱۰۰٪)** به همراه ۹ سیاست حریم خصوصی بومی'),
      ],
      featureDetails: [
        ('مسیریابی و امنیت بازیابی', [
          '**موتور دوگانه**: تغییر سریع بین Rule / Global / Direct با TUN یا پروکسی سیستم.',
          '**بازیابی اتمی**: استخراج آزمایشی در پوشه موقت پیش از جایگزینی تنظیمات فعلی.',
        ]),
      ],
      archTitle: 'معماری و ساختار پروژه',
      colLayer: 'لایه',
      colTech: 'فناوری و وظیفه',
      colPath: 'مسیر',
      archRows: [
        ('**رابط کاربری**', 'Flutter (`>= 3.35.0`)، کارت‌های ۱۸px، نمودار Canvas', '[`lib/screens/`](lib/screens/)'),
        ('**ماژول‌ها و وضعیت**', 'مدیریت تنظیمات، زنجیره، پروفایل و Isolate', '[`lib/app/`](lib/app/)'),
        ('**VPN و لایه بومی**', 'سرویس چندپلتفرمی، Android Kotlin (`WmimoVpnService.kt`)', '[`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/), [`android/`](android/)'),
        ('**بسته‌های Rust**', 'ماژول‌های بومی با کارایی بالا', '[`rust/`](rust/)'),
        ('**چندزبانگی و متون قانونی**', 'Slang (۹ زبان × ۸۹۸ کلید) و سیاست حریم خصوصی', '[`lib/i18n/`](lib/i18n/), [`assets/txts/`](assets/txts/)'),
      ],
      quickStartTitle: 'شروع سریع',
      quickSteps: [
        '**دانلود و نصب**: فایل متناسب با سیستم خود را از [GitHub Releases](https://github.com/aimy1/Wmimo/releases) بگیرید.',
        '**افزودن اشتراک**: لینک Clash/Mihomo یا فایل YAML را در بخش اشتراک‌ها وارد کنید.',
        '**اتصال**: کلید اصلی صفحه اول را روشن کنید.',
      ],
      tipsSummary: 'نکات هر پلتفرم (Windows / Android / macOS و Linux / iOS)',
      platformTips: [
        ('Windows', 'پروکسی سیستم بدون دسترسی ادمین کار می‌کند؛ برای TUN برنامه را Run as administrator اجرا کنید. پوشه `portable` حالت قابل‌حمل را فعال می‌کند.'),
        ('Android', 'برای پایداری پس‌زمینه معافیت بهینه‌سازی باتری را فعال کنید؛ پروکسی برنامه‌ای به‌صورت زنده اعمال می‌شود.'),
        ('iOS', 'به‌صورت `.ipa` امضانشده ارائه می‌شود ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)).'),
      ],
      buildTitle: 'ساخت از کد منبع',
      prereqHeading: 'پیش‌نیازها',
      prereqs: [
        '[Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) و [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)',
        'ابزارهای کامپایل پلتفرم (VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK)',
      ],
      commandsHeading: 'دستورات',
      benchmarksTitle: 'معیارهای کارایی و آزمون‌ها',
      benchmarkBullets: [
        '**سرعت پردازش گره**: `~30,670 گره/ثانیه` (`5,000` گره در `~163 ms`).',
        '**پوشش زبان‌ها**: **۹/۹ زبان × ۸۹۸ کلید = ۱۰۰.۰٪** ([docs/BENCHMARKS.md](docs/BENCHMARKS.md)).',
      ],
      benchmarksLinkText: 'جزئیات روش‌شناسی: [docs/BENCHMARKS.md](docs/BENCHMARKS.md).',
      starHistoryHeading: 'نمودار ستاره‌ها',
      securityTitle: 'امنیت، حریم خصوصی و مجوز',
      securityBullets: [
        '**عدم جمع‌آوری داده**: [assets/txts/privacy_policy_fa.txt](assets/txts/privacy_policy_fa.txt)',
        '**تأیید امضاها**: [SECURITY.md](SECURITY.md)',
      ],
      licenseTitle: 'مجوز انتشار',
      licenseIntro: 'تحت مجوز **GNU General Public License v3.0 (GPL-3.0-or-later)** ([LICENSE](LICENSE)).',
      licenseBullets: [
        'بسته‌های Rust: به‌صورت مستقل [MIT](rust/LICENSE-MIT) / [Apache-2.0](rust/LICENSE-APACHE) و همراه Wmimo تحت GPL-3.0.',
        'مؤلفه‌های شخص ثالث: [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md)، [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)',
      ],
      ackTitle: 'قدردانی',
      ackBullets: [
        '**[GooRingX (vowe)](https://github.com/GooRingX)**',
        '**[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**',
        '**[Flutter](https://flutter.dev/)**',
      ],
      communityTitle: 'انجمن و پشتیبانی',
      labelWebsite: 'وب‌سایت رسمی',
      labelTelegram: 'کانال تلگرام',
      labelEmail: 'ایمیل نویسنده',
      labelIssues: 'گزارش خطا',
    ),
  ];

  for (final spec in specs) {
    final content = _renderReadme(spec);
    File(spec.fileName).writeAsStringSync(content, flush: true);
    print('Updated ${spec.fileName} (${content.length} chars)');
  }
}
