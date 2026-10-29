# Licenses and Component Architecture

This document clarifies the licensing hierarchy, copyright attributions, and SPDX identifiers across all sub-components and directories of **Wmimo**.

---

## 1. Hierarchy & SPDX Identification

Wmimo is organized into distinct functional tiers to maintain modularity, testability, and legal clarity.

| Component / Layer | Path | SPDX License Identifier | Applicable Terms |
|:---|:---|:---|:---|
| **Wmimo Main Application** | `/` (root), `/lib`, `/test` | `GPL-3.0-or-later` | Primary copyleft license governing the complete application and binary distributions. |
| **Rust Workspace Crates** | `/rust` | `MIT OR Apache-2.0` *(Standalone)*<br>`GPL-3.0-or-later` *(Combined)* | Permissive dual-licensing when used independently; governed by GPL-3.0 when distributed with Wmimo. |
| **Core Proxy Engine** | Bundled / Assets | `GPL-3.0-or-later` | Upstream [MetaCubeX/mihomo](https://github.com/MetaCubeX/mihomo). |
| **TUN Driver** | Windows Distribution | `MIT` / `GPL-2.0` | Upstream [Wintun](https://www.wintun.net/) by WireGuard LLC. |
| **Dart / Flutter Dependencies** | `pubspec.yaml` | `BSD-3-Clause`, `MIT`, `Apache-2.0` | Upstream permissive packages (see [THIRDPARTY_LICENSES.md](../THIRDPARTY_LICENSES.md)). |
| **GeoIP / GeoSite Data** | Bundled / Assets | `CC-BY-SA-4.0` / `GPL-3.0` | MetaCubeX & Loyalsoldier community datasets. |

---

## 2. Why Dual-Licensing for Rust Workspace Crates?

The crates under `rust/crates/` (`wmimo_common`, `wmimo_bridge`, `wmimo_client`, `wmimo_config_engine`, `wmimo_core_mgr`, `wmimo_firewall`, `wmimo_sys_proxy`) contain general-purpose system utilities, configuration parsers, and IPC bridges for interacting with Clash/Mihomo engines and platform network APIs.

1. **Standalone Utility**:
   By publishing the workspace under `MIT OR Apache-2.0`, independent developers and community members can extract and consume these crates in their own Rust applications under standard Rust ecosystem licensing terms.
2. **Combination in Wmimo**:
   When compiled, linked via FFI, and distributed as part of the unified **Wmimo** application, the whole combined work is conveyed under the **GNU General Public License v3.0 or later**. Permissive terms do not conflict with GPL-3.0 copyleft requirements, satisfying Section 5 and Section 13 of GPLv3.

---

## 3. Downstream Packaging & Distribution Guidelines

If you package Wmimo for package managers (e.g. Winget, Scoop, Homebrew, AUR, Flathub) or redistribute binaries:

1. **Main Package License**: Declare the package license as `GPL-3.0-or-later`.
2. **Source Code Availability**: In compliance with GPL-3.0 Section 6, any party distributing Wmimo binaries must provide access to the corresponding source code (such as a link to the GitHub repository release).
3. **Preserve Notices**: Maintain the root `LICENSE`, `rust/LICENSE-MIT`, `rust/LICENSE-APACHE`, and `THIRDPARTY_LICENSES.md` intact in all distributions.


---

## 4. Code Signing & Release Authenticity (Certificates)

To protect users against unauthorized tampering, the following digital certificate standards apply to official binary distributions:

| Platform | Certificate Type | Identifier / Fingerprint | Purpose |
|:---|:---|:---|:---|
| **Android** | Dedicated Release Keystore (RSA 2048-bit) | **SHA-256**: `4D:29:23:87:5A:FC:F3:44:38:B2:4A:9E:AF:81:C3:40:75:46:24:11:0D:A8:D1:E5:8E:41:2B:0D:CB:8C:75:5D` | Signs official APK binaries (V1+V2 scheme) to ensure seamless updates and anti-tamper authenticity. |
| **Windows** | Microsoft WHQL Driver Certificate | Signed by `WireGuard LLC` | Authentic signature on `wintun.dll` for unprivileged kernel TUN virtual adapter loading. |
| **All Platforms** | Release Checksums | SHA-256 hash manifest (`*.sha256`) | Cryptographic file integrity verification on [GitHub Releases](https://github.com/aimy1/Wmimo/releases). |

See [SECURITY.md](../SECURITY.md) for full fingerprint verification commands.
