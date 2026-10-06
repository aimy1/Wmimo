# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>عميل بروكسي حديث متعدد المنصات لـ Clash / Mihomo بواجهة رسومية</h3>
  <p>تم بناؤه باستخدام Flutter ونواة Mihomo لتقديم تجربة وكيل سريعة وأنيقة وقوية.</p>

  <p>
    <a href="https://wmimo.buzz"><img src="https://img.shields.io/badge/الموقع_الرسمي-wmimo.buzz-00BCDF?style=flat-square&logo=googlechrome&logoColor=white" alt="الموقع الرسمي" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="معاينة Wmimo" width="380" />
  <br/>
  <sub><em>✨ واجهة عصرية ببطاقات مصغرة 18px، مراقبة حركة المرور في الوقت الفعلي وأدوات تشخيص الشبكة</em></sub>
</div>

---

## 📌 دعم المنصات وتوزيعات Linux

| المنصة | الحالة | التنسيقات المدعومة | الوصف |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **جاهز** | مثبت (`.exe`) ومحمول (`.zip`) | شريط جانبي، قائمة شريط المهام، رسم بياني للسرعة، وضع TUN، تحديث تلقائي. |
| 🐧 **Linux** | ✅ **جاهز** | AppImage (`.AppImage`), Debian (`.deb`), RPM (`.rpm`), Portable (`.tar.gz`) | واجهة GTK3 أصلية، تكامل شريط المهام، نواة Mihomo مدمجة. |
| 📱 **Android** | ✅ **جاهز** | APK شامل و APK مقسم حسب المعمارية | تكامل VpnService، توقيع Release دائم، واجهة هاتف مضغوطة. |
| 🍎 **macOS** | 🛠️ **الكود جاهز** | DMG / بناء محلي | تم تطبيق بروكسي النظام ووضع TUN في الكود. يدعم البناء المحلي (`flutter run -d macos`)؛ لا يتم توفير حزم DMG مسبقة البناء في الإصدارات الرسمية. |
| 🍏 **iOS** | 📦 **الهيكل جاهز** | IPA / المصدر | بنية NetworkExtension متكاملة. لا يتم توزيع ملفات IPA رسمية بسبب قيود شهادات Apple؛ يُنصح باستخدام تطبيقات بديلة للاشتراكات. |

> 💡 **سياسة التوزيع**: يوفر CI/CD الرسمي حزمًا مسبقة الصنع لأنظمة **Windows** و **Linux** و **Android**. كود macOS و iOS جاهز، ولكن لا يتم توفير حزم جاهزة لأنظمة Apple في الإصدارات الرسمية.

---

## 📬 التواصل مع المطور والإبلاغ عن الأخطاء

إذا واجهت أي أخطاء أو أعطال أو كان لديك اقتراحات للتحسين، فلا تتردد في التواصل مع المطور:

- 🌐 **الموقع الرسمي**: [https://wmimo.buzz](https://wmimo.buzz/)
- 📧 **بريد المطور**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- 🐛 **GitHub Issues**: [إرسال مشكلة](https://github.com/aimy1/Wmimo/issues)

---

## 📄 الترخيص

هذا المشروع مرخص بموجب رخصة **GPL-3.0**. راجع ملف [LICENSE](LICENSE).
