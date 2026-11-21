<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---

<div align="center">
  <img src="assets/images/app_icon_256.png" width="96" height="96" alt="Wmimo Logo" />
  <h1>Wmimo</h1>
  <p><strong>کلاینت پروکسی چندپلتفرمی Clash / Mihomo نسل جدید</strong></p>
  <p>ساخته‌شده با Flutter و هسته Mihomo (v1.19.34). اجرای کاملاً محلی بدون تله‌متری، پروکسی زنجیره‌ای چندگامی، عیب‌یابی هم‌زمان شبکه و تست سرعت با نمودار موجی زنده.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/stargazers"><img src="https://img.shields.io/github/stars/aimy1/Wmimo?color=F59E0B&label=Stars&logo=github&style=flat-square" alt="Stars" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions/workflows/release.yml"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="CI Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&label=Downloads" alt="Downloads" /></a>
    <a href="https://github.com/MetaCubeX/mihomo"><img src="https://img.shields.io/badge/Mihomo-v1.19.34-FF6B6B?style=flat-square" alt="Mihomo" /></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPL--3.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-%40wmimoapp-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><b>دانلود</b></a> ·
    <a href="#sec-platforms"><b>پلتفرم‌ها</b></a> ·
    <a href="#sec-features"><b>امکانات</b></a> ·
    <a href="#sec-quickstart"><b>شروع سریع</b></a> ·
    <a href="#sec-build"><b>ساخت از سورس</b></a> ·
    <a href="#sec-security"><b>امنیت و مجوز</b></a> ·
    <a href="#sec-community"><b>انجمن</b></a>
  </p>
</div>

| حالت روشن | حالت تاریک |
| :---: | :---: |
| <img src="docs/preview_light.png" alt="Wmimo Light Theme" width="360" /> | <img src="docs/preview_dark.png" alt="Wmimo Dark Theme" width="360" /> |

<p align="center"><sub><em>طراحی کارت ۱۸px · نمودار ترافیک زنده · موتور دوگانه TUN و پروکسی سیستم</em></sub></p>

---

<a id="sec-platforms"></a>

## پلتفرم‌های پشتیبانی‌شده و فایل‌های انتشار

| سیستم‌عامل | معماری | بسته‌های انتشار | ویژگی‌های بومی |
| :--- | :--- | :--- | :--- |
| **Windows** | `x64`, `arm64` | نصاب (`.exe`)، نسخه قابل‌حمل (`.zip`) | پروکسی سیستم بدون دسترسی ادمین، Wintun WHQL TUN، ابزار UWP، سینی با سرعت زنده، کلیدهای میانبر |
| **macOS** | `Universal` (`arm64` + `x64`) | `.dmg`، قابل‌حمل (`.zip`) | احراز هویت امن سرویس/TUN، آیکون تطبیقی نوار منو، همگام‌سازی iCloud Drive، کلیدهای میانبر |
| **Linux** | `x64`, `arm64` | `.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz` | `setcap` / TUN، پروکسی سیستم، پوسته GTK3، کلیدهای میانبر |
| **Android** | `arm64-v8a`, `armeabi-v7a`, `x86_64` | APK تفکیک‌شده و نسخه جامع `.apk` | تغییر زنده پروکسی برنامه‌ای بدون ری‌استارت هسته، معافیت بهینه‌سازی باتری، کاشی تنظیمات سریع |
| **iOS** | `arm64` | `.ipa` امضانشده (TrollStore / Sideload) | تونل VPN اکستنشن شبکه و همگام‌سازی iCloud ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)) |

