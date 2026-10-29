# Third-Party Software & Licenses

This document provides a comprehensive inventory of third-party software, libraries, drivers, and assets utilized by or distributed with **Wmimo**, along with their respective copyright holders, license terms, and compatibility with Wmimo's primary license (**GNU General Public License v3.0 or later**).

---

## 1. Licensing Architecture & Compatibility Overview

Wmimo is licensed under the **GNU General Public License v3.0 (GPL-3.0-or-later)**.

```
+-------------------------------------------------------------------------------+
|                             Wmimo Application                                 |
|                       Primary License: GPL-3.0-or-later                       |
+-------------------------------------------------------------------------------+
       |                                       |                               |
       v                                       v                               v
+-----------------------------+ +-----------------------------+ +-----------------------------+
|    Flutter / Dart Frontend   | |     Rust Workspace Crates   | |   Bundled Cores & Drivers   |
|   (UI, State, L10n, Event)   | |  (Standalone: MIT/Apache-2.0| |  - Mihomo Core: GPL-3.0+   |
|   Permissive: BSD-3 / MIT   | |   When bundled: GPL-3.0+)   | |  - Wintun Driver: MIT/GPL-2 |
+-----------------------------+ +-----------------------------+ +-----------------------------+
```

### GNU GPL-3.0 Compatibility Rationale

Under Section 5 of the GNU General Public License v3.0, conveying modified or combined works requires that the work as a whole is licensed under GPL-3.0.

- **Permissive Licenses (MIT, BSD-2-Clause, BSD-3-Clause, Apache-2.0)**:
  Permissive open-source licenses allow sublicensing or integration into larger works without imposing copyleft requirements. When incorporated into or linked with a GPL-3.0 application, the overall compiled binary is lawfully distributed under GPL-3.0, and the terms of both the permissive licenses and GPL-3.0 are fully respected.
- **Apache-2.0 Compatibility**:
  The Free Software Foundation (FSF) explicitly certifies Apache License 2.0 as **compatible with GNU GPL version 3** (unlike GPLv2, which was incompatible due to patent termination clauses).
- **Dual-Licensed Rust Crates (`MIT OR Apache-2.0`)**:
  The auxiliary Rust crates in `rust/crates/` (`wmimo_common`, `wmimo_bridge`, etc.) are authored by the Wmimo development team and released under dual MIT / Apache-2.0 terms to encourage standalone reusability. When compiled and distributed as part of Wmimo, copyleft conditions apply to the unified distribution as a combined work under GPL-3.0.

---

## 2. Bundled Core Engines, Drivers & Data Assets

| Component | Upstream Project / Author | License (SPDX) | Role in Wmimo |
|:---|:---|:---|:---|
| **Mihomo (Clash.Meta)** | [MetaCubeX/mihomo](https://github.com/MetaCubeX/mihomo) | `GPL-3.0-or-later` | Proxy and routing engine core |
| **Wintun TUN Driver** | [WireGuard LLC](https://www.wintun.net/) (Jason A. Donenfeld) | `MIT` / `GPL-2.0` | High-performance Windows TUN adapter driver |
| **GeoIP / GeoSite Data** | [MetaCubeX](https://github.com/MetaCubeX/meta-rules-dat) / [Loyalsoldier](https://github.com/Loyalsoldier/v2ray-rules-dat) | `CC-BY-SA-4.0` / `GPL-3.0` | Geolocation and domain routing databases |

---

## 3. Rust Workspace & Crates

Wmimo includes internal Rust components located in the `rust/` workspace:

- `wmimo_common`
- `wmimo_bridge`
- `wmimo_client`
- `wmimo_config_engine`
- `wmimo_core_mgr`
- `wmimo_firewall`
- `wmimo_sys_proxy`

**License**: Dual-licensed under `MIT OR Apache-2.0` when used as standalone libraries; subject to `GPL-3.0-or-later` when compiled and shipped within the Wmimo client application.

### Key Rust Dependencies

| Crate | License (SPDX) | Copyright / Upstream |
|:---|:---|:---|
| `tokio` | `MIT` | Tokio Contributors |
| `serde` / `serde_json` | `MIT OR Apache-2.0` | David Tolnay & Serde Contributors |
| `anyhow` / `thiserror` | `MIT OR Apache-2.0` | David Tolnay |
| `tracing` / `tracing-subscriber` | `MIT` | Tokio Contributors |
| `windows-sys` | `MIT OR Apache-2.0` | Microsoft Corporation |
| `chrono` | `MIT OR Apache-2.0` | Chrono Contributors |
| `uuid` | `MIT OR Apache-2.0` | The Uuid Project Developers |

---

## 4. Flutter & Dart Dependencies

The following open-source Dart/Flutter packages are referenced in `pubspec.yaml` and compiled into the application:

### Permissive (BSD-3-Clause)
- **`flutter` / `flutter_localizations`** - Google LLC (BSD-3-Clause)
- **`intl`** - Dart Team / Google LLC (BSD-3-Clause)
- **`path_provider`** - Flutter Team / Google LLC (BSD-3-Clause)
- **`device_info_plus`** - Flutter Community (BSD-3-Clause)
- **`package_info_plus`** - Flutter Community (BSD-3-Clause)
- **`ffi`** - Dart Team / Google LLC (BSD-3-Clause)
- **`url_launcher`** - Flutter Team / Google LLC (BSD-3-Clause)
- **`shared_preferences`** - Flutter Team / Google LLC (BSD-3-Clause)
- **`flutter_secure_storage`** - German Saprykin & Contributors (BSD-3-Clause)
- **`json_annotation`** - Google LLC (BSD-3-Clause)
- **`watcher`** - Google LLC (BSD-3-Clause)

### Permissive (MIT)
- **`provider`** - Remi Rousselet (MIT)
- **`flutter_riverpod`** - Remi Rousselet (MIT)
- **`slang` / `slang_flutter`** - Tien Do Nam (MIT)
- **`cupertino_icons`** - Flutter Team / Google LLC (MIT)
- **`flutter_emoji`** - Kevin Segaud (MIT)
- **`protocol_handler`** - LeanFlutter (MIT)
- **`launch_at_startup`** - LeanFlutter (MIT)
- **`screen_capturer`** - LeanFlutter (MIT)
- **`contextmenu`** - LeanFlutter (MIT)
- **`window_manager`** - LeanFlutter (MIT)
- **`tray_manager`** - LeanFlutter (MIT)
- **`screen_retriever`** - LeanFlutter (MIT)
- **`fast_cached_network_image`** - ApparenceKit (MIT)
- **`uuid`** - Yulian Kuncheff & Contributors (MIT)
- **`punycode_converter`** - Dart Community (MIT)

### Permissive (Apache-2.0)
- **`flutter_inappwebview`** - Lorenzo Pichilli & KaringX contributors (Apache-2.0)
- **`zxing2`** - ZXing Authors & Dart port authors (Apache-2.0)
- **`re_editor` / `re_highlight`** - Re-Editor Authors (Apache-2.0 / MIT)

### Permissive (BSD-2-Clause)
- **`qr_code_scanner_plus`** - Julius Canute & Contributors (BSD-2-Clause)

---

## 5. Full Texts of Permissive Licenses

### The MIT License
```text
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### The 3-Clause BSD License
```text
Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
   may be used to endorse or promote products derived from this software without
   specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

### The Apache License, Version 2.0
The complete terms of Apache-2.0 are available at:
<https://www.apache.org/licenses/LICENSE-2.0> and bundled in `rust/LICENSE-APACHE`.
