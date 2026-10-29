# Wmimo Rust Workspace

This directory contains the modular Rust core libraries for Wmimo proxy client operations.

## Crates

- `wmimo_common`: Shared data models, error definitions, and utility routines.
- `wmimo_client`: Async HTTP/WebSocket client for Mihomo controller API communication.
- `wmimo_config_engine`: Safe Clash/Mihomo YAML configuration generator and validator.
- `wmimo_core_mgr`: Core lifecycle manager (process supervision, healthchecks, auto-reconnect).
- `wmimo_firewall`: Native OS firewall rule helpers (Windows Filtering Platform / nftables).
- `wmimo_sys_proxy`: System-level proxy orchestrator across Windows, macOS, and Linux.
- `wmimo_bridge`: High-level orchestration facade linking engine components.

## Licensing

The crates in this workspace are individually dual-licensed under:

- **MIT License** ([LICENSE-MIT](LICENSE-MIT) or `http://opensource.org/licenses/MIT`)
- **Apache License, Version 2.0** ([LICENSE-APACHE](LICENSE-APACHE) or `http://www.apache.org/licenses/LICENSE-2.0`)

at your option.

### Combined Work Note

When these crates are built, linked, and distributed as part of the **Wmimo** desktop or mobile application, the resulting combined binary application is distributed under the **GNU General Public License v3.0 (GPL-3.0-or-later)** in accordance with GPL-3.0 Section 5. Both MIT and Apache-2.0 are one-way compatible with GPL-3.0.

See [THIRDPARTY_LICENSES.md](../THIRDPARTY_LICENSES.md) in the project root for full architecture and dependency licensing details.
