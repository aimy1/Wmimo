# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>کلاینت مدرن و چندسکویی پروکسی Clash / Mihomo</h3>
  <p>ساخته شده با فلاتر و هسته قدرتمند Mihomo برای ارائه تجربه سریع، زیبا و کامل پروکسی.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>
</div>

---

## 🔥 ویژگی‌های جدید در شاخه Beta (What's New in Beta)

> [!TIP]
> این شاخه، شاخه **پیش‌نمایش آزمایشی `beta`** است که شامل پشتیبانی از جدیدترین پروتکل‌ها، بهینه‌سازی‌های لینوکس و پایداری گره‌های پروکسی است:

- 🔄 **مبدل سراسری و چندپروتکلی اشتراک (`SubscriptionConverter`)**:
  - شناسایی و رمزگشایی خودکار **اشتراک‌های Base64** و پیوندهای تکی (`vmess://`، `vless://` با Reality/Vision، `ss://`، `trojan://`، `hysteria2://` / `hy2://`، `tuic://` و غیره)؛
  - ایجاد خودکار گروه‌های منطقه‌ای (🇭🇰 هنگ‌کنگ، 🇯🇵 ژاپن، 🇸🇬 سنگاپور، 🇹🇼 تایوان، 🇺🇸 آمریکا، 🇰🇷 کره و غیره)، `انتخاب گره`، `انتخاب خودکار`، `Fallback` و قوانین مسیریابی؛
  - امکان الصاق مستقیم پیوندها یا متن Base64 در صفحه "افزودن نمایه".
- 🐧 **پایداری اتصال در لینوکس و تصحیح دسترسی `work_dir`**:
  - تغییر مسیر پوشه کاری هسته `work_dir` به مسیر قابل نوشتن `~/.local/share/wmimo` و رفع مشکل دسترسی به `cache.db` در AppImage؛
  - تضمین ساخت کامل `proxy-groups:` پیش از اجرای هسته و حل مشکل ناپدید شدن گره‌ها پس از اتصال.
- 🎯 **فیلتر دقیق آداپتورهای داخلی هسته**:
  - حذف آداپتورهای داخلی Mihomo Meta (`COMPATIBLE`، `PASS`、`PASS-RULE`、`REJECT-DROP`、`DIRECT`、`REJECT`、`DNS`)؛
  - اجرای تست پینگ (⚡) و نمایش کارت‌ها صرفاً برای گره‌های واقعی پروکسی.
- 📦 **پشتیبانی کامل از توزیع‌های مختلف لینوکس**:
  - بسته‌های AppImage (بدون نیاز به نصب)، Debian/Ubuntu (`.deb`)، Fedora/RHEL (`.rpm`)، Arch Linux (`.pkg.tar.zst` & `PKGBUILD`) و بسته فشرده قابل حمل (`.tar.gz`).

---

## 📌 وضعیت پلتفرم‌ها

| پلتفرم | وضعیت | فرمت پکیج | توضیحات |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **آماده استفاده** | فایل نصب (`.exe`) و پرتابل (`.zip`) | سایدبار دسکتاپ، منوی تسک‌بار کامل، حالت TUN، به‌روزرسانی خودکار. |
| 🐧 **Linux** | ✅ **آماده** | پکیج دبیان (`.deb`) و پرتابل (`.tar.gz`) | رابط کاربری بومی GTK3، آیکون سینی سیستم، هسته داخلی Mihomo لینوکس. |
| 📱 **Android** | ✅ **آماده** | APK عمومی و نسخه‌های تفکیک شده معماری | درایور VpnService سیستمی، رابط کاربری متناسب موبایل. |
| 🍎 **macOS** | 🚧 **در حال توسعه** | DMG | در حال پیاده‌سازی NetworkExtension. |
| 🍏 **iOS** | 🚧 **در حال توسعه** | IPA | در حال پیاده‌سازی NetworkExtension. |

---

## ✨ ویژگی‌های کلیدی

- 🎨 **رابط کاربری مدرن**: پشتیبانی از تم‌های روشن و تاریک، طراحی ریسپانسیو.
- ⚡ **هسته پرسرعت Mihomo**: پشتیبانی کامل از پروتکل‌های Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard.
- 🔀 **منوی تسک‌بار پیشرفته**: نمایش زنده سرعت دانلود و آپلود، تغییر سریع حالت‌های پروکسی، تست پینگ.
- 📊 **نظارت بر ترافیک**: نمودار ترافیک، کارت نمایش وضعیت IP و ISP، دسته‌بندی پروکسی‌ها با قابلیت جمع شدن.
- 🚀 **به‌روزرسانی خودکار چندکاناله**: انتخاب بین کانال‌های `stable` و `beta`.
- 🌍 **پشتیبانی از ۹ زبان بین‌المللی**: فارسی، انگلیسی، چینی، ژاپنی، کره‌ای، روسی، اسپانیایی، عربی.

---

## 💖 حمایت و دونیت

- **ارز**: `USDT`
- **شبکه**: `APTOS`
- **آدرس کیف پول**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 مجوز

این پروژه تحت مجوز **GPL-3.0** منتشر شده است.
