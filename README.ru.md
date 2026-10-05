# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>Современный кроссплатформенный GUI-клиент прокси Clash / Mihomo</h3>
  <p>Создан на Flutter с ядром Mihomo, обеспечивая сверхбыстрый, элегантный и мощный прокси-сервис.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>

  <br/>
  <img src="docs/preview.png" alt="Wmimo Интерфейс" width="380" />
  <br/>
  <sub><em>✨ Эстетика микро-карточек 18px, мониторинг трафика в реальном времени и диагностика сети</em></sub>
</div>

---

## 📌 Поддержка платформ и дистрибутивов Linux

| Платформа | Статус | Формат пакетов | Описание |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **Готово** | Установщик (`.exe`) и Portable (`.zip`) | Боковая панель, меню в трее, график трафика, режим TUN, автообновление. |
| 🐧 **Linux** | ✅ **Готово** | AppImage (`.AppImage`), Debian (`.deb`), RPM (`.rpm`), Portable (`.tar.gz`) | Нативный интерфейс GTK3, интеграция с системным треем, встроенное ядро Mihomo. |
| 📱 **Android** | ✅ **Готово** | Universal APK и Split ABIs | Интеграция VpnService, постоянная подпись Release, адаптивный интерфейс. |
| 🍎 **macOS** | 🛠️ **Исходный код готов** | DMG / Локальная сборка | Системный прокси и режим TUN реализованы в коде. Поддерживается локальная сборка (`flutter run -d macos`); готовые DMG не публикуются в Release. |
| 🍏 **iOS** | 📦 **Архитектура готова** | IPA / Исходный код | Архитектура NetworkExtension интегрирована. Из-за требований к сертификатам Apple официальный IPA не распространяется. |

> 💡 **Политика распространения**: Официальный CI/CD выпускает сборки для **Windows**, **Linux** и **Android**. Исходный код macOS и iOS готов, но предварительно скомпилированные пакеты для платформ Apple не публикуются в Releases.

---

## 💖 Поддержка и донаты

- **Валюта (Token)**: `USDT`
- **Сеть (Network)**: `APTOS`
- **Адрес (Address)**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📬 Связь с автором и отчет об ошибках

Если вы столкнулись с ошибками или у вас есть предложения по улучшению, свяжитесь с автором:

- 📧 **Электронная почта автора**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- 🐛 **GitHub Issues**: [Создать Issue](https://github.com/aimy1/Wmimo/issues)

---

## 📄 Лицензия

Проект распространяется под лицензией **GPL-3.0**. См. файл [LICENSE](LICENSE).
