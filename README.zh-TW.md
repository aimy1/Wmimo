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

## 🔥 Beta 分支專屬特性 (What's New in Beta)

> [!TIP]
> 當前分支為 **`beta` 測試預覽分支**，包含最新的通訊協定支援、Linux 深度相容性優化及多項節點穩定性改進：

- 🔄 **全協定通用訂閱轉換器 (`SubscriptionConverter`)**：
  - 自動辨識並解析 **Base64 訂閱**與各類單節點連結（全面支援 `vmess://`、`vless://` (Reality/Vision)、`ss://`、`trojan://`、`hysteria2://` / `hy2://`、`tuic://` 等最新協定）；
  - 智慧產生地區分組（🇭🇰 香港節點、🇯🇵 日本節點、🇸🇬 新加坡節點、🇹🇼 台灣節點、🇺🇸 美國節點、🇰🇷 韓國節點等）、`節點選擇`、`自動選擇`、`故障轉移` 以及全域路由規則；
  - 允許在「新增配置」介面直接貼上單節點連結或 Base64 文本快速匯入。
- 🐧 **Linux 平台連線穩定性與工作目錄權限優化**：
  - 將核心工作目錄 `work_dir` 修正至使用者主目錄下的可讀寫路徑 `~/.local/share/wmimo`，徹底解決 AppImage / 安裝包環境下的唯讀權限與 `cache.db` 建立失敗問題；
  - 啟動連線前確保配置包含完整 `proxy-groups:` 結構，解決 Linux 下連線後節點消失的偶發問題。
- 🎯 **精準核心適配器過濾與代理保護**：
  - 精準過濾 Mihomo Meta 內部流控與規則適配器樁（如 `COMPATIBLE`、`PASS`、`PASS-RULE`、`REJECT-DROP`、`DIRECT`、`REJECT`、`DNS`），防止內建樁偽裝為代理節點；
  - 確保測速（⚡）與卡片網格始終僅針對真實的機場代理節點生效，測速前後節點永遠不會消失。
- 📦 **Linux 全主流發行版原生打包支援**：
  - 提供 AppImage（免安裝即開即用）、Debian/Ubuntu (`.deb`)、Fedora/RHEL (`.rpm`)、Arch Linux (`.pkg.tar.zst` & `PKGBUILD`) 以及通用綠色便攜包 (`.tar.gz`)。

---

## 📌 全平台與 Linux 各大發行版支援矩陣

| 平台 / 發行版 | 狀態 | 軟體包格式 | 功能與適配說明 |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **已基本完成** | 安裝包 (`.exe`) 與 綠色便攜包 (`.zip`) | 完整桌面側邊欄、全功能系統工具列（即時網速、分流模式切換、節點測速）、TUN 虛擬網卡模式、自動更新。 |
| 🐧 **Linux 通用免安裝** | ✅ **已就緒** | 通用獨立鏡像 (`.AppImage`) 與 便攜壓縮包 (`.tar.gz`) | 單檔案免安裝，解壓即用，完美相容所有主流 Linux 發行版。 |
| 🐧 **Debian / Ubuntu / Mint / Deepin / UOS** | ✅ **已就緒** | Debian 安裝包 (`.deb`) | 原生包管理器支援，自動註冊桌面啟動選單與圖示。 |
| 🐧 **Fedora / RHEL / CentOS / openSUSE** | ✅ **已就緒** | RedHat 安裝包 (`.rpm`) | 標準 RPM 格式封裝，自動配置依賴與桌面整合。 |
| 🐧 **Arch Linux / Manjaro** | ✅ **已就緒** | Pacman 二進位包 (`.pkg.tar.zst`) 與 `PKGBUILD` | 支援 pacman 一鍵安裝與 AUR 腳本直接建置。 |
| 📱 **Android** | ✅ **已就緒** | 通用 APK 與 分架構包 (`arm64-v8a`, `v7a`, `x86_64`) | 系統級 VpnService 驅動、緊湊行動端 UI、背景保活。 |
| 🍎 **macOS** | 🚧 **開發中** | DMG 安裝映像 | NetworkExtension 架構與桌面端協議適配中。 |
| 🍏 **iOS** | 🚧 **開發中** | IPA | NetworkExtension 架構適配中。 |

---

## 💖 贊助與支持

- **幣種 (Currency)**: `USDT`
- **網路 (Network)**: `APTOS`
- **收款地址 (Address)**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 開源授權

本專案基於 **GPL-3.0** 授權條款分發。詳見 [LICENSE](LICENSE) 文件。
