# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


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
