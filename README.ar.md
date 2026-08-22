# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>عميل بروكسي حديث متعدد المنصات لـ Clash / Mihomo</h3>
  <p>تم بناؤه باستخدام Flutter ونواة Mihomo لتوفير تجربة بروكسي سريعة وأنيقة وقوية لجميع البروتوكولات.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>
</div>

---

## 🔥 الميزات الجديدة في فرع Beta (What's New in Beta)

> [!TIP]
> هذا هو فرع **المعاينة التجريبية `beta`**، ويحتوي على دعم أحدث البروتوكولات، وتحسينات عميقة لبيئة Linux، واستقرار كامل لعرض الخوادم الوكيلة:

- 🔄 **محول الاشتراكات الشامل متعدد البروتوكولات (`SubscriptionConverter`)**:
  - كشف وفك تشفير تلقائي لاشتراكات **Base64** وروابط الخوادم الفردية (`vmess://`، `vless://` مع Reality/Vision، `ss://`، `trojan://`، `hysteria2://` / `hy2://`، `tuic://`، إلخ)؛
  - إنشاء تلقائي للمجموعات الإقليمية (🇭🇰 هونغ كونغ، 🇯🇵 اليابان، 🇸🇬 سنغافورة، 🇹🇼 تايوان، 🇺🇸 الولايات المتحدة، 🇰🇷 كوريا، إلخ)، و`اختيار العقدة`، و`الاختيار التلقائي`، و`Fallback`، وقواعد التوجيه؛
  - إمكانية لصق الروابط المباشرة أو نصوص Base64 مباشرة في شاشة "إضافة ملف تعريف".
- 🐧 **استقرار الاتصال على Linux وإصلاح أذونات `work_dir`**:
  - تعيين مسار عمل النواة `work_dir` إلى المسار القابل للكتابة `~/.local/share/wmimo` لحل مشكلة أذونات `cache.db` في حزم AppImage؛
  - توليد كامل لـ `proxy-groups:` قبل بدء النواة لمنع اختفاء الخوادم بعد الاتصال.
- 🎯 **تصفية دقيقة للمحولات الداخلية للنواة**:
  - استبعاد المحولات الداخلية الخاصة بـ Mihomo Meta (`COMPATIBLE`، `PASS`، `PASS-RULE`، `REJECT-DROP`، `DIRECT`، `REJECT`، `DNS`)؛
  - حصر اختبارات السرعة (⚡) والبطاقات على خوادم البروكسي الحقيقية فقط.
- 📦 **دعم جميع توزيعات Linux الرئيسية**:
  - توفير حزم AppImage، وDebian/Ubuntu (`.deb`)، وFedora/RHEL (`.rpm`)، وArch Linux (`.pkg.tar.zst` & `PKGBUILD`)، والحزمة المحمولة (`.tar.gz`).

---

## 📌 دعم المنصات

| المنصة | الحالة | نوع الحزمة | المميزات |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **جاهز** | مثبت (`.exe`) ومحمول (`.zip`) | شريط جانبي لسطح المكتب، قائمة شريط المهام، وضع TUN، تحديث تلقائي. |
| 🐧 **Linux** | ✅ **جاهز** | حزمة دبيان (`.deb`) ومحمول (`.tar.gz`) | واجهة GTK3 أصلية، تكامل مع شريط النظام، نواة Mihomo مدمجة. |
| 📱 **Android** | ✅ **جاهز** | APK شامل وحزم مخصصة لكل معمارية | محرك VpnService مدمج، واجهة هاتف مضغوطة. |
| 🍎 **macOS** | 🚧 **قيد التطوير** | مثبت DMG | جاري تكييف NetworkExtension. |
| 🍏 **iOS** | 🚧 **قيد التطوير** | IPA | جاري تكييف NetworkExtension. |

---

## ✨ المميزات الرئيسية

- 🎨 **واجهة مستخدم عصرية وأنيقة**: دعم كامل للوضع الداكن والفاتح، تصميم متكيف وسلس.
- ⚡ **نواة Mihomo عالية الأداء**: دعم كامل لجميع البروتوكولات (Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard).
- 🔀 **تكامل كامل مع شريط النظام**: عرض سرعة الرفع والتنزيل، تبديل أوضاع البروكسي بنقرة واحدة، اختبار الاستجابة (Ping).
- 📊 **مراقبة وتحليل حركة البيانات**: مخطط بياني فوري لحركة المرور، بطاقة معلومات IP و مزود الخدمة (ISP).
- 🚀 **تحديث تلقائي ذكي**: دعم قناتي `stable` (المستقرة) و `beta` (التجريبية).
- 🌍 **دعم 9 لغات عالمية**: العربية، الإنجليزية، الصينية، اليابانية، الكورية، الروسية، الإسبانية، الفارسية.

---

## 💖 التبرع والدعم

- **العملة**: `USDT`
- **الشبكة**: `APTOS`
- **العنوان**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 الترخيص

هذا المشروع مرخص بموجب **GPL-3.0**.
