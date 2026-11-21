<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---

<div align="center">
  <img src="assets/images/app_icon_256.png" width="112" height="112" alt="Wmimo Logo" />
  <h1>Wmimo</h1>
  <p><strong>Кроссплатформенный GUI-клиент Clash / Mihomo нового поколения</strong></p>
  <p>Построен на Flutter и ядре Mihomo (v1.19.34). Нулевая телеметрия, многошаговые цепочки прокси, параллельная диагностика и замер скорости с живым графиком.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions/workflows/release.yml"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="CI Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://github.com/MetaCubeX/mihomo"><img src="https://img.shields.io/badge/Mihomo-v1.19.34-FF6B6B?style=flat-square" alt="Mihomo Core" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-%3E%3D3.35-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="#sec-platforms"><img src="https://img.shields.io/badge/Platforms-Win%20%7C%20macOS%20%7C%20Linux%20%7C%20Android%20%7C%20iOS-0EA5E9?style=flat-square" alt="Platforms" /></a>
    <a href="docs/BENCHMARKS.md"><img src="https://img.shields.io/badge/i18n-9%20Locales%20%C2%B7%20898%20Keys-10B981?style=flat-square" alt="i18n" /></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPL--3.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-%40wmimoapp-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><b>Скачать</b></a> •
    <a href="#sec-platforms"><b>Платформы</b></a> •
    <a href="#sec-features"><b>Возможности</b></a> •
    <a href="#sec-architecture"><b>Архитектура</b></a> •
    <a href="#sec-quickstart"><b>Быстрый старт</b></a> •
    <a href="#sec-build"><b>Сборка</b></a> •
    <a href="#sec-security"><b>Безопасность</b></a> •
    <a href="#sec-community"><b>Сообщество</b></a>
  </p>
</div>

| Светлая тема | Тёмная тема |
| :---: | :---: |
| <img src="docs/preview_light.png" alt="Wmimo Light Theme" width="380" /> | <img src="docs/preview_dark.png" alt="Wmimo Dark Theme" width="380" /> |

<p align="center"><sub><em>Карточный интерфейс 18px · График трафика Безье · Двойной движок TUN / Системный прокси</em></sub></p>

---

<a id="sec-platforms"></a>

## Поддерживаемые платформы и релизы

| Платформа | Архитектура | Форматы сборок | Ключевые возможности |
| :--- | :--- | :--- | :--- |
| **Windows** | `x64`, `arm64` | Установщик (`.exe`), Portable (`.zip`) | Системный прокси без прав, Wintun WHQL TUN (Админ), UWP Loopback, трей со скоростью, горячие клавиши |
| **macOS** | `Universal` (`arm64` + `x64`) | `.dmg`, Portable (`.zip`) | Безопасная авторизация сервиса/TUN, адаптивная иконка меню, iCloud Drive, глобальные клавиши |
| **Linux** | `x64`, `arm64` | `.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz` | `setcap` / TUN, системный прокси, GTK3 интерфейс, глобальные горячие клавиши |
| **Android** | `arm64-v8a`, `armeabi-v7a`, `x86_64` | Раздельные ABI и Universal `.apk` | Горячее переключение прокси по приложениям без рестарта ядра, контроль оптимизации батареи, плитка QS |
| **iOS** | `arm64` | Неподписанный `.ipa` (TrollStore / Sideload) | Network Extension VPN и синхронизация iCloud Drive ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)) |

