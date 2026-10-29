# Security Policy & Release Authenticity

Wmimo takes the security, authenticity, and legal compliance of our releases and source code seriously. This document defines our security policies, vulnerability reporting procedure, and the cryptographic certificate fingerprints used to verify official release artifacts.

---

## 1. Supported Versions

Security patches and bug fixes are actively maintained on the following channels:

| Version Channel | Supported | Notes |
|:---|:---:|:---|
| Current Stable Release (`v1.3.x`) | :white_check_mark: | Fully supported with security and stability updates |
| Beta Preview Channel (`v1.3.x-beta`) | :white_check_mark: | Early validation builds |
| Older Versions (`< v1.3.0`) | :x: | End of life; please upgrade to the latest stable release |

---

## 2. Release Authenticity & Certificate Fingerprints

To prevent man-in-the-middle tampering, rogue repackaging, or malware distribution, official Wmimo binaries are cryptographically signed or verifiable via deterministic hashes.

### Android Release Signing Certificate

Official Android APK binaries (`Wmimo-Android-arm64-v8a-*.apk`, `Wmimo-Android-universal-*.apk`, etc.) are signed with the dedicated Wmimo release key before distribution.

- **Certificate Subject (DName)**: `CN=Wmimo, OU=Wmimo, O=Wmimo, C=US`
- **Certificate Issuer**: `CN=Wmimo, OU=Wmimo, O=Wmimo, C=US`
- **Key Algorithm & Length**: `RSA 2048-bit`
- **Valid Period**: September 18, 2026 – September 5, 2076
- **SHA-256 Fingerprint**:
  ```
  4D:29:23:87:5A:FC:F3:44:38:B2:4A:9E:AF:81:C3:40:75:46:24:11:0D:A8:D1:E5:8E:41:2B:0D:CB:8C:75:5D
  ```
- **SHA-1 Fingerprint**:
  ```
  0D:FD:2F:2E:F9:AD:F8:5F:F9:5E:82:6E:EC:DA:EC:2A:95:F3:6C:B0
  ```

#### How to Verify Android APK Signature

You can independently verify any downloaded APK using the official Android SDK `apksigner` or Java `keytool`:

```bash
# Method 1: Using Android SDK apksigner
apksigner verify --print-certs Wmimo-Android-arm64-v8a-v1.3.3.1519.apk

# Method 2: Using standard JDK keytool
keytool -printcert -jarfile Wmimo-Android-arm64-v8a-v1.3.3.1519.apk
```

The output SHA-256 certificate fingerprint **must match** `4D:29:23:87:5A:FC:F3:...` above. If the fingerprints differ, do not install the APK.

---

### Windows Distribution & Driver Signature

- **Wintun Virtual Adapter Driver (`wintun.dll`)**:
  Bundled with the Windows release for TUN mode. Signed by **WireGuard LLC** with a Microsoft Hardware Quality Labs (WHQL) driver digital certificate, ensuring safe kernel-mode execution without untrusted driver warnings.
- **Installer & Portable Packages**:
  Every Windows release on [GitHub Releases](https://github.com/aimy1/Wmimo/releases) is published with corresponding SHA-256 hash checksums (`*.sha256`).

---

### macOS & iOS Distribution

- **macOS**: Built with deterministic GitHub Actions workflows; SHA-256 checksums are attached to each release tag.
- **iOS IPA**: Provided as an unsigned IPA package for TrollStore and self-signed sideloading (AltStore, SideStore). Verify file integrity via published SHA-256 hashes.

---

## 3. Open Source Licenses & Governance

Wmimo complies with all applicable open-source licenses:

1. **Main Client**: Licensed under **GNU General Public License v3.0 or later** ([LICENSE](LICENSE)).
2. **Rust Workspace Crates**: Dual-licensed under [MIT](rust/LICENSE-MIT) OR [Apache-2.0](rust/LICENSE-APACHE) when used standalone, and GPL-3.0 when distributed with Wmimo.
3. **Core Proxy Engine**: Mihomo (MetaCubeX) under GPL-3.0-or-later.
4. **Third-Party Components**: Complete attribution and license texts are detailed in [THIRDPARTY_LICENSES.md](THIRDPARTY_LICENSES.md) and [docs/LICENSES_AND_COMPONENTS.md](docs/LICENSES_AND_COMPONENTS.md).
5. **In-App Display**: In the application, navigate to **Settings ➔ About ➔ License (开源许可证)** to interactively browse all third-party license notices.

---

## 4. Reporting a Vulnerability

If you discover a security vulnerability or potential privacy leak in Wmimo, please report it responsibly:

- **Email**: [aisaniya@proton.me](mailto:aisaniya@proton.me)
- **Telegram Channel**: [t.me/wmimoapp](https://t.me/wmimoapp)
- **Encryption / Details**: Please provide a detailed description of the vulnerability, reproduction steps, and impact.
- **Response Timeline**: We commit to acknowledging receipt within 48 hours and providing a remediation timeline or patch within 7 business days.

Please do not open public GitHub issues for sensitive security vulnerabilities before a patch has been coordinated.
