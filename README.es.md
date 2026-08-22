# Wmimo

<div align="center">

[**简体中文**](README.zh-CN.md) | [**English**](README.md) | [**繁體中文**](README.zh-TW.md) | [**日本語**](README.ja.md) | [**한국어**](README.ko.md) | [**Русский**](README.ru.md) | [**Español**](README.es.md) | [**العربية**](README.ar.md) | [**فارسی**](README.fa.md)

</div>

---


<div align="center">
  <img src="assets/images/app_icon_256.png" width="120" height="120" alt="Wmimo Logo" />
  <h3>Cliente GUI de Proxy Clash / Mihomo Multiplataforma y Moderno</h3>
  <p>Construido con Flutter y el núcleo Mihomo, ofreciendo una experiencia de proxy rápida, elegante y potente.</p>

  <p>
    <a href="https://github.com/aimy1/Wmimo/releases"><img src="https://img.shields.io/github/v/release/aimy1/Wmimo?color=00BCDF&style=flat-square" alt="Release" /></a>
    <a href="https://github.com/aimy1/Wmimo/actions"><img src="https://img.shields.io/github/actions/workflow/status/aimy1/Wmimo/release.yml?style=flat-square&logo=github&label=Build" alt="CI/CD" /></a>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter" alt="Flutter" /></a>
    <a href="https://github.com/aimy1/Wmimo/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-GPL%203.0-green?style=flat-square" alt="License" /></a>
  </p>
</div>

---

## 🔥 Novedades en la rama Beta (What's New in Beta)

> [!TIP]
> Esta es la **rama de vista previa `beta`**, que incluye compatibilidad con nuevos protocolos, optimización profunda para Linux y mayor estabilidad de nodos:

- 🔄 **Convertidor universal de suscripciones (`SubscriptionConverter`)**:
  - Detección y decodificación automática de **suscripciones Base64** y enlaces directos (`vmess://`, `vless://` con Reality/Vision, `ss://`, `trojan://`, `hysteria2://` / `hy2://`, `tuic://`, etc.);
  - Generación inteligente de grupos regionales (🇭🇰 Hong Kong, 🇯🇵 Japón, 🇸🇬 Singapur, 🇹🇼 Taiwán, 🇺🇸 EE. UU., 🇰🇷 Corea, etc.), `Selección de nodo`, `Selección automática`, `Fallback` y reglas de enrutamiento;
  - Permite pegar enlaces directos o texto Base64 en la pantalla de "Añadir perfil".
- 🐧 **Estabilidad de conexión en Linux y corrección de permisos en `work_dir`**:
  - Directorio de trabajo `work_dir` reubicado en `~/.local/share/wmimo` con permisos de escritura, eliminando errores de `cache.db` en AppImage;
  - Síntesis completa de `proxy-groups:` antes de iniciar el núcleo para evitar la pérdida de nodos tras conectar.
- 🎯 **Filtrado preciso de adaptadores internos del núcleo**:
  - Filtrado de adaptadores internos de Mihomo Meta (`COMPATIBLE`, `PASS`, `PASS-RULE`, `REJECT-DROP`, `DIRECT`, `REJECT`, `DNS`);
  - Las pruebas de latencia (⚡) y las tarjetas visuales se aplican exclusivamente a nodos proxy reales.
- 📦 **Compatibilidad con las principales distribuciones de Linux**:
  - Paquetes AppImage (portable sin instalación), Debian/Ubuntu (`.deb`), Fedora/RHEL (`.rpm`), Arch Linux (`.pkg.tar.zst` & `PKGBUILD`) y archivo portable (`.tar.gz`).

---

## 📌 Estado de Plataformas

| Plataforma | Estado | Paquetes | Descripción |
| :--- | :---: | :--- | :--- |
| 🪟 **Windows** | ✅ **Listo** | Instalador (`.exe`) y Portable (`.zip`) | Barra lateral de escritorio, menú de bandeja del sistema, modo TUN, autoactualización. |
| 🐧 **Linux** | ✅ **Listo** | Paquete Debian (`.deb`) y Portable (`.tar.gz`) | Interfaz nativa GTK3, bandeja del sistema, daemon de núcleo Mihomo integrado. |
| 📱 **Android** | ✅ **Listo** | APK universal y por arquitecturas | Integración con VpnService, interfaz móvil optimizada. |
| 🍎 **macOS** | 🚧 **En desarrollo** | DMG | Integración con NetworkExtension en progreso. |
| 🍏 **iOS** | 🚧 **En desarrollo** | IPA | Integración con NetworkExtension en progreso. |

---

## ✨ Características Principales

- 🎨 **UI Moderna y Elegante**: Modos Claro y Oscuro, diseño adaptable (móvil y escritorio).
- ⚡ **Núcleo Mihomo**: Soporte completo para Shadowsocks, VMess, VLESS, Trojan, Hysteria 1/2, TUIC, WireGuard.
- 🔀 **Bandeja del Sistema**: Velocidad en tiempo real, cambio de modos de proxy, prueba de latencia.
- 📊 **Monitoreo de Tráfico**: Gráficos Bézier de tráfico, tarjeta de información IP/ISP, grupos de proxies colapsables.
- 🚀 **Autoactualización Inteligente**: Canales `stable` y `beta` con verificación SHA-256.
- 🌍 **Soporte de 9 Idiomas**: Español, Inglés, Chino, Japonés, Coreano, Ruso, Árabe, Persa.

---

## 💖 Donaciones y Soporte

- **Moneda**: `USDT`
- **Red**: `APTOS`
- **Dirección**: `0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345`

---

## 📄 Licencia

Distribuido bajo la licencia **GPL-3.0**.
