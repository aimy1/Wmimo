# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>Cliente GUI de proxy multiplataforma de nueva generación para Clash / Mihomo</strong></p>
  <p align="center">Construido con Flutter y el núcleo de alto rendimiento Mihomo. Diseñado para ofrecer alta velocidad, elegancia moderna y compatibilidad total de protocolos.</p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&label=Release&logo=github&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=githubactions&label=Build&color=2ea44f" alt="Build" /></a>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/downloads/aimy1/Wmimo/total?color=7952d2&style=flat-square&logo=gitlfs&label=Downloads" alt="Downloads" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
    <a href="https://t.me/wmimoapp"><img src="https://img.shields.io/badge/Telegram-Channel-2CA5E0?style=flat-square&logo=telegram&logoColor=white" alt="Telegram" /></a>
  </p>

  <p align="center">
    <a href="https://github.com/aimy1/Wmimo/releases"><b>Descargar</b></a> •
    <a href="https://wmimo.buzz"><b>Sitio web</b></a> •
    <a href="#características"><b>Características</b></a> •
    <a href="docs/BENCHMARKS.md"><b>Benchmarks</b></a> •
    <a href="#inicio-rápido"><b>Inicio rápido</b></a> •
    <a href="#compilación-desde-el-código-fuente"><b>Compilación</b></a> •
    <a href="https://t.me/wmimoapp"><b>Comunidad</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo Tema Claro" width="370" />
    &nbsp;&nbsp;
    <img src="docs/preview_dark.png" alt="Wmimo Tema Oscuro" width="370" />
  </p>
  <sub><em>Diseño refinado de micro-tarjetas de 18px, curvas de tráfico Bézier en tiempo real y diagnósticos completos (Temas Claro y Oscuro)</em></sub>
</div>

---

## Características

- **Interfaz de micro-tarjetas y doble tema nativo**:
  - Sistema de tarjetas con esquinas redondeadas de 18px y acento azul cian.
  - Transición fluida entre el modo claro y el modo oscuro profundo.
  - Diseño adaptable para escritorios de pantalla ancha y dispositivos móviles.
- **Núcleo Mihomo (Meta) de ultra rendimiento**:
  - Compatible con Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard, SSH y Direct.
  - Procesamiento asíncrono en Isolate en segundo plano — carga fluida y no bloqueante (5.000 nodos en ~163 ms, ver [Benchmarks](docs/BENCHMARKS.md)).
- **Enrutamiento inteligente y dos motores de proxy**:
  - Conmutación rápida: **Por reglas (Rule)** / **Global** / **Directo (Direct)**.
  - **Modo Adaptador Virtual TUN** (captura total del sistema) y **Modo Proxy del Sistema** sin privilegios elevados.
  - Proxy por aplicación en Android y herramienta UWP Loopback en Windows.
- **Telemetría en tiempo real y suite de diagnóstico**:
  - Gráfico de ondas Bézier con intervalos ajustables (1m / 5m / 15m / 30m / 60m).
  - Tarjeta de información de IP pública, ubicación y proveedor con copia rápida y modo privacidad.
  - Barra de progreso de consumo de datos y cuenta regresiva de expiración.
  - Herramientas completas: inspección de reglas, consola de logs en vivo, test Ping concurrente y visor de configuración.
- **Integración profunda con el sistema operativo**:
  - **Windows**: Menú de bandeja nativo adaptable al tema, medidor de velocidad dinámico, estilo moderno `comctl32 v6`.
  - **Android**: Notificación de servicio con desconexión rápida, mosaico de ajustes rápidos y sincronización de idiomas.
  - **macOS**: Icono de barra de menús en modo Template y control de proxy del sistema.
- **Actualizaciones automáticas silenciosas multicanal**:
  - Cambio flexible entre el canal estable (`stable`) y el canal de vista previa (`beta`).
  - Descarga en segundo plano con comprobación de integridad hash SHA-256.
