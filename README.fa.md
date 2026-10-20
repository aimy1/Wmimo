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
    <a href="#ویژگیهای-کلیدی"><b>ویژگی‌های کلیدی</b></a> •
    <a href="#شروع-سریع"><b>شروع سریع</b></a> •
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
  - پشتیبانی از تمام پروتکل‌ها: Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard و Direct.
  - پردازش غیرهمزمان در پس‌زمینه — **بدون هیچ‌گونه هنگ یا افت فریم در رابط کاربری (Zero UI Freeze)**.
- **مسیریابی هوشمند و دو حالت پروکسی**:
  - تغییر سریع حالت: **بر اساس قوانین (Rule)** / **سراسری (Global)** / **مستقیم (Direct)**.
  - انعطاف‌پذیری دوگانه: **حالت آداپتور مجازی TUN** و **پروکسی سیستمی (System Proxy)**.
  - تفکیک ترافیک برنامه‌ها در اندروید و ابزار معافیت Loopback در ویندوز.
- **نمودار ترافیک لحظه‌ای و ابزارهای تحلیل شبکه**:
  - نمودار موجی نرم بزیه در بازه‌های مختلف (۱، ۵، ۱۵، ۳۰ و ۶۰ دقیقه).
  - کارت نمایش آی‌پی خروجی، موقعیت مکانی و رساننده اینترنت با کپی آسان.
  - نمایش میزان مصرف ترافیک و روزهای باقی‌مانده از اشتراک.
- **یکپارچگی عمیق با سیستم‌عامل‌ها**:
  - **Windows**: منوی کلیک راست سینی ویندوز هماهنگ با تم برنامه، نمایش لحظه‌ای سرعت دانلود/آپلود در آیکون، سبک مدرن `comctl32 v6`.
  - **Android**: اعلان دائمی با دکمه قطع اتصال سریع، کاشی تنظیمات سریع (Quick Settings) و هماهنگی همزمان زبان.
  - **macOS**: پشتیبانی از آیکون نوار وضعیت Template.
- **پوشش ۱۰۰ درصدی برای ۹ زبان**:
  - پشتیبانی کامل از زبان‌های فارسی، انگلیسی، چینی (ساده/سنتی)، ژاپنی، کره‌ای، روسی، اسپانیایی و عربی.

---

## شروع سریع

1. **دانلود**: بسته متناسب با سیستم‌عامل خود را از بخش [Releases](https://github.com/aimy1/Wmimo/releases) دریافت کنید.
2. **افزودن اشتراک**: در بخش «اشتراک‌ها»، لینک اشتراک Clash/Mihomo را جای‌گذاری کنید.
3. **اتصال**: کلید اتصال در بالای صفحه اصلی را لمس کنید تا ارتباط پروکسی برقرار شود.
   - *نکته ویندوز*: برای **حالت TUN**، برنامه را با کلیک راست و گزینه Run as administrator اجرا نمایید؛ برای استفاده روزمره **حالت پروکسی سیستم** نیز کافی خواهد بود.

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## جامعه و ارتباط

- **کانال رسمی تلگرام**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **ایمیل**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **گزارش باگ و اشکالات**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## مجوز

این پروژه تحت مجوز **GPL-3.0** منتشر شده است. برای جزئیات بیشتر به فایل [LICENSE](LICENSE) مراجعه کنید.
