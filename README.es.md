# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="128" height="128" alt="Wmimo Logo" style="border-radius: 28px; box-shadow: 0 10px 30px rgba(0, 188, 223, 0.25);" />
  <h1 align="center" style="font-weight: 800; border-bottom: none; margin-top: 12px; margin-bottom: 6px;">Wmimo</h1>
  <p align="center" style="font-size: 1.15rem; color: #57606a;"><strong>Cliente GUI de proxy multiplataforma de nueva generación para Clash / Mihomo</strong></p>
  <p align="center">Construido con Flutter y el núcleo de alto rendimiento Mihomo. Diseñado para ofrecer máxima velocidad, elegancia moderna y compatibilidad total de protocolos.</p>

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
    <a href="#características"><b>Características</b></a> •
    <a href="#inicio-rápido"><b>Inicio rápido</b></a> •
    <a href="https://t.me/wmimoapp"><b>Comunidad</b></a>
  </p>

  <br/>
  <p align="center">
    <img src="docs/preview_light.png" alt="Wmimo Tema Claro" width="45%" />&nbsp;&nbsp;&nbsp;&nbsp;<img src="docs/preview_dark.png" alt="Wmimo Tema Oscuro" width="45%" />
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
  - Compatible con Shadowsocks, VMess, VLESS (Reality), Trojan, Hysteria 1/2, TUIC v5, WireGuard y Direct.
  - Procesamiento asíncrono en Isolate en segundo plano — **cero congelamiento de interfaz (Zero UI Freeze)**.
- **Enrutamiento inteligente y dos motores de proxy**:
  - Conmutación rápida: **Por reglas (Rule)** / **Global** / **Directo (Direct)**.
  - **Modo Adaptador Virtual TUN** y **Modo Proxy del Sistema** sin privilegios elevados.
  - Proxy por aplicación en Android y herramienta UWP Loopback en Windows.
- **Telemetría en tiempo real y suite de diagnóstico**:
  - Gráfico de ondas Bézier con intervalos ajustables (1m / 5m / 15m / 30m / 60m).
  - Tarjeta de información de IP pública, ubicación y proveedor con copia rápida.
  - Barra de progreso de consumo de datos y cuenta regresiva de expiración.
- **Integración profunda con el sistema operativo**:
  - **Windows**: Menú de bandeja nativo adaptable al tema, medidor de velocidad dinámico, estilo moderno `comctl32 v6`.
  - **Android**: Notificación de servicio con desconexión rápida, mosaico de ajustes rápidos y sincronización de idiomas.
  - **macOS**: Icono de barra de menús en modo Template.
- **100% traducido a 9 idiomas**:
  - Cobertura completa en Español, Inglés, Chino (simplificado/tradicional), Japonés, Coreano, Ruso, Árabe y Persa.

---

## Inicio rápido

1. **Descargar**: Vaya a la sección de [Releases](https://github.com/aimy1/Wmimo/releases) y descargue el instalador de su sistema.
2. **Importar**: En «Suscripciones», pegue su enlace de Clash/Mihomo.
3. **Conectar**: Active el interruptor principal en la pantalla de inicio.
   - *Nota para Windows*: Para usar el **Modo TUN**, ejecute la aplicación como administrador; para navegación diaria, use el **Modo Proxy del Sistema**.

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aimy1/Wmimo&type=Date)](https://star-history.com/#aimy1/Wmimo&Date)

---

## Comunidad y contacto

- **Canal de Telegram**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **Correo del desarrollador**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **Reportar errores**: [GitHub Issues](https://github.com/aimy1/Wmimo/issues)

---

## Licencia

Este proyecto está bajo la licencia **GPL-3.0**. Consulte el archivo [LICENSE](LICENSE) para más información.