> فایل‌های رسمی را از [GitHub Releases](https://github.com/aimy1/Wmimo/releases) دریافت کرده و اثرانگشت SHA-256 را با [SECURITY.md](SECURITY.md) تطبیق دهید.

---

<a id="sec-features"></a>

## ماتریس قابلیت‌ها و ویژگی‌های کلیدی

| بخش | قابلیت‌های اصلی |
| :--- | :--- |
| **هسته Mihomo (`v1.19.34`)** | SS, VMess, VLESS Reality, Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH • تجزیه در Isolate (`5,000` گره در `~163 ms`) |
| **پروکسی زنجیره‌ای `[Beta]`** | مبتنی بر **`dialer-proxy`** چندگامی، جابه‌جایی گام‌ها، جلوگیری از گره تکراری، ذخیره مستقل در `chain_proxies.json` |
| **پروکسی برنامه‌ای (Android)** | محافظت لیست سفید خالی، تعویض زنده رابط VPN بدون توقف هسته، پیش‌تنظیمات بدون نیاز به مجوز |
| **عیب‌یابی شبکه (`NetCheck`)** | پایپ‌لاین هم‌زمان ۵ مرحله‌ای (فیلتر TUN مجازی، بررسی DNS و Fake-IP، پورت‌ها، پروکسی/TUN، گره خروجی) + تعمیر خودکار |
| **تست سرعت (`SpeedTest`)** | تست چندجریانی HTTP، سنجش دقیق Ping/Jitter، نمودار موجی لحظه‌ای، رتبه‌بندی کاربردی و تاخیر سرورها |
| **پشتیبان‌گیری و همگام‌سازی** | WebDAV، iCloud Drive، فایل `.zip` شامل `chain_proxies.json` با بررسی موقت پیش از بازیابی و محافظت Zip-Slip |
| **رابط کاربری و مانیتورینگ** | پوسته روشن/تاریک، مدیریت کارت‌های خانه، چرخش خودکار صفحه به‌طور پیش‌فرض، ماسک حریم خصوصی IP |
| **حریم خصوصی و ۹ زبان** | بدون SDK تبلیغاتی/تله‌متری؛ **۹ زبان × ۸۹۸ کلید (۱۰۰٪)** به همراه ۹ سیاست حریم خصوصی بومی |

---

<a id="sec-quickstart"></a>

## شروع سریع

1. **دانلود و نصب**: فایل متناسب با سیستم خود را از [GitHub Releases](https://github.com/aimy1/Wmimo/releases) بگیرید.
2. **افزودن اشتراک**: لینک Clash/Mihomo یا فایل YAML را در بخش اشتراک‌ها وارد کنید.
3. **اتصال**: کلید اصلی صفحه اول را روشن کنید.

<details>
<summary><b>نکات هر پلتفرم (Windows / Android / macOS و Linux / iOS)</b></summary>

- **Windows**: پروکسی سیستم بدون دسترسی ادمین کار می‌کند؛ برای TUN برنامه را Run as administrator اجرا کنید. پوشه `portable` حالت قابل‌حمل را فعال می‌کند.
- **Android**: برای پایداری پس‌زمینه معافیت بهینه‌سازی باتری را فعال کنید؛ پروکسی برنامه‌ای به‌صورت زنده اعمال می‌شود.
- **iOS**: به‌صورت `.ipa` امضانشده ارائه می‌شود ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)).

</details>

---

<a id="sec-build"></a>

## ساخت از کد منبع

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) و [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- ابزارهای کامپایل پلتفرم (VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK)

```bash
git clone https://github.com/aimy1/Wmimo.git && cd Wmimo
flutter pub get && dart run slang
dart run tool/download_all_cores.dart
flutter run
# Release: flutter build {windows|macos|linux|apk} --release
```

---

## معیارهای کارایی و آزمون‌ها

- **سرعت پردازش گره**: `~30,670 گره/ثانیه` (`5,000` گره در `~163 ms`).
- **پوشش زبان‌ها**: **۹/۹ زبان × ۸۹۸ کلید = ۱۰۰.۰٪** ([docs/BENCHMARKS.md](docs/BENCHMARKS.md)).

جزئیات روش‌شناسی: [docs/BENCHMARKS.md](docs/BENCHMARKS.md).

---

## نمودار ستاره‌ها

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

<a id="sec-security"></a>

## امنیت، حریم خصوصی و مجوز

- **عدم جمع‌آوری داده**: [assets/txts/privacy_policy_fa.txt](assets/txts/privacy_policy_fa.txt)
- **تأیید امضاها**: [SECURITY.md](SECURITY.md)
- تحت مجوز **GNU General Public License v3.0 (GPL-3.0-or-later)** ([LICENSE](LICENSE)).
- بسته‌های Rust: به‌صورت مستقل [MIT](rust/LICENSE-MIT) / [Apache-2.0](rust/LICENSE-APACHE) و همراه Wmimo تحت GPL-3.0.
- مؤلفه‌های شخص ثالث: [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md)، [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)

---

<a id="sec-community"></a>

## انجمن و پشتیبانی

- **وب‌سایت رسمی**: [wmimo.buzz](https://wmimo.buzz) · **کانال تلگرام**: [t.me/wmimoapp](https://t.me/wmimoapp) · **ایمیل نویسنده**: [aisaniya@proton.me](mailto:aisaniya@proton.me) · **گزارش خطا**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

**قدردانی**: **[GooRingX (vowe)](https://github.com/GooRingX)** · **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** · **[Flutter](https://flutter.dev/)**