> Скачивайте релизы на [GitHub Releases](https://github.com/aimy1/Wmimo/releases) и проверяйте подписи APK (SHA-256) / Wintun по [SECURITY.md](SECURITY.md).

---

<a id="sec-features"></a>

## Ключевые возможности

| Модуль | Описание |
| :--- | :--- |
| **Ядро Mihomo (`v1.19.34`)** | SS, VMess, VLESS Reality, Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH • Парсинг в Isolate (`5 000` узлов за `~163 мс`) |
| **Многошаговые цепочки `[Beta]`** | Оркестрация **`dialer-proxy`** (вход ➔ транзит... ➔ выход), перетаскивание шагов, защита от дублей, хранение в `chain_proxies.json` |
| **Прокси по приложениям (Android)** | Защита от утечки при пустом белом списке, горячая смена интерфейса VPN без перезапуска ядра, пресеты приложений |
| **Диагностика (`NetCheck`)** | 5-этапный параллельный конвейер (фильтрация TUN-адаптеров, проверка DNS и Fake-IP, порты, прокси/TUN, рукопожатие) + автоисправление |
| **Тест скорости (`SpeedTest`)** | Многопоточная загрузка/отдача HTTP, точный Ping/Jitter, живой график скорости, оценки сценариев и задержки серверов |
| **Резервное копирование** | WebDAV, iCloud Drive, локальный/URL `.zip`, включая `chain_proxies.json`, предварительная распаковка в буфер и защита от Zip-Slip |
| **UI и телеметрия** | Светлая/тёмная темы, менеджер карточек главной страницы, автоповорот включён по умолчанию, маска IP |
| **Приватность и 9 языков** | Ноль трекеров и рекламных SDK, **9 языков × 898 ключей (100%)** и 9 локализованных политик конфиденциальности |

### Маршрутизация и надёжность

- **Двойной движок**: мгновенное переключение Rule / Global / Direct в режимах TUN и системного прокси.
- **Атомарное восстановление**: проверка архива во временной папке перед заменой рабочих конфигураций.

---

<a id="sec-architecture"></a>

## Архитектура и структура кода

| Уровень | Назначение | Каталог |
| :--- | :--- | :--- |
| **UI и экраны** | Flutter (`>= 3.35.0`), карточки, Canvas-графики | [`lib/screens/`](lib/screens/) |
| **Логика и состояние** | Менеджеры настроек/цепочек/профилей, парсер Isolate | [`lib/app/`](lib/app/) |
| **VPN и нативный слой** | Обёртка сервиса, Android Kotlin (`WmimoVpnService.kt`) | [`third_party/libclash_vpn_service/`](third_party/libclash_vpn_service/), [`android/`](android/) |
| **Rust Crates** | Нативные модули рабочего пространства | [`rust/`](rust/) |
| **i18n и документы** | Slang (9 языков × 898 ключей) и политики конфиденциальности | [`lib/i18n/`](lib/i18n/), [`assets/txts/`](assets/txts/) |

---

<a id="sec-quickstart"></a>

## Быстрый старт

1. **Установка**: скачайте сборку для вашей ОС с [GitHub Releases](https://github.com/aimy1/Wmimo/releases).
2. **Импорт профиля**: добавьте ссылку подписки или YAML-файл в разделе подписок.
3. **Подключение**: активируйте главный переключатель на главном экране.

<details>
<summary><b>Советы по платформам (Windows / Android / macOS и Linux / iOS)</b></summary>

- **Windows**: Системный прокси работает без прав администратора; для TUN запустите от имени администратора. Для портативного режима создайте папку `portable`.
- **Android**: Рекомендуется исключить Wmimo из оптимизации батареи; изменения правил по приложениям применяются на лету.
- **iOS**: Распространяется как неподписанный `.ipa` ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)).

</details>

---

<a id="sec-build"></a>

## Сборка из исходников

### Требования

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) и [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- Инструменты сборки платформы (VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK)

### Команды

```bash
# 1. Clone repository
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. Fetch dependencies & generate i18n bindings
flutter pub get
dart run slang

# 3. Download prebuilt Mihomo cores
dart run tool/download_all_cores.dart

# 4. Run development build
flutter run

# 5. Build release artifacts
flutter build windows --release
flutter build macos --release
flutter build linux --release
flutter build apk --release
```

---

<a id="sec-benchmarks"></a>

## Производительность и тесты

- **Парсинг подписок**: `~30 670 узлов/с` (`5 000` узлов за `~163 мс` в Isolate).
- **Покрытие i18n**: **9/9 языков × 898 ключей = 100.0%** ([docs/BENCHMARKS.md](docs/BENCHMARKS.md)).

Подробный отчёт: [docs/BENCHMARKS.md](docs/BENCHMARKS.md).

<details>
<summary><b>История звёзд (Star History)</b></summary>

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

</details>

---

<a id="sec-security"></a>

## Безопасность, приватность и лицензия

- **Нулевой сбор данных**: [assets/txts/privacy_policy_ru.txt](assets/txts/privacy_policy_ru.txt)
- **Проверка отпечатков**: [SECURITY.md](SECURITY.md)

### Лицензия

**GNU General Public License v3.0 (GPL-3.0-or-later)** ([LICENSE](LICENSE)).

- Rust Crates: [MIT](rust/LICENSE-MIT) / [Apache-2.0](rust/LICENSE-APACHE) отдельно, GPL-3.0 в составе Wmimo.
- Сторонние компоненты: [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md), [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)

---

<a id="sec-community"></a>

## Благодарности

- **[GooRingX (vowe)](https://github.com/GooRingX)**
- **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**
- **[Flutter](https://flutter.dev/)**

## Сообщество

- **Официальный сайт**: [wmimo.buzz](https://wmimo.buzz)
- **Telegram-канал**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **Почта автора**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **Трекер задач**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)
