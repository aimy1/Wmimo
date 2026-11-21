<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---

<div align="center">
  <img src="assets/images/app_icon_256.png" width="112" height="112" alt="Wmimo Logo" />
  <h1>Wmimo</h1>
  <p><strong>次世代クロスプラットフォーム Clash / Mihomo GUI プロキシクライアント</strong></p>
  <p>Flutter と Mihomo コア (v1.19.34) により構築。テレメトリゼロの完全ローカル動作に加え、マルチホップチェーン、並列ネットワーク診断、リアルタイム波形速度測定を搭載。</p>

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
    <a href="https://github.com/aimy1/Wmimo/releases"><b>ダウンロード</b></a> •
    <a href="#sec-platforms"><b>対応OS</b></a> •
    <a href="#sec-features"><b>主要機能</b></a> •
    <a href="#sec-architecture"><b>アーキテクチャ</b></a> •
    <a href="#sec-quickstart"><b>クイックスタート</b></a> •
    <a href="#sec-build"><b>ビルド</b></a> •
    <a href="#sec-security"><b>セキュリティ</b></a> •
    <a href="#sec-community"><b>コミュニティ</b></a>
  </p>
</div>

| ライトモード | ダークモード |
| :---: | :---: |
| <img src="docs/preview_light.png" alt="Wmimo Light Theme" width="380" /> | <img src="docs/preview_dark.png" alt="Wmimo Dark Theme" width="380" /> |

<p align="center"><sub><em>18px マイクロカードUI · ベジェ曲線トラフィックモニター · TUN / システムプロキシ両対応 · ホームカードカスタマイズ</em></sub></p>

---

<a id="sec-platforms"></a>

## 対応プラットフォームと配布パッケージ

| OS | アーキテクチャ | 配布形式 | 主なプラットフォーム機能 |
| :--- | :--- | :--- | :--- |
| **Windows** | `x64`, `arm64` | インストーラー (`.exe`)、ポータブル (`.zip`) | 権限不要のシステムプロキシ、WHQL 署名 Wintun TUN、UWP ループバック免除、トレイ速度表示、グローバルホットキー |
| **macOS** | `Universal` (`arm64` + `x64`) | `.dmg`、ポータブル (`.zip`) | 安全な特権ヘルパー/TUN、メニューバー適応アイコン、iCloud Drive 同期、グローバルホットキー |
| **Linux** | `x64`, `arm64` | `.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz` | `setcap` / サービス権限 TUN、システムプロキシ、GTK3 デスクトップ統合、グローバルホットキー |
| **Android** | `arm64-v8a`, `armeabi-v7a`, `x86_64` | ABI 分割 APK・ユニバーサル `.apk` | 無停止アプリ別プロキシホットスワップ、バッテリー最適化除外チェック、クイック設定タイル、フォアグラウンド通知 |
| **iOS** | `arm64` | 未署名 `.ipa`（TrollStore / サイドロード） | Network Extension VPN トンネル・iCloud 同期（[Apple 開発ガイド](docs/APPLE_DEVELOPMENT.md)参照） |

