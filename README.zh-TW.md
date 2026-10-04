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

  <br/>
  <img src="docs/preview.png" alt="Wmimo 介面預覽" width="380" />
  <br/>
  <sub><em>✨ 18px 微卡片設計美學、即時平滑流量監控與豐富網路診斷工具</em></sub>
</div>

---

## 📌 全平台與 Linux 各大發行版支援矩陣

| 平台 / 發行版 | 狀態 | 軟體包格式 | 功能與適配說明 |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **已基本完成** | 安裝包 (`.exe`) 與 綠色便攜包 (`.zip`) | 完整桌面側邊欄、全功能系統工具列（即時網速、分流模式切換、節點測速）、TUN 虛擬網卡模式、自動更新。 |
| 🐧 **Linux 通用免安裝** | ✅ **已就緒** | 通用獨立鏡像 (`.AppImage`) 與 便攜壓縮包 (`.tar.gz`) | 單檔案免安裝，解壓即用，完美相容所有主流 Linux 發行版。 |
| 🐧 **Debian / Ubuntu / Mint / Deepin / UOS** | ✅ **已就緒** | Debian 安裝包 (`.deb`) | 原生包管理器支援，自動註冊桌面啟動選單與圖示。 |
| 🐧 **Fedora / RHEL / CentOS / openSUSE** | ✅ **已就緒** | RedHat 安裝包 (`.rpm`) | 標準 RPM 格式封裝，自動配置依賴與桌面整合。 |
| 🐧 **Arch Linux / Manjaro** | ✅ **已就緒** | Pacman 二進位包 (`.pkg.tar.zst`) 與 `PKGBUILD` | 支援 pacman 一鍵安裝與 AUR 腳本直接建置。 |
| 📱 **Android** | ✅ **已就緒** | 通用 APK 與 分架構包 (`arm64-v8a`, `v7a`, `x86_64`) | 系統級 VpnService 驅動、固定 Release 簽名（支援無縫覆蓋升級）、緊湊行動端 UI、背景保活。 |
| 🍎 **macOS** | 🛠️ **源碼已就緒** | DMG / 本地建置 | 系統代理與 TUN 模式底層均已實現，支援用戶本地編譯運行 (`flutter run -d macos`)；官方 Release 暫未提供預編譯包。 |
| 🍏 **iOS** | 📦 **架構已打通** | IPA / 源碼 | NetworkExtension 架構與通信通道已搭建。因受限於 Apple 開發者證書簽名，官方暫不提供預編譯 IPA 分發，建議使用第三方成熟客戶端導入訂閱。 |

> 💡 **平台發布策略說明**：
> 本專案專注於 **Windows**、**Linux** 與 **Android** 平台的官方自動化預編譯與發布。
> - **macOS**：代碼層已完整支援系統代理與 TUN 提權，如需使用可複製源碼在本地透過 `flutter build macos` 自行編譯。
> - **iOS**：工程架構與系統擴充介面已就緒，因受限於 Apple 開發者證書與簽名體系，暫不提供官方打包分發，建議 iOS 用戶使用同生態客戶端導入訂閱。

---

## 💖 贊助與支持

- **幣種 (Currency)**: `USDT`
- **網路 (Network)**: `APTOS`
- **收款地址 (Address)**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 開源授權

本專案基於 **GPL-3.0** 授權條款分發。詳見 [LICENSE](LICENSE) 文件。