- **100% traducido a 9 idiomas**:
  - Cobertura completa de 798 claves en Español, Inglés, Chino (simplificado/tradicional), Japonés, Coreano, Ruso, Árabe y Persa (0 claves faltantes, ver [Benchmarks](docs/BENCHMARKS.md)).

---

## Inicio rápido

1. **Descargar**: Vaya a la sección de [Releases](https://github.com/aimy1/Wmimo/releases) y descargue el instalador de su sistema.
2. **Importar**: En «Suscripciones», pegue su enlace de Clash/Mihomo o importe un archivo YAML local.
3. **Conectar**: Active el interruptor principal en la pantalla de inicio.
   - *Nota para Windows*: Para usar el **Modo TUN**, ejecute la aplicación como administrador; para navegación diaria, use el **Modo Proxy del Sistema**.

---

## Compilación desde el código fuente

### Requisitos previos
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.35.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.12.2`)
- Entorno de compilación del sistema anfitrión (Windows: Visual Studio 2022 C++, Linux: GTK3/Clang/CMake, Android: Android SDK)

### Comandos rápidos

```bash
# 1. Clonar el repositorio
git clone https://github.com/aimy1/Wmimo.git
cd Wmimo

# 2. Instalar dependencias y generar i18n
flutter pub get
dart run slang

# 3. Descargar núcleos Mihomo para todas las plataformas
dart run tool/download_all_cores.dart

# 4. Ejecutar en modo desarrollo
flutter run

# 5. Compilar binarios de producción
flutter build windows --release   # Windows
flutter build apk --release       # Android
flutter build linux --release     # Linux
flutter build macos --release     # macOS
```

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## Rendimiento y verificación de calidad

La eficiencia arquitectónica y la fiabilidad de Wmimo están respaldadas por pruebas automatizadas reproducibles:

- **Rendimiento de procesamiento de suscripciones**: ~30.670 nodos/s (5.000 nodos procesados, normalizados y clasificados en ~163 ms en Isolate de fondo).
- **Detección heurística de formato**: `isClashYaml` verifica 1.000 nodos en aproximadamente 1,4 ms.
- **Cobertura de internacionalización**: 9 idiomas con paridad de 798/798 claves (100% de coincidencia, 0 claves faltantes).
- **Verificación automatizada**: Ejecute `flutter test test/benchmark_profile_scale_test.dart` y `flutter test test/i18n_integrity_test.dart`.

La metodología completa, diagramas y especificaciones de hardware están en [docs/BENCHMARKS.md](docs/BENCHMARKS.md).

---

## Agradecimientos

- **[GooRingX (vowe)](https://github.com/GooRingX)**: Agradecimiento sincero por sus inestimables contribuciones de código abierto, ideas de diseño e inspiración.
- **[Mihomo (MetaCubeX)](https://github.com/MetaCubeX/mihomo)**: Gracias al equipo por ofrecer un motor de proxy universal potente y de alto rendimiento.
- **[Flutter](https://flutter.dev/)**: Por ofrecer un marco de trabajo de interfaz multiplataforma excepcional.

---

## Comunidad y contacto

- **Sitio web oficial**: [wmimo.buzz](https://wmimo.buzz)
- **Canal de Telegram**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **Correo del desarrollador**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **Reportar errores y sugerencias**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## Licencia

Este proyecto está bajo la licencia **GNU General Public License v3.0 (GPL-3.0-or-later)**. Consulte el archivo [LICENSE](LICENSE) para más información.

- **Crates del Rust Workspace**: Licencia dual [MIT](rust/LICENSE-MIT) o [Apache-2.0](rust/LICENSE-APACHE) de forma independiente; bajo GPL-3.0 cuando se distribuyen con Wmimo.
- **Licencias de terceros y componentes**: Consulte [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) y [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md).
- **Seguridad y certificados de firma**: Consulte [SECURITY.md](SECURITY.md) para ver la huella digital del certificado de firma de APK de Android (SHA-256) y las instrucciones de verificación.
