# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>کلاینت گرافیکی مدرن و چندسکویی پروکسی Clash / Mihomo</h3>
  <p>ساخته شده با Flutter و هسته Mihomo، ارائه دهنده تجربه پروکسی فوق‌العاده سریع، زیبا و قدرتمند.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram" alt="Telegram" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="پیش‌نمایش Wmimo" width="380" />
  <br/>
  <sub><em>✨ طراحی کارت‌های میکرو ۱۸ پیکسلی، مانیتورینگ بلادرنگ ترافیک و ابزارهای تشخیص شبکه</em></sub>
</div>

---

## 📌 وضعیت پشتیبانی از پلتفرم‌ها و لینوکس

| پلتفرم | وضعیت | فرمت بسته‌ها | توضیحات |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **آماده استفاده** | فایل نصبی (`.exe`) و قابل حمل (`.zip`) | نوار کناری دسکتاپ، منوی تسک‌بار، نمودار بلادرنگ ترافیک، حالت TUN، آپدیت خودکار. |
| 🐧 **Linux** | ✅ **آماده** | AppImage (`.AppImage`), Debian (`.deb`), RPM (`.rpm`), Portable (`.tar.gz`) | رابط GTK3 بومی، پشتیبانی از سینی سیستم، هسته داخلی Mihomo. |
| 📱 **Android** | ✅ **آماده** | APK عمومی و تفکیک شده بر اساس معماری | یکپارچه‌سازی درایور VpnService، امضای دائمی Release، رابط فشرده موبایل. |
| 🍎 **macOS** | 🛠️ **کد آماده** | DMG / ساخت محلی | پروکسی سیستم و حالت TUN به طور کامل در کد پیاده‌سازی شده‌اند. پشتیبانی از بیلد محلی (`flutter run -d macos`)؛ فایل‌های DMG از پیش ساخته منتشر نمی‌شوند. |
| 🍏 **iOS** | 📦 **معماری آماده** | IPA / کد منبع | معماری NetworkExtension یکپارچه‌سازی شده است. به دلیل الزامات امضای اپل، فایل IPA رسمی منتشر نمی‌شود؛ استفاده از برنامه‌های دیگر پیشنهاد می‌شود. |

> 💡 **خط‌مشی انتشار**: فرآیند رسمی CI/CD بسته‌های از پیش ساخته شده را برای **Windows**، **Linux** و **Android** ارائه می‌دهد. کدهای macOS و iOS آماده هستند اما بسته‌های از پیش ساخته برای پلتفرم‌های اپل منتشر نمی‌شوند.

---

## 📬 ارتباط با نویسنده و گزارش خطا

اگر با هرگونه باگ، کرش یا مشکلی مواجه شدید یا پیشنهادی برای بهبود دارید، با نویسنده در ارتباط باشید:

- 💬 **Telegram**: [t.me/wmimoapp](https://t.me/wmimoapp)
- 📧 **ایمیل نویسنده**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- 🐛 **GitHub Issues**: [ثبت Issue](https://github.com/aimy1/Wmimo/issues)

---

## 📄 مجوز

این پروژه تحت مجوز **GPL-3.0** منتشر شده است. برای اطلاعات بیشتر به فایل [LICENSE](LICENSE) مراجعه کنید.
