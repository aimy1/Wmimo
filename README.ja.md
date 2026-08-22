# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>モダンなクロスプラットフォーム Clash / Mihomo プロキシ GUI クライアント</h3>
  <p>Flutter と Mihomo コアをベースに構築され、高速でエレガント、強力な全プロトコルプロキシ体験を提供します。</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>
</div>

---

## 🔥 Beta ブランチの新機能 (What's New in Beta)

> [!TIP]
> このブランチは **`beta` プレビューブランチ** です。最新のプロトコル対応、Linux 環境の互換性改善、ノード表示の安定化機能が含まれています：

- 🔄 **全プロトコル対応サブスクリプション変換 (`SubscriptionConverter`)**：
  - **Base64 サブスクリプション** や単一ノードリンク（`vmess://`、`vless://` (Reality/Vision)、`ss://`、`trojan://`、`hysteria2://` / `hy2://`、`tuic://` など）を自動検出・変換；
  - 地域別グループ（🇭🇰 香港、🇯🇵 日本、🇸🇬 シンガポール、🇹🇼 台湾、🇺🇸 米国、🇰🇷 韓国など）、`ノード選択`、`自動選択`、`フォールバック` を自動生成；
  - 「プロファイル追加」画面でノードリンクや Base64 テキストを直接貼り付けてインポート可能。
- 🐧 **Linux 接続安定性と作業ディレクトリの権限最適化**：
  - コア作業ディレクトリ `work_dir` をユーザー書き込み可能な `~/.local/share/wmimo` に変更し、AppImage 環境での `cache.db` 読み取り専用権限エラーを解消；
  - 起動前に完全な `proxy-groups:` を自動構成し、接続後にノードが消える問題を修正。
- 🎯 **内部アダプタ除外とリアルプロキシ保護**：
  - Mihomo Meta の内部制御アダプタ（`COMPATIBLE`、`PASS`、`PASS-RULE`、`REJECT-DROP`、`DIRECT`、`REJECT`、`DNS`）を正確に除外；
  - 遅延測定（⚡）とカード表示が常に本物のプロキシノードのみを対象にするよう保護。
- 📦 **主要 Linux ディストリビューション完全対応**：
  - AppImage（インストール不要）、Debian/Ubuntu (`.deb`)、Fedora/RHEL (`.rpm`)、Arch Linux (`.pkg.tar.zst` & `PKGBUILD`)、ポータブル (`.tar.gz`) をサポート。

---

## 📌 対応プラットフォームおよび Linux ディストリビューション

| プラットフォーム | ステータス | パッケージ形式 | 特徴 |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **本番利用可能** | インストーラー (`.exe`) / ポータブル (`.zip`) | デスクトップサイドバー、トレイメニュー、リアルタイムトラフィックチャート、TUNモード、自動更新。 |
| 🐧 **Linux** | ✅ **利用可能** | Debian (`.deb`) / ポータブル (`.tar.gz`) | ネイティブ GTK3 UI、システムトレイ対応、Linux版 Mihomo コア内蔵。 |
| 📱 **Android** | ✅ **利用可能** | ユニバーサル APK / 各 ABI 分割 APK | VpnService ドライバー統合、モバイル最適化UI、バックグラウンド常駐。 |
| 🍎 **macOS** | 🚧 **開発中** | DMG インストーラー | NetworkExtension フレームワーク適応中。 |
| 🍏 **iOS** | 🚧 **開発中** | IPA | NetworkExtension フレームワーク適応中。 |

---

## ✨ 主な機能

- 🎨 **洗練されたモダン UI**: ライト/ダークモード、レスポンシブ適応型レイアウト（コンパクトモバイル＆デスクトップサイドバー）。
- ⚡ **高性能 Mihomo コア**: Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard などの全プロトコルを完全サポート。
- 🔀 **フル機能システムトレイ**: リアルタイム送受信速度表示、プロキシモード切り替え、ワンクリック遅延テスト、購読更新。
- 📊 **リアルタイム診断 & 監視**: ベジェ曲線トラフィックチャート、ワンクリック IP/ISP 情報取得、折りたたみ可能なプロキシグループ。
- 🚀 **マルチチャンネル自動更新**: `stable`（安定版）と `beta`（プレビュー版）の切り替えに対応。
- 🌍 **9言語の完全多言語対応**: 日本語、英語、簡体字中国語、繁体字中国語、韓国語、ロシア語、スペイン語、アラビア語、ペルシア語。

---

## 💖 寄付・サポート

- **通貨 (Token)**: `USDT`
- **ネットワーク (Network)**: `APTOS`
- **受取アドレス (Address)**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 ライセンス

本プロジェクトは **GPL-3.0** ライセンスの下で公開されています。
