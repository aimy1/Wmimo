<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---

<div align="center">
  <img src="assets/images/app_icon_256.png" width="96" height="96" alt="Wmimo Logo" />
  <h1>Wmimo</h1>
  <p><strong>Cliente Proxy Multiplataforma Clash / Mihomo de Nueva Generación</strong></p>
  <p>Desarrollado con Flutter y el núcleo Mihomo (v1.19.34). Ejecución estrictamente local sin telemetría, proxy en cadena multisalto, diagnóstico concurrente y test de velocidad con gráfico en vivo.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/stargazers"><img src="https://img.shields.io/github/stars/aimy1/Wmimo?color=F59E0B&label=Stars&logo=github&style=flat-square" alt="Stars" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions/workflows/release.yml"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="CI Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&label=Downloads" alt="Downloads" /></a>
    <a href="https://github.com/MetaCubeX/mihomo"><img src="https://img.shields.io/badge/Mihomo-v1.19.34-FF6B6B?style=flat-square" alt="Mihomo" /></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPL--3.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-%40wmimoapp-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><b>Descargar</b></a> ·
    <a href="#sec-platforms"><b>Plataformas</b></a> ·
    <a href="#sec-features"><b>Funciones</b></a> ·
    <a href="#sec-quickstart"><b>Inicio Rápido</b></a> ·
    <a href="#sec-build"><b>Compilar</b></a> ·
    <a href="#sec-security"><b>Seguridad</b></a> ·
    <a href="#sec-community"><b>Comunidad</b></a>
  </p>
</div>

| Modo Claro | Modo Oscuro |
| :---: | :---: |
| <img src="docs/preview_light.png" alt="Wmimo Light Theme" width="360" /> | <img src="docs/preview_dark.png" alt="Wmimo Dark Theme" width="360" /> |

<p align="center"><sub><em>Tarjetas minimalistas de 18px · Gráfico Bezier en vivo · Motor dual TUN y Proxy del Sistema</em></sub></p>

---

<a id="sec-platforms"></a>

## Plataformas Compatibles y Paquetes

| Plataforma | Arquitectura | Paquetes Oficiales | Funciones Destacadas |
| :--- | :--- | :--- | :--- |
| **Windows** | `x64`, `arm64` | Instalador (`.exe`), Portable (`.zip`) | Proxy del sistema sin elevación, Wintun TUN firmado WHQL (Admin), exención UWP, bandeja adaptable, atajos globales |
| **macOS** | `Universal` (`arm64` + `x64`) | `.dmg`, Portable (`.zip`) | Autorización segura de servicio/TUN, icono en barra de menú, iCloud Drive, atajos globales |
| **Linux** | `x64`, `arm64` | `.deb`, `.rpm`, `.AppImage`, Arch `PKGBUILD` (`wmimo-bin`), `.tar.gz` | `setcap` / TUN, Proxy del sistema, interfaz GTK3, atajos globales |
| **Android** | `arm64-v8a`, `armeabi-v7a`, `x86_64` | APKs por ABI y Universal `.apk` | Proxy por App en caliente sin reiniciar núcleo, optimización de batería, ajuste rápido QS |
| **iOS** | `arm64` | `.ipa` sin firmar (TrollStore / Sideload) | Túnel VPN Network Extension y sincronización iCloud ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)) |

