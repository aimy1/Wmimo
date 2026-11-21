<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---

<div align="center">
  <img src="assets/images/app_icon_256.png" width="112" height="112" alt="Wmimo Logo" />
  <h1>Wmimo</h1>
  <p><strong>新一代全平台 Clash / Mihomo 桌面與行動端代理用戶端</strong></p>
  <p>基於 Flutter 與 Mihomo (v1.19.34) 核心打造。堅持資料零遙測與純本機執行，結合多跳鏈式代理、並發鏈路診斷、即時波形測速與作業系統級原生整合。</p>

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
    <a href="https://github.com/aimy1/Wmimo/releases"><b>下載發布版</b></a> •
    <a href="#sec-platforms"><b>支援平台</b></a> •
    <a href="#sec-features"><b>核心能力</b></a> •
    <a href="#sec-architecture"><b>技術架構</b></a> •
    <a href="#sec-quickstart"><b>快速上手</b></a> •
    <a href="#sec-build"><b>原始碼編譯</b></a> •
    <a href="#sec-security"><b>安全與授權</b></a> •
    <a href="#sec-community"><b>社群回饋</b></a>
  </p>
</div>

| 淺色主題 (Light) | 深色主題 (Dark) |
| :---: | :---: |
| <img src="docs/preview_light.png" alt="Wmimo Light Theme" width="380" /> | <img src="docs/preview_dark.png" alt="Wmimo Dark Theme" width="380" /> |

<p align="center"><sub><em>18px 極簡微卡片儀表板 · 即時貝茲流量曲線 · TUN / 系統代理雙引擎 · 支援自訂首頁卡片與螢幕自動旋轉</em></sub></p>

---

<a id="sec-platforms"></a>

## 支援平台與發布產物清單

| 作業系統 | 支援架構 | 官方發布套件 | 平台專屬特性 |
| :--- | :--- | :--- | :--- |
| **Windows** | `x64`, `arm64` | 安裝程式 (`.exe`)、可攜壓縮檔 (`.zip`) | 免權限系統代理、WHQL 簽章 Wintun TUN（系統管理員）、UWP 迴環豁免、深淺色同步系統匣與即時網速、全域快速鍵 |
| **macOS** | `Universal` (`arm64` + `x64`) | `.dmg` 映像檔、可攜壓縮檔 (`.zip`) | 安全服務授權與 TUN、系統代理、自適應選單列圖示、iCloud Drive 雲端同步、全域快速鍵 |
| **Linux** | `x64`, `arm64` | `.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz` | `setcap` / 服務授權 TUN 模式、系統代理、GTK3 桌面整合、全域快速鍵 |
| **Android** | `arm64-v8a`, `armeabi-v7a`, `x86_64` | 分架構 APK 與通用版 `.apk` | 不斷線分應用代理熱切換（黑白名單 + 免授權預設）、電池最佳化保活偵測、快速設定磚、前景通知控制 |
| **iOS** | `arm64` | 未簽章 `.ipa`（TrollStore / 側載） | Network Extension VPN 通道、iCloud Drive 備份同步（詳見 [Apple 開發指南](docs/APPLE_DEVELOPMENT.md)） |

