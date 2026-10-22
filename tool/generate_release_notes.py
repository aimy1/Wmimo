#!/usr/bin/env python3
"""
Wmimo Advanced Release Notes Generator
Generates a comprehensive, premium GitHub Release Notes document
featuring direct package download links, sizes, SHA256 checksums, and platform guides.
"""

import sys
import os
import hashlib
import re
from datetime import datetime

def format_size(size_bytes):
    if size_bytes <= 0:
        return "N/A"
    for unit in ['B', 'KB', 'MB', 'GB']:
        if size_bytes < 1024.0 or unit == 'GB':
            return f"{size_bytes:.1f} {unit}" if unit != 'B' else f"{int(size_bytes)} B"
        size_bytes /= 1024.0
    return f"{size_bytes:.1f} MB"

def compute_sha256(filepath):
    sha = hashlib.sha256()
    with open(filepath, 'rb') as f:
        while chunk := f.read(65536):
            sha.update(chunk)
    return sha.hexdigest()

def main():
    if len(sys.argv) < 5:
        print("Usage: generate_release_notes.py <tag> <repo> <assets_dir> <output_file> [build_number]")
        sys.exit(1)

    tag = sys.argv[1].strip()
    if not tag.startswith('v'):
        tag = 'v' + tag
    repo = sys.argv[2].strip()
    assets_dir = sys.argv[3].strip()
    output_file = sys.argv[4].strip()
    build_number = sys.argv[5].strip() if len(sys.argv) > 5 else ""

    raw_ver = tag.lstrip('v')
    parts = raw_ver.split('+')[0].split('.')
    base_ver = ".".join(parts[:3]) if len(parts) >= 3 else raw_ver
    if not build_number:
        if '+' in tag:
            build_number = tag.split('+')[1]
        elif len(parts) > 3:
            build_number = parts[3]
        else:
            build_number = "1512"

    release_date = datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC")
    base_download_url = f"https://github.com/{repo}/releases/download/{tag}"

    files_info = {}
    checksums = []

    if os.path.exists(assets_dir):
        for fname in sorted(os.listdir(assets_dir)):
            fpath = os.path.join(assets_dir, fname)
            if not os.path.isfile(fpath):
                continue
            if fname.startswith('.') or fname == 'SHA256SUMS.txt':
                continue
            size_bytes = os.path.getsize(fpath)
            size_str = format_size(size_bytes)
            sha = compute_sha256(fpath)
            checksums.append(f"{sha}  {fname}")
            files_info[fname] = {
                "name": fname,
                "size": size_str,
                "sha256": sha,
                "url": f"{base_download_url}/{fname}"
            }

    def find_file(pattern):
        regex = re.compile(pattern, re.IGNORECASE)
        for fname, info in files_info.items():
            if regex.search(fname):
                return info
        return None

    def get_info(pattern, default_name):
        info = find_file(pattern)
        if info:
            return info
        return {
            "name": default_name,
            "size": "Auto",
            "sha256": "自动计算",
            "url": f"{base_download_url}/{default_name}"
        }

    # Windows
    win_x64_exe = get_info(r"Windows.*x64.*Setup.*\.exe$", f"Wmimo-Windows-x64-Setup-{tag}.exe")
    win_x64_zip = get_info(r"Windows.*x64.*\.zip$", f"Wmimo-Windows-x64-{tag}.zip")
    win_arm64_exe = get_info(r"Windows.*arm64.*Setup.*\.exe$", f"Wmimo-Windows-arm64-Setup-{tag}.exe")
    win_arm64_zip = get_info(r"Windows.*arm64.*\.zip$", f"Wmimo-Windows-arm64-{tag}.zip")

    # Android
    android_arm64 = get_info(r"Android.*arm64-v8a.*\.apk$", f"Wmimo-Android-arm64-v8a-{tag}.apk")
    android_univ = get_info(r"Android.*universal.*\.apk$", f"Wmimo-Android-universal-{tag}.apk")
    android_armv7 = get_info(r"Android.*armeabi-v7a.*\.apk$", f"Wmimo-Android-armeabi-v7a-{tag}.apk")
    android_x86_64 = get_info(r"Android.*x86_64.*\.apk$", f"Wmimo-Android-x86_64-{tag}.apk")

    # macOS
    macos_dmg = get_info(r"macOS.*\.dmg$", f"Wmimo-macOS-universal-{tag}.dmg")
    macos_zip = get_info(r"macOS.*\.zip$", f"Wmimo-macOS-universal-{tag}.zip")

    # Linux
    linux_appimage = get_info(r"Linux.*\.AppImage$", f"Wmimo-Linux-x64-{tag}.AppImage")
    linux_deb = get_info(r"Linux.*\.deb$", f"Wmimo-Linux-x64-{tag}.deb")
    linux_rpm = get_info(r"Linux.*\.rpm$", f"Wmimo-Linux-x64-{tag}.rpm")
    linux_pacman = get_info(r"Linux.*\.pkg\.tar\.zst$", f"Wmimo-Linux-x64-{tag}.pkg.tar.zst")
    linux_tar = get_info(r"Linux.*\.tar\.gz$", f"Wmimo-Linux-x64-{tag}.tar.gz")

    # iOS
    ios_ipa = get_info(r"iOS.*\.ipa$", f"Wmimo-iOS-universal-{tag}.ipa")

    checksum_block = "\n".join(checksums) if checksums else "SHA256SUMS.txt 将在构建完成后由工作流自动计算并上传。"

    markdown = f"""# 🚀 Wmimo {tag} 发布说明 / Release Notes

> 简洁、现代、高性能的跨平台 Clash / Mihomo 桌面与移动端图形客户端。
> A sleek, modern, high-performance cross-platform Clash / Mihomo GUI proxy client.

---

### 📌 版本概要 / Version Overview

| 项目 / Item | 信息 / Details |
| :--- | :--- |
| **版本发布标签 (Release Tag)** | `{tag}` |
| **基础版本 (Base Version)** | `v{base_ver}` |
| **内部构建号 (Build Number)** | `{build_number}` |
| **完整版本号 (Full Version)** | `{base_ver}.{build_number}` (`{base_ver}+{build_number}`) |
| **构建时间 (Build Time)** | `{release_date}` |
| **开源主页 (Repository)** | [github.com/{repo}](https://github.com/{repo}) |

---

### 📦 全平台软件包直接下载 / Downloads by Platform

> [!TIP]
> **💡 新手快速选包指南 / Quick Guide**：
> - **Windows**：推荐下载 `Wmimo-Windows-x64-Setup`（适用于绝大多数 64 位 Windows 10/11 电脑）。
> - **Android**：推荐下载 `Wmimo-Android-arm64-v8a`（99% 现代安卓手机与平板的首选，体积更小、运行更流畅）。
> - **macOS**：推荐下载 `Wmimo-macOS-universal.dmg`（同时原生支持 Apple Silicon M1/M2/M3/M4 及 Intel 芯片，拖拽安装即可）。
> - **Linux**：推荐下载 `Wmimo-Linux-x64.AppImage`（无需安装，全发行版双击即用）。
> - **iOS**：下载 `Wmimo-iOS-universal.ipa`（适用于 TrollStore 永久免签安装，或使用 AltStore / Sideloadly 侧载）。

---

#### 🪟 Windows 专区
| 软件包名称 | 适用平台 / 架构 | 类型 | 文件大小 | 直接下载链接 |
| :--- | :--- | :---: | :---: | :---: |
| `{win_x64_exe['name']}` | Windows 10 / 11 (64-bit) | 🌟 **推荐安装包** | `{win_x64_exe['size']}` | [📥 **点击下载**]({win_x64_exe['url']}) |
| `{win_x64_zip['name']}` | Windows 10 / 11 (64-bit) | 免安装便携版 | `{win_x64_zip['size']}` | [📥 **点击下载**]({win_x64_zip['url']}) |
| `{win_arm64_exe['name']}` | Windows 11 ARM64 (Surface / 骁龙X) | ARM64 安装包 | `{win_arm64_exe['size']}` | [📥 **点击下载**]({win_arm64_exe['url']}) |
| `{win_arm64_zip['name']}` | Windows 11 ARM64 (Surface / 骁龙X) | ARM64 便携版 | `{win_arm64_zip['size']}` | [📥 **点击下载**]({win_arm64_zip['url']}) |

---

#### 🤖 Android 专区
| 软件包名称 | 适用设备 / 架构 | 类型 | 文件大小 | 直接下载链接 |
| :--- | :--- | :---: | :---: | :---: |
| `{android_arm64['name']}` | 现代主流安卓手机 / 平板 (arm64-v8a) | 🌟 **首选推荐** | `{android_arm64['size']}` | [📥 **点击下载**]({android_arm64['url']}) |
| `{android_univ['name']}` | 全机型通用 (Universal All ABIs) | 完整通用包 | `{android_univ['size']}` | [📥 **点击下载**]({android_univ['url']}) |
| `{android_armv7['name']}` | 老旧 32 位设备 / 旧安卓电视盒子 | 32位兼容包 | `{android_armv7['size']}` | [📥 **点击下载**]({android_armv7['url']}) |
| `{android_x86_64['name']}` | PC 安卓模拟器 (雷电/MuMu) / x86 车机 | x86_64 专用 | `{android_x86_64['size']}` | [📥 **点击下载**]({android_x86_64['url']}) |

---

#### 🍏 macOS 专区
| 软件包名称 | 适用架构 | 类型 | 文件大小 | 直接下载链接 |
| :--- | :--- | :---: | :---: | :---: |
| `{macos_dmg['name']}` | Apple Silicon (M1~M4) & Intel x64 | 🌟 **推荐 DMG** | `{macos_dmg['size']}` | [📥 **点击下载**]({macos_dmg['url']}) |
| `{macos_zip['name']}` | Apple Silicon (M1~M4) & Intel x64 | 便携绿色归档 | `{macos_zip['size']}` | [📥 **点击下载**]({macos_zip['url']}) |

---

#### 🐧 Linux 专区
| 软件包名称 | 适用 Linux 发行版 | 类型 | 文件大小 | 直接下载链接 |
| :--- | :--- | :---: | :---: | :---: |
| `{linux_appimage['name']}` | 全主流 Linux 发行版 (独立沙箱) | 🌟 **推荐独立版** | `{linux_appimage['size']}` | [📥 **点击下载**]({linux_appimage['url']}) |
| `{linux_deb['name']}` | Ubuntu / Debian / Linux Mint / Deepin / UOS | 原生 DEB 安装包 | `{linux_deb['size']}` | [📥 **点击下载**]({linux_deb['url']}) |
| `{linux_rpm['name']}` | Fedora / RedHat / CentOS / openSUSE | 原生 RPM 安装包 | `{linux_rpm['size']}` | [📥 **点击下载**]({linux_rpm['url']}) |
| `{linux_pacman['name']}` | Arch Linux / Manjaro | 原生 Pacman 包 | `{linux_pacman['size']}` | [📥 **点击下载**]({linux_pacman['url']}) |
| `{linux_tar['name']}` | Linux x64 通用二进制压缩包 | 绿色免安装包 | `{linux_tar['size']}` | [📥 **点击下载**]({linux_tar['url']}) |

---

#### 📱 iOS 专区
| 软件包名称 | 适用设备 | 安装方式 | 文件大小 | 直接下载链接 |
| :--- | :--- | :---: | :---: | :---: |
| `{ios_ipa['name']}` | iPhone / iPad (iOS 14.0+) | TrollStore 永久免签 / AltStore 侧载 | `{ios_ipa['size']}` | [📥 **点击下载**]({ios_ipa['url']}) |

---

### 🔐 完整性校验 (SHA-256 Checksums)

<details>
<summary><b>🔍 点击展开查看所有安装包的 SHA-256 校验和列表</b></summary>

```text
{checksum_block}
```

</details>

---

### 💡 各平台安装提示与排障指南 / Platform Notes

<details>
<summary><b>🪟 Windows 安装与运行说明</b></summary>

- 若首次运行提示 **Windows Defender SmartScreen 已保护你的电脑**，请点击 **「更多信息」**，然后选择 **「仍要运行」** 即可正常使用。
- 便携版（Zip）解压即可直接运行，数据与配置默认保留在当前目录下的便携模式或系统 AppData 目录中。
- 如需使用 TUN 虚拟网卡模式，请确保以管理员权限启动客户端。
</details>

<details>
<summary><b>🍏 macOS 运行与 Gatekeeper 权限</b></summary>

- 首次打开若提示 **「已损坏，打不开」** 或 **「无法打开，因为无法验证开发者」**，这是 macOS 系统的 Gatekeeper 安全防护机制，请打开终端（Terminal）执行以下命令解除限制：
  ```bash
  sudo xattr -rd com.apple.quarantine /Applications/Wmimo.app
  ```
</details>

<details>
<summary><b>🐧 Linux 权限与 TUN 模式配置</b></summary>

- **AppImage 格式**：下载后右键文件属性勾选「允许作为程序执行文件」，或在终端执行：
  ```bash
  chmod +x Wmimo-Linux-x64-*.AppImage
  ./Wmimo-Linux-x64-*.AppImage
  ```
- 若使用 TUN 虚拟网卡模式，请在终端执行以下命令为内核服务赋予网络管理权能：
  ```bash
  sudo setcap cap_net_admin,cap_net_bind_service=+ep /opt/wmimo/wmimoService
  ```
</details>

<details>
<summary><b>📱 iOS / iPadOS 安装说明</b></summary>

- 推荐使用 **TrollStore** 进行安装，享受永久免签名、后台静默保活与完整的 NetworkExtension VPN 权限支持。
- 若使用 **AltStore** 或 **Sideloadly** 个人开发者证书侧载，请注意 7 天签名期限并赋予 VPN 扩展对应权限。
</details>
"""

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(markdown.strip() + "\n")

    print(f"[SUCCESS] Advanced release notes generated at: {output_file}")

if __name__ == "__main__":
    main()