> Descargue los binarios desde [GitHub Releases](https://github.com/aimy1/Wmimo/releases) y verifique las firmas APK (SHA-256) y Wintun en [SECURITY.md](SECURITY.md).

---

<a id="sec-features"></a>

## Matriz de Capacidades y Características

| Módulo | Capacidades Clave |
| :--- | :--- |
| **Núcleo Mihomo (`v1.19.34`)** | SS, VMess, VLESS Reality, Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH • Análisis en Isolate (`5,000` nodos en `~163 ms`) |
| **Proxy en Cadena `[Beta]`** | Basado en **`dialer-proxy`** multisalto, reordenamiento de saltos, validación antiduplicados, persistencia en `chain_proxies.json` |
| **Proxy por App (Android)** | Protección ante lista blanca vacía, intercambio en vivo sin reiniciar Mihomo, preajustes sin permisos adicionales |
| **Diagnóstico (`NetCheck`)** | Pipeline concurrente de 5 pasos (filtra adaptadores TUN, DNS/Fake-IP, puertos, proxy/TUN, nodo activo) + consulta de dominio y autorreparación |
| **Test de Velocidad (`SpeedTest`)** | Descarga/subida multihilo HTTP, Ping/Jitter estable, gráfico de ondas en vivo, calificación por uso y latencia de servidores CDN |
| **Copias y Sincronización** | WebDAV, iCloud Drive, exportación/restauración `.zip` con `chain_proxies.json`, verificación previa y protección Zip-Slip |
| **UI Personalizable** | Temas claro/oscuro, gestor de tarjetas en inicio, rotación automática habilitada por defecto, máscara de IP |
| **Privacidad e Idiomas** | Cero SDKs de telemetría/publicidad; **9 idiomas × 898 claves (100%)** y 9 políticas de privacidad locales |

---

<a id="sec-quickstart"></a>

## Inicio Rápido

1. **Descargar**: Obtenga el instalador en [GitHub Releases](https://github.com/aimy1/Wmimo/releases).
2. **Importar Suscripción**: Pegue su enlace Clash/Mihomo o archivo YAML en Suscripciones.
3. **Conectar**: Active el interruptor principal en la vista general.

<details>
<summary><b>Notas por Plataforma (Windows / Android / macOS y Linux / iOS)</b></summary>

- **Windows**: El proxy del sistema no requiere privilegios; ejecute como administrador para modo TUN. Use la carpeta `portable` para modo portátil.
- **Android**: Excluya Wmimo de la optimización de batería; los cambios de Proxy por App se aplican en vivo.
- **iOS**: Distribuido como `.ipa` sin firmar ([docs/APPLE_DEVELOPMENT.md](docs/APPLE_DEVELOPMENT.md)).

</details>

---

<a id="sec-build"></a>

## Compilar desde el Código Fuente

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`) y [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- Herramientas nativas (VS 2022 C++ / Xcode / GTK3 & CMake / Android SDK)

```bash
git clone https://github.com/aimy1/Wmimo.git && cd Wmimo
flutter pub get && dart run slang
dart run tool/download_all_cores.dart
flutter run
# Release: flutter build {windows|macos|linux|apk} --release
```

---

## Rendimiento y Verificación

- **Análisis de nodos**: `~30,670 nodos/s` (`5,000` nodos en `~163 ms` vía Isolate).
- **Cobertura i18n**: **9/9 idiomas × 898 claves = 100.0%** ([docs/BENCHMARKS.md](docs/BENCHMARKS.md)).

Metodología completa en [docs/BENCHMARKS.md](docs/BENCHMARKS.md).

---

## Historial de Estrellas

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

<a id="sec-security"></a>

## Seguridad, Privacidad y Licencia

- **Cero Recopilación de Datos**: [assets/txts/privacy_policy_es.txt](assets/txts/privacy_policy_es.txt)
- **Autenticidad de Binarios**: [SECURITY.md](SECURITY.md)
- Bajo licencia **GNU General Public License v3.0 (GPL-3.0-or-later)** ([LICENSE](LICENSE)).
- Rust Crates: [MIT](rust/LICENSE-MIT) / [Apache-2.0](rust/LICENSE-APACHE) independientes; GPL-3.0 junto con Wmimo.
- Componentes de terceros: [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md), [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md)

---

<a id="sec-community"></a>

## Comunidad y Soporte

- **Sitio Web**: [wmimo.buzz](https://wmimo.buzz) · **Canal de Telegram**: [t.me/wmimoapp](https://t.me/wmimoapp) · **Correo**: [aisaniya@proton.me](mailto:aisaniya@proton.me) · **Reportar Problemas**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

**Agradecimientos**: **[GooRingX (vowe)](https://github.com/GooRingX)** · **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)** · **[Flutter](https://flutter.dev/)**
