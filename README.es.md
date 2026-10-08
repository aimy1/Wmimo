# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>Cliente GUI de proxy moderno y multiplataforma para Clash / Mihomo</h3>
  <p>Desarrollado con Flutter y el núcleo Mihomo, ofreciendo una experiencia de proxy ultrarrápida, elegante y potente.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram" alt="Telegram" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="Wmimo Vista Previa" width="380" />
  <br/>
  <sub><em>✨ Diseño moderno de micro-tarjetas de 18px, monitoreo de tráfico en tiempo real y herramientas de diagnóstico</em></sub>
</div>

---

## 📌 Matriz de soporte de plataformas y Linux

| Plataforma | Estado | Formatos soportados | Descripción |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **Listo para producción** | Instalador (`.exe`) y Portable (`.zip`) | Barra lateral, menú de bandeja del sistema, gráfico de velocidad en tiempo real, modo TUN, autoactualización. |
| 🐧 **Linux** | ✅ **Listo** | AppImage (`.AppImage`), Debian (`.deb`), RPM (`.rpm`), Portable (`.tar.gz`) | Interfaz GTK3 nativa, soporte de bandeja del sistema, núcleo Mihomo integrado. |
| 📱 **Android** | ✅ **Listo** | APK Universal y APKs por ABI | Integración VpnService, firma Release permanente, interfaz móvil compacta. |
| 🍎 **macOS** | 🛠️ **Código listo** | DMG / Compilación local | Proxy del sistema y modo TUN implementados en código. Admite compilación local (`flutter run -d macos`); no se distribuyen DMG precompilados en Release. |
| 🍏 **iOS** | 📦 **Estructura lista** | IPA / Código fuente | Arquitectura NetworkExtension integrada. No se distribuyen paquetes IPA oficiales debido a requisitos de certificados de Apple. |

> 💡 **Política de distribución**: El CI/CD oficial se centra en distribuir paquetes para **Windows**, **Linux** y **Android**. El código fuente de macOS e iOS está listo, pero no se distribuyen binarios precompilados en Releases.

---

## 📬 Contacto con el autor y reporte de errores

Si encuentra algún error, fallo o tiene sugerencias de mejora, póngase en contacto con el autor:

- 💬 **Telegram**: [t.me/wmimoapp](https://t.me/wmimoapp)
- 📧 **Correo del autor**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- 🐛 **GitHub Issues**: [Enviar un Issue](https://github.com/aimy1/Wmimo/issues)

---

## 📄 Licencia

Este proyecto está bajo la licencia **GPL-3.0**. Consulte el archivo [LICENSE](LICENSE).