> 公式バイナリは [GitHub Releases](https://github.com/aimy1/Wmimo/releases) から入手し、[SECURITY.md](SECURITY.md) の APK SHA-256 フィンガープリントで検証できます。

---

<a id="sec-features"></a>

## 主要機能一覧

| モジュール | 概要 |
| :--- | :--- |
| **Mihomo コア (`v1.19.34`)** | SS / VMess / VLESS Reality / Trojan / Hysteria 1/2 / TUIC v5 / WireGuard / SSH • Isolate 並列 YAML 解析（5,000 ノード ~163 ms） |
| **マルチホップチェーン `[Beta]`** | **`dialer-proxy`** ベースで任意の中継ホップを構成可能（ドラッグ並替・重複検証・`chain_proxies.json` 永続化） |
| **アプリ別プロキシ (Android)** | 空ホワイトリストの通信漏れ防止、コア再起動なしのホットスワップ、Launcher 連携＆プリセット |
| **ネットワーク診断 (`NetCheck`)** | 2段階5ステップ並列診断（仮想 TUN 除外、DNS/Fake-IP 判定、ポート・プロキシ整合、出口 204 テスト）+ ドメイン調査 + ワンクリック修復 |
| **速度測定 (`SpeedTest`)** | マルチストリーム計測、安定 Ping/Jitter、リアルタイム送受信波形グラフ、用途別評価（ゲーム/8K/通話）、CDN 遅延一括測定 |
| **バックアップと同期** | WebDAV / iCloud Drive / ZIP インポート・エクスポート（`chain_proxies.json` 含む一時展開検証 & Zip-Slip 防御） |
| **UI・テレメトリ監視** | ライト/ダーク両テーマ、ホームカード管理、画面自動回転デフォルト有効、IP・ISP プライバシーマスク表示 |
| **プライバシー＆9言語対応** | 広告・追跡 SDK ゼロ、**9言語 × 898 キー（100%一致）**、9言語プライバシーポリシー搭載 |

### ルーティング・診断・高速測定

- **デュアルエンジン**: Rule / Global / Direct の即時切替と TUN / システムプロキシに対応。
- **可視化ツール群**: 並列診断パイプラインと波形グラフ付き速度測定で回線状態を正確に把握。

---

<a id="sec-architecture"></a>

## 技術スタックと構成

| レイヤー | 技術 / 役割 | ディレクトリ |
| :--- | :--- | :--- |
| **UI / 画面** | Flutter (`>= 3.35.0`)、マイクロカード、Canvas グラフ | [`lib/screens/`](lib/screens/) |
| **コア状態管理** | 設定・チェーン・プロファイル管理、Isolate パーサー | [`lib/app/`](lib/app/) |
| **VPN / ネイティブ** | サービスラッパー、Android Kotlin (`WmimoVpnService.kt`)、OS 特権連携 | [`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/)、[`android/`](android/) |
| **Rust クレート** | ネイティブユーティリティワークスペース | [`rust/`](rust/) |
| **i18n / ポリシー** | Slang 生成翻訳（9言語 × 898 キー）および規約文書 | [`lib/i18n/`](lib/i18n/)、[`assets/txts/`](assets/txts/) |

---

<a id="sec-quickstart"></a>

## クイックスタート

1. **ダウンロード**: [GitHub Releases](https://github.com/aimy1/Wmimo/releases) から OS 用パッケージを入手。
2. **プロファイル追加**: 「サブスクリプション」で URL またはローカル YAML をインポート。
3. **接続**: ホーム画面のスイッチをオンにして通信を開始します。

<details>
<summary><b>プラットフォーム別のヒント (Windows / Android / macOS・Linux / iOS)</b></summary>

- **Windows**: 通常は権限不要のシステムプロキシ、TUN モードは管理者として実行してください。`portable` フォルダでポータブル動作に対応。
- **Android**: バッテリー最適化の除外設定を推奨。アプリ別プロキシは接続中も即時反映されます。
- **iOS**: 未署名 `.ipa` で配布（詳細は [docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)）。

</details>

---

<a id="sec-build"></a>

## ソースからビルド

### 前提条件

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) & [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- 各 OS ビルドツール (VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK)

### ビルド手順

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

## ベンチマークと品質検証

- **サブスクリプション解析**: `~30,670 ノード/秒`（5,000 ノードを ~163 ms でバックグラウンド解析）。
- **多言語カバレッジ**: **9言語 × 898 キー = 100.0%**（[docs/BENCHMARKS.md](docs/BENCHMARKS.md)）。

詳細手順: [docs/BENCHMARKS.md](docs/BENCHMARKS.md)

<details>
<summary><b>Star 推移グラフ</b></summary>

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

</details>

---

<a id="sec-security"></a>

## セキュリティ・プライバシー・ライセンス

- **データ収集ゼロ**: [assets/txts/privacy_policy_ja.txt](assets/txts/privacy_policy_ja.txt)
- **署名・証明書検証**: [SECURITY.md](SECURITY.md)

### ライセンス

**GNU General Public License v3.0 (GPL-3.0-or-later)** に基づき公開（[LICENSE](LICENSE)）。

- Rust クレート: 単体では [MIT](rust/LICENSE-MIT) / [Apache-2.0](rust/LICENSE-APACHE)、同梱配布時は GPL-3.0。
- サードパーティ表記: [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) / [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)

---

<a id="sec-community"></a>

## 謝辞

- **[GooRingX (vowe)](https://github.com/GooRingX)**
- **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**
- **[Flutter](https://flutter.dev/)**

## コミュニティ

- **公式サイト**: [wmimo.buzz](https://wmimo.buzz)
- **Telegram チャンネル**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **メール**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **Issue トラッカー**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)
