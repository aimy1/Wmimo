# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>کلاینت مدرن، سریع و چندسکویی پروکسی Clash / Mihomo با رابط کاربری نسل جدید</strong></p>
  <p align="center">طراحی شده با Flutter و هسته قدرتمند Mihomo. ترکیبی از سرعت بی‌نظیر، زیبایی مدرن و پشتیبانی از کلیه پروتکل‌های پروکسی.</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>دانلود فایل‌های نصبی</b></a> •
    <a href="https://wmimo.buzz"><b>وب‌سایت رسمی</b></a> •
    <a href="#ویژگیهای-کلیدی"><b>ویژگی‌های کلیدی</b></a> •
    <a href="docs/BENCHMARKS.md"><b>معیارهای عملکرد</b></a> •
    <a href="#شروع-سریع"><b>شروع سریع</b></a> •
    <a href="#کامپایل-از-سورس-کد"><b>کامپایل سورس</b></a> •
    <a href="https://t.me/wmimoapp"><b>انجمن</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo تم روشن" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo تم تاریک" width="370" />
  </p>
  <sub><em>طراحی کارت‌های میکرو ۱۸ پیکسلی، نمودار روان و لحظه‌ای ترافیک و ابزارهای جامع عیب‌یابی شبکه (تم روشن و تاریک)</em></sub>
</div>

---

## ویژگی‌های کلیدی

- **رابط کاربری هنری با کارت‌های میکرو و دو تم اختصاصی**:
  - گوشه‌های گرد ۱۸ پیکسلی به همراه المان‌های آبی فیروزه‌ای چشم‌نواز.
  - پشتیبانی روان و سریع از دو حالت روشن (Light) و تاریک عمیق (Dark).
  - طراحی واکنش‌گرا متناسب با نمایشگرهای عریض دسکتاپ و صفحات لمسی موبایل.
- **هسته قدرتمند Mihomo (Meta)**:
  - پشتیبانی از تمام پروتکل‌ها: Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH و Direct.
  - پردازش غیرهمزمان در ایزولیت پس‌زمینه — بارگذاری روان و بدون قفل شدن رابط کاربری (۵٬۰۰۰ نود در حدود ۱۶۳ میلی‌ثانیه، [معیارهای عملکرد](docs/BENCHMARKS.md) را ببینید).
- **مسیریابی هوشمند و دو حالت پروکسی**:
  - تغییر سریع حالت: **بر اساس قوانین (Rule)** / **سراسری (Global)** / **مستقیم (Direct)**.
  - انعطاف‌پذیری دوگانه: **حالت آداپتور مجازی TUN** (گرفتن کامل ترافیک سیستم) و **پروکسی سیستمی (System Proxy)** بدون نیاز به دسترسی ادمین.
  - تفکیک ترافیک برنامه‌ها در اندروید و ابزار معافیت Loopback در ویندوز.
- **نمودار ترافیک لحظه‌ای و ابزارهای تحلیل شبکه**:
  - نمودار موجی نرم بزیه در بازه‌های مختلف (۱، ۵، ۱۵، ۳۰ و ۶۰ دقیقه).
  - کارت نمایش آی‌پی خروجی، موقعیت مکانی و رساننده اینترنت با کپی آسان و ماسک امنیتی داده‌ها.
  - نمایش میزان مصرف ترافیک و روزهای باقی‌مانده از اشتراک.
  - ابزارهای عیب‌یابی پیشرفته: بررسی قوانین مسیر، لاگ لحظه‌ای هسته، پینگ همزمان و مشاهده تنظیمات فعال.
- **یکپارچگی عمیق با سیستم‌عامل‌ها**:
  - **Windows**: منوی کلیک راست سینی ویندوز هماهنگ با تم برنامه، نمایش لحظه‌ای سرعت دانلود/آپلود در آیکون، سبک مدرن `comctl32 v6`.
  - **Android**: اعلان دائمی با دکمه قطع اتصال سریع، کاشی تنظیمات سریع (Quick Settings) و هماهنگی همزمان زبان.
  - **macOS**: پشتیبانی از آیکون نوار وضعیت Template و تنظیم خودکار پروکسی سیستم.
- **بروزرسانی خودکار و بی‌صدا چندکاناله**:
  - جابجایی آزاد بین کانال پایدار (`stable`) و پیش‌نمایش آزمایشی (`beta`).
  - دانلود بی‌صدا در پس‌زمینه با اعتبارسنجی هش SHA-256.