> 請至 [GitHub Releases](https://github.com/aimy1/Wmimo/releases) 下載對應安裝檔，並參考 [SECURITY.md](SECURITY.md) 驗證 Android APK SHA-256 憑證指紋與 Wintun 簽章。

---

<a id="sec-features"></a>

## 核心能力矩陣與特性詳解

| 功能模組 | 核心能力摘要 |
| :--- | :--- |
| **Mihomo 路由核心** | `v1.19.34` • 涵蓋 SS、VMess、VLESS (Reality)、Trojan、Hysteria 1/2、TUIC v5、WireGuard、SSH、Direct；獨立 Isolate 解析訂閱（5,000 節點僅 ~163 ms） |
| **多跳鏈式代理 `[Beta]`** | 採用 **`dialer-proxy`** 鏈式編排（入口策略/節點 ➔ 任意中繼跳 ➔ 出口落地），支援拖曳換序、防重複節點檢查，`chain_proxies.json` 獨立持久化 |
| **行動端分應用代理** | 白名單空清單防漏流保護；VPN 執行期間平滑熱替換無需重啟核心；應用清單與 Launcher 去重合併及免授權常用預設 |
| **網路鏈路診斷 (`NetCheck`)** | 兩階段 5 步並發體檢（過濾虛擬 TUN 網卡、DNS 與 Fake-IP 偵測、核心連接埠、代理/TUN 對齊、真實出口 204 握手含備援）+ 並發單網域排查 + 一鍵自癒 |
| **內建網路測速 (`SpeedTest`)** | 多執行緒 HTTP 下載/上傳測速、穩態 Ping 與抖動採樣、即時雙線頻寬波形圖、場景評級（電競/8K/視訊）、並發節點延遲標記與代理前置檢查 |
| **備份與雲端同步** | 支援 WebDAV、iCloud Drive、本機與 URL `.zip` 匯出還原；納入 `chain_proxies.json`，具備預解壓暫存驗證與 Zip-Slip 防護 |
| **微卡片 UI 與監控** | 淺色/深黑雙主題、首頁卡片管理、預設開啟螢幕自動旋轉、1m–60m 貝茲流量波紋圖、出口 IP 歸屬與隱私遮罩卡片 |
| **零遙測與 9 國語言** | 零廣告與分析遙測 SDK，純本機運作；**9 語言 × 898 詞條 100% 對齊**，並內建全 9 語系獨立《隱私權政策》與《使用者協議》 |

### 智慧路由、多跳鏈式代理與診斷

- **雙引擎與模式切換**：支援 **規則 (Rule)** / **全域 (Global)** / **直連 (Direct)** 快速切換，自由選用 **TUN** 或免權限 **系統代理**。
- **多跳鏈式代理 `[Beta]`**：透過 `dialer-proxy` 建立多跳拓撲，代理面板頂列即時顯示已啟用鏈數角標。
- **並發診斷與測速可視化**：精準定位 DNS 汙染、連接埠衝突與殘留系統代理，並以即時上下行波形圖展現真實吞吐能力。

### 跨平台設定階層與原子備份安全

- **分平台設定整理**：四大分組清晰歸納；桌面端聚焦全域快速鍵與資料目錄，Android 端提供電池最佳化與系統權限管理捷徑。
- **原子安全還原**：還原前先於暫存目錄驗證解壓完整性，確認無誤後再停止核心並覆蓋設定。
- **雙通道自動更新**：支援 `stable` 與 `beta` 通道切換並進行 SHA-256 雜湊驗證。

---

<a id="sec-architecture"></a>

## 技術堆疊與專案架構

| 架構層 | 技術與職責 | 路徑 |
| :--- | :--- | :--- |
| **UI 與頁面層** | Flutter (`>= 3.35.0`)、微卡片儀表板、Canvas 圖表與響應式版面 | [`lib/screens/`](lib/screens/) |
| **核心模組與狀態** | `SettingManager`、`ChainProxyManager`、`ProfileManager` 與 Isolate 解析器 | [`lib/app/`](lib/app/) |
| **VPN 與原生橋接** | 跨平台服務封裝、Android Kotlin (`WmimoVpnService.kt`)、macOS/Linux 授權 | [`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/)、[`android/`](android/) |
| **Rust 工作區** | 高效能原生工具組件 | [`rust/`](rust/) |
| **多語言與法務資源** | Slang 強型別翻譯（9 語系 × 898 詞條）與隱私權/條款檔案 | [`lib/i18n/`](lib/i18n/)、[`assets/txts/`](assets/txts/) |
| **CI、打包與測試** | GitHub Actions 多平台自動發行流程與測試套件 | [`.github/workflows/release.yml`](.github/workflows/release.yml)、[`test/`](test/) |

---

<a id="sec-quickstart"></a>

## 快速上手

1. **下載安裝**：從 [GitHub Releases](https://github.com/aimy1/Wmimo/releases) 下載對應平台的安裝套件。
2. **匯入設定檔**：於「訂閱設定」貼上 Clash/Mihomo 訂閱連結或匯入本機 YAML。
3. **啟用連線**：點擊「首頁」主開關即可開始安全分流。

<details>
<summary><b>各平台設定提示（Windows / Android / macOS & Linux / iOS）</b></summary>

- **Windows**: 免權限可直接用系統代理；TUN 模式需右鍵「以系統管理員身分執行」。於同目錄建立 `portable` 資料夾即啟用可攜模式。
- **Android**: 建議允許忽略電池最佳化確保背景穩定運作；分應用代理支援執行期熱套用。
- **macOS / Linux**: TUN 模式會透過安全的標準輸入與系統授權對話框請求服務權限。
- **iOS**: 提供未簽章 `.ipa` 供 TrollStore 或自簽安裝，詳見 [docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)。

</details>

---

<a id="sec-build"></a>

## 從原始碼編譯

### 環境需求

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) 與 [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- 各平台建置工具鏈（VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK & NDK）

### 建置指令

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

## 效能基準與自動化驗證

- **訂閱解析吞吐**：`~30,670 節點/秒`（背景 Isolate 解析 `5,000` 節點僅需 `~163 ms`）。
- **格式快速判斷**：`isClashYaml` 檢測 `1,000` 節點僅需 `~1.4 ms`。
- **i18n 完整度**：**9 語系 × 898 詞條 = 100.0%**，且 9 語系《隱私權政策》全數齊全。
- **本機驗證**：執行 `flutter analyze --no-pub lib/ third_party/libclash_vpn_service/lib/ test/`、`flutter test test/benchmark_profile_scale_test.dart`、`flutter test test/i18n_integrity_test.dart` 與 `dart run tool/verify_i18n.dart`。

完整基準報告請參閱 [docs/BENCHMARKS.md](docs/BENCHMARKS.md)。

<details>
<summary><b>Star 成長趨勢圖</b></summary>

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

</details>

---

<a id="sec-security"></a>

## 隱私保護、安全驗證與授權條款

- **零資料蒐集**：純本機執行且無任何商業追蹤 SDK，詳見 [assets/txts/privacy_policy_zh_tw.txt](assets/txts/privacy_policy_zh_tw.txt)。
- **發行檔驗證**：Android APK SHA-256 指紋與 Wintun WHQL 簽章說明請見 [SECURITY.md](SECURITY.md)。

### 開源授權

本專案採 **GNU General Public License v3.0 (GPL-3.0-or-later)** 授權，詳見 [LICENSE](LICENSE)。

- **Rust Workspace**：獨立使用採 [MIT](rust/LICENSE-MIT) / [Apache-2.0](rust/LICENSE-APACHE)，隨 Wmimo 散佈時受 GPL-3.0 約束。
- **第三方與核心授權**：詳見 [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) 與 [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)。

---

<a id="sec-community"></a>

## 致謝

- **[GooRingX (vowe)](https://github.com/GooRingX)** —— 感謝開源貢獻與設計靈感。
- **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** —— 感謝高效能跨平台代理核心。
- **[Flutter](https://flutter.dev/)** —— 感謝現代跨平台框架支援。

## 社群與回饋

- **官方網站**: [wmimo.buzz](https://wmimo.buzz)
- **Telegram 官方頻道**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **作者信箱**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **問題回報**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)
