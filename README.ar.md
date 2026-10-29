# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>عميل بروكسي حديث متعدد المنصات لـ Clash / Mihomo بواجهة رسومية من الجيل التالي</strong></p>
  <p align="center">تم تطويره باستخدام Flutter ونواة Mihomo عالية الأداء لتوفير سرعة فائقة وتصميم عصري ودعم شامل لجميع البروتوكولات.</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>تنزيل الإصدارات</b></a> •
    <a href="#الميزات-الرئيسية"><b>الميزات الرئيسية</b></a> •
    <a href="#البدء-السريع"><b>البدء السريع</b></a> •
    <a href="https://t.me/wmimoapp"><b>المجتمع</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo المظهر الفاتح" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo المظهر الداكن" width="370" />
  </p>
  <sub><em>تصميم عصري ببطاقات مصغرة 18px، مراقبة حركة المرور في الوقت الفعلي وأدوات تشخيص شاملة (المظهر الفاتح والداكن)</em></sub>
</div>

---

## الميزات الرئيسية

- **واجهة بطاقات متطورة ومظهر مزدوج أصيل**:
  - تصميم دقيق بحواف مستديرة 18px مع لمسات زرقاء سماوية أنيقة.
  - دعم أصلي وسلس للمظهرين الفاتح (Light) والداكن (Dark).
  - تخطيط متكيف للشاشات الكبيرة والهواتف المحمولة.
- **نواة Mihomo فائقة السرعة**:
  - دعم جميع البروتوكولات: Shadowsocks وVMess وVLESS وTrojan وHysteria 1/2 وTUIC وWireGuard.
  - معالجة غير متزامنة في الخلفية — **انعدام تام لتجمد الواجهة (Zero UI Freeze)**.
- **توجيه ذكي ومحركا وكيل**:
  - تبديل فوري لأنماط الخروج: **القواعد (Rule)** / **شامل (Global)** / **مباشر (Direct)**.
  - **وضع محول الشبكة الظاهرية TUN** و **وضع وكيل النظام**.
  - وكيل لكل تطبيق على Android وأداة UWP Loopback على Windows.
- **مراقبة حركة البيانات في الوقت الفعلي**:
  - رسم بياني لحركة البيانات في الوقت الفعلي مع خيارات فترات زمنية متعددة.
  - بطاقة الاستعلام الفوري عن عنوان IP والموقع ومزود الخدمة.
  - شريط تقدم استهلاك الباقة والعد التنازلي لانتهاء الصلاحية.
- **تكامل عميق مع أنظمة التشغيل**:
  - **Windows**: قائمة شريط المهام متكيفة مع مظهر التطبيق، وعرض حي لسرعة الشبكة، ودعم `comctl32 v6`.
  - **Android**: إشعار دائم مع زر قطع اتصال سريع، وبلاطة الإعدادات السريعة، وتزامن اللغة فورياً.
  - **macOS**: دعم أيقونة شريط القوائم التكيفية Template.
- **دعم كامل لـ 9 لغات عالمية**:
  - تغطية بنسبة 100% لـ 798 مفتاح ترجمة عبر اللغات المدعومة مع 0 مفاتيح مفقودة (راجع [docs/BENCHMARKS.md](docs/BENCHMARKS.md)).

---

## البدء السريع

1. **التنزيل**: حمّل الحزمة المناسبة لنظامك من صفحة [الإصدارات](https://github.com/aimy1/Wmimo/releases).
2. **استيراد الاشتراك**: افتح قسم «الاشتراكات» والصق رابط اشتراك Clash/Mihomo.
3. **الاتصال**: اضغط على زر التبديل في الصفحة الرئيسية لبدء التوجيه.
   - *ملاحظة لنظام Windows*: لاستخدام **وضع TUN**، يرجى تشغيل التطبيق كمسؤول؛ وللاستخدام اليومي يكفي **وضع وكيل النظام**.

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## المجتمع

- **قناة تيليجرام الرسمية**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **البريد الإلكتروني**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **الإبلاغ عن المشكلات**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## الترخيص

هذا المشروع مرخص بموجب **رخصة جنو العمومية v3.0 (GPL-3.0)**. انظر ملف [LICENSE](LICENSE) للمزيد من التفاصيل.
