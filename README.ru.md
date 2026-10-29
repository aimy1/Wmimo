# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>Современный кроссплатформенный клиент Clash / Mihomo нового поколения</strong></p>
  <p align="center">Создан на базе Flutter и ядра Mihomo. Обеспечивает высокую скорость, элегантный дизайн и поддержку всех современных протоколов.</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>Скачать</b></a> •
    <a href="https://wmimo.buzz"><b>Веб-сайт</b></a> •
    <a href="#возможности"><b>Возможности</b></a> •
    <a href="docs/BENCHMARKS.md"><b>Бенчмарки</b></a> •
    <a href="#быстрый-старт"><b>Быстрый старт</b></a> •
    <a href="#сборка-из-исходного-кода"><b>Сборка</b></a> •
    <a href="https://t.me/wmimoapp"><b>Сообщество</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo Светлая тема" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo Темная тема" width="370" />
  </p>
  <sub><em>Эстетика микро-карточек 18px, плавный график трафика Безье и диагностика сети (Светлая и Темная темы)</em></sub>
</div>

---

## Возможности

- **Эстетичный интерфейс и нативная смена тем**:
  - Закругления карточек 18px и фирменный акцентный циан.
  - Плавное и чистое переключение между светлой и глубокой темной темами.
  - Адаптивный интерфейс для больших мониторов и смартфонов.
- **Ядро Mihomo (Meta) с полной поддержкой протоколов**:
  - Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH, Direct.
  - Парсинг и сортировка узлов в фоновом Isolate — плавная неблокирующая загрузка (5 000 узлов за ~163 мс, см. [Бенчмарки](docs/BENCHMARKS.md)).
- **Интеллектуальная маршрутизация и два режима работы**:
  - Быстрое переключение: **По правилам (Rule)** / **Глобальный (Global)** / **Прямой (Direct)**.
  - **Режим TUN-адаптера** (прозрачный системный перехват) и **Системный прокси** (без прав администратора).
  - Раздельное туннелирование приложений на Android и исключение UWP на Windows.
- **Мониторинг трафика и диагностический центр**:
  - Графики трафика Безье в реальном времени (1м / 5м / 15м / 30м / 60м).
  - Карточка проверки внешнего IP, локации и провайдера в один клик с маскированием данных.
  - Счетчик расхода тарифного плана и срока действия подписки.
  - Набор инструментов диагностики: правила маршрутизации, консольные логи ядра, параллельный пинг и просмотр конфигурации.
- **Глубокая интеграция с операционными системами**:
  - **Windows**: Нативное меню трея подстраивается под тему приложения, динамическая индикация скорости в трее, стиль `comctl32 v6`.
  - **Android**: Уведомление службы с кнопкой отключения, плитка быстрых настроек, синхронизация языка.
  - **macOS**: Нативная иконка в строке меню Template и управление системным прокси.
- **Многоканальное автоматическое обновление**:
  - Свободное переключение между стабильным каналом (`stable`) и каналом предварительных версий (`beta`).
  - Фоновая тихая загрузка с проверкой целостности по хешу SHA-256.
- **100% локализация на 9 языков**:
  - Полное покрытие 798 ключей (0 пропусков): Русский, Английский, Китайский (упр/трад), Японский, Корейский, Испанский, Арабский, Персидский (см. [Бенчмарки](docs/BENCHMARKS.md)).

---

## Быстрый старт

1. **Скачать**: Перейдите в [Релизы](https://github.com/aimy1/Wmimo/releases) и скачайте нужный файл.
2. **Импорт**: В разделе «Подписки» вставьте ссылку на подписку Clash/Mihomo.
3. **Подключение**: Включите тумблер на главном экране.
   - *Совет для Windows*: Для **TUN-режима** запускайте Wmimo от имени администратора; для повседневного использования отлично подходит **Системный прокси**.

---

## Сборка из исходного кода

### Требования
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- Инструменты компиляции (Windows: Visual Studio 2022 C++, Linux: GTK3/Clang/CMake, Android: Android SDK)

### Команды для сборки

```bash
# 1. Клонирование репозитория
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. Установка зависимостей и генерация файлов локализации
flutter pub get
dart run slang

# 3. Загрузка ядер Mihomo для всех платформ
dart run tool/download_all_cores.dart

# 4. Запуск в режиме разработки
flutter run

# 5. Сборка релизных пакетов
flutter build windows --release   # Windows
flutter build apk --release       # Android
flutter build linux --release     # Linux
flutter build macos --release     # macOS
```

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## Производительность и контроль качества

Архитектурная эффективность и стабильность Wmimo подтверждены автоматическими тестами:

- **Скорость парсинга подписок**: ~30 670 узлов/с (5 000 узлов парсятся и классифицируются за ~163 мс в фоновом Isolate).
- **Быстрое определение формата**: `isClashYaml` проверяет 1 000 узлов всего за ~1.4 мс.
- **Полнота локализации**: 9 языков по 798 ключей с точностью 100% (0 пропусков).
- **Команды проверки**: `flutter test test/benchmark_profile_scale_test.dart` и `flutter test test/i18n_integrity_test.dart`.

Подробная методология и аппаратные характеристики приведены в [docs/BENCHMARKS.md](docs/BENCHMARKS.md).

---

## Благодарности

- **[GooRingX (vowe)](https://github.com/GooRingX)**: Огромная благодарность за вклад в открытый исходный код, архитектуру и дизайн.
- **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**: Спасибо за высокопроизводительное универсальное ядро.
- **[Flutter](https://flutter.dev/)**: Спасибо команде за современный кроссплатформенный фреймворк.

---

## Сообщество

- **Официальный сайт**: [wmimo.buzz](https://wmimo.buzz)
- **Telegram-канал**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **Email**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **Сообщить об ошибке**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## Лицензия

Проект распространяется под лицензией **GNU General Public License v3.0 (GPL-3.0-or-later)**. Подробности в файле [LICENSE](LICENSE).

- **Модули Rust Workspace**: Распространяются под двойной лицензией [MIT](rust/LICENSE-MIT) или [Apache-2.0](rust/LICENSE-APACHE) при автономном использовании; в составе Wmimo действует GPL-3.0.
- **Сторонние компоненты**: См. [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) и [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md).
