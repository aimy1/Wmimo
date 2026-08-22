# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>Современный кроссплатформенный GUI-клиент Clash / Mihomo</h3>
  <p>Создан на базе Flutter и ядра Mihomo, обеспечивая сверхбыструю, элегантную и мощную работу с прокси.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>
</div>

---

## 🔥 Что нового в ветке Beta (What's New in Beta)

> [!TIP]
> Это **тестовая ветка `beta`**, включающая расширенную поддержку протоколов, оптимизацию для Linux и повышенную стабильность узлов:

- 🔄 **Универсальный конвертер подписок (`SubscriptionConverter`)**:
  - Автоматическое распознавание и декодирование **подписок Base64** и ссылок на отдельные узлы (`vmess://`, `vless://` с Reality/Vision, `ss://`, `trojan://`, `hysteria2://` / `hy2://`, `tuic://` и др.);
  - Автоматическое создание региональных групп (🇭🇰 Гонконг, 🇯🇵 Япония, 🇸🇬 Сингапур, 🇹🇼 Тайвань, 🇺🇸 США, 🇰🇷 Корея и др.), `Выбор узла`, `Автовыбор`, `Fallback` и правил маршрутизации;
  - Возможность прямой вставки ссылок на узлы или текста Base64 в окне добавления профиля.
- 🐧 **Стабильность подключения в Linux и исправление прав `work_dir`**:
  - Рабочий каталог `work_dir` перенесен в доступную для записи директорию `~/.local/share/wmimo`, что устраняет ошибки доступа к `cache.db` в AppImage;
  - Полная генерация `proxy-groups:` перед запуском ядра, устраняющая проблему исчезновения узлов после подключения.
- 🎯 **Точная фильтрация внутренних адаптеров ядра**:
  - Исключение внутренних служебных адаптеров Mihomo Meta (`COMPATIBLE`, `PASS`, `PASS-RULE`, `REJECT-DROP`, `DIRECT`, `REJECT`, `DNS`);
  - Тест задержки (⚡) и сетка карточек работают исключительно с реальными прокси-узлами.
- 📦 **Поддержка всех основных дистрибутивов Linux**:
  - Готовые пакеты AppImage, Debian/Ubuntu (`.deb`), Fedora/RHEL (`.rpm`), Arch Linux (`.pkg.tar.zst` & `PKGBUILD`) и архив (`.tar.gz`).

---

## 📌 Поддержка платформ

| Платформа | Статус | Форматы пакетов | Описание |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **Готово** | Установщик (`.exe`) и Портативная версия (`.zip`) | Боковая панель, трей с мониторингом скорости, TUN-режим, автообновление. |
| 🐧 **Linux** | ✅ **Готово** | Пакет Debian (`.deb`) и Архив (`.tar.gz`) | Нативный интерфейс GTK3, интеграция с треем, встроенное ядро Mihomo. |
| 📱 **Android** | ✅ **Готово** | Универсальный APK и раздельные ABI | Драйвер VpnService, оптимизированный интерфейс. |
| 🍎 **macOS** | 🚧 **В разработке** | DMG | Адаптация NetworkExtension. |
| 🍏 **iOS** | 🚧 **В разработке** | IPA | Адаптация NetworkExtension. |

---

## ✨ Основные возможности

- 🎨 **Современный интерфейс**: Светлая и темная темы, адаптивный дизайн (мобильный и десктопный интерфейс).
- ⚡ **Ядро Mihomo**: Поддержка Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard.
- 🔀 **Системный трей**: Скорость сети в реальном времени, переключение режимов (Rule/Global/Direct), тест задержки.
- 📊 **Мониторинг трафика**: Плавный график трафика, карточка IP/ISP в реальном времени, сворачиваемые группы прокси.
- 🚀 **Автообновление**: Каналы `stable` и `beta` с фоновой загрузкой и проверкой SHA-256.
- 🌍 **9 языков**: Русский, Английский, Китайский, Японский, Корейский, Испанский, Арабский, Персидский.

---

## 💖 Поддержать проект

- **Валюта**: `USDT`
- **Сеть**: `APTOS`
- **Адрес кошелька**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 Лицензия

Проект распространяется под лицензией **GPL-3.0**.