- **پوشش ۱۰۰ درصدی برای ۹ زبان**:
  - پشتیبانی کامل از ۷۹۸ کلید در زبان‌های فارسی، انگلیسی، چینی (ساده/سنتی)، ژاپنی، کره‌ای، روسی، اسپانیایی و عربی بدون هیچ کلید مفقودی (به [معیارهای عملکرد](docs/BENCHMARKS.md) مراجعه کنید).

---

## شروع سریع

1. **دانلود**: بسته متناسب با سیستم‌عامل خود را از بخش [Releases](https://github.com/aimy1/Wmimo/releases) دریافت کنید.
2. **افزودن اشتراک**: در بخش «اشتراک‌ها»، لینک اشتراک Clash/Mihomo را جای‌گذاری کرده یا فایل YAML محلی را وارد کنید.
3. **اتصال**: کلید اتصال در بالای صفحه اصلی را لمس کنید تا ارتباط پروکسی برقرار شود.
   - *نکته ویندوز*: برای **حالت TUN**، برنامه را با کلیک راست و گزینه Run as administrator اجرا نمایید؛ برای استفاده روزمره **حالت پروکسی سیستم** نیز کافی خواهد بود.

---

## کامپایل از سورس کد

### پیش‌نیازها
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- ابزارهای کامپایل سیستم میزبان (Windows: Visual Studio 2022 C++, Linux: GTK3/Clang/CMake, Android: Android SDK)

### دستورات سریع

```bash
# ۱. کلون کردن مخزن
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# ۲. دریافت وابستگی‌ها و تولید کدهای زبان
flutter pub get
dart run slang

# ۳. دانلود هسته‌های Mihomo برای تمامی پلتفرم‌ها
dart run tool/download_all_cores.dart

# ۴. اجرای نسخه توسعه
flutter run

# ۵. کامپایل بسته‌های نهایی انتشار
flutter build windows --release   # Windows
flutter build apk --release       # Android
flutter build linux --release     # Linux
flutter build macos --release     # macOS
```

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## عملکرد و اعتبارسنجی کیفیت

کارایی معماری و پوشش قابلیت‌های Wmimo توسط آزمون‌های خودکار و مستقل قابل تکرار تضمین می‌شود:

- **نرخ پردازش اشتراک**: ~۳۰٬۶۷۰ نود در ثانیه (۵٬۰۰۰ نود با پروتکل‌های گوناگون در ایزولیت پس‌زمینه ظرف حدود ۱۶۳ میلی‌ثانیه پردازش و مرتب می‌شوند).
- **تشخیص سریع قالب**: بررسی ۱٬۰۰۰ نود توسط الگوریتم `isClashYaml` در حدود ۱٫۴ میلی‌ثانیه.
- **میزان پوشش زبان‌ها**: ۹ زبان با ۷۹۸ کلید و تطابق ۱۰۰٫۰٪ بدون هیچ کلید گمشده‌ای.
- **دستورات بررسی خودکار**: اجرای `flutter test test/benchmark_profile_scale_test.dart` و `flutter test test/i18n_integrity_test.dart`.

متدولوژی کامل، نمودارهای آماری و مشخصات سخت‌افزاری در [docs/BENCHMARKS.md](docs/BENCHMARKS.md) شرح داده شده است.

---

## تشکر و قدردانی

- **[GooRingX (vowe)](https://github.com/GooRingX)**: کمال سپاس برای مشارکت‌های ارزشمند متن‌باز، بینش‌های معماری و الهام‌بخشی در طراحی.
- **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**: تشکر صمیمانه از تیم Mihomo برای ساخت این هسته پروکسی پرسرعت و منعطف.
- **[Flutter](https://flutter.dev/)**: سپاس از گوگل و جامعه فلاتر برای ساخت این فریم‌ورک مدرن و قدرتمند رابط کاربری.

---

## جامعه و ارتباط

- **وب‌سایت رسمی**: [wmimo.buzz](https://wmimo.buzz)
- **کانال رسمی تلگرام**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **ایمیل**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **گزارش باگ و اشکالات**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## مجوز

این پروژه تحت مجوز **GNU General Public License v3.0 (GPL-3.0-or-later)** منتشر شده است. برای جزئیات بیشتر به فایل [LICENSE](LICENSE) مراجعه کنید.

- **بسته‌های Rust Workspace**: به صورت مستقل تحت مجوز دوگانه [MIT](rust/LICENSE-MIT) یا [Apache-2.0](rust/LICENSE-APACHE) و هنگام توزیع همراه با Wmimo تحت GPL-3.0 قرار می‌گیرند.
- **مجوزهای شخص ثالث و هسته**: به فایل‌های [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) و [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md) مراجعه فرمایید.
