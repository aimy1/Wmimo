#!/usr/bin/env python3
"""
Simplified GitHub Release Notes Generator for Wmimo.
"""

import sys
import os
import hashlib


def compute_sha256(filepath):
    sha = hashlib.sha256()
    with open(filepath, "rb") as f:
        while chunk := f.read(65536):
            sha.update(chunk)
    return sha.hexdigest()


def main():
    if len(sys.argv) < 5:
        print("Usage: generate_release_notes.py <tag> <repo> <assets_dir> <output_file> [build_number]")
        sys.exit(1)

    tag = sys.argv[1].strip()
    if not tag.startswith("v"):
        tag = "v" + tag
    assets_dir = sys.argv[3].strip()
    output_file = sys.argv[4].strip()

    checksums = []
    if os.path.exists(assets_dir):
        for fname in sorted(os.listdir(assets_dir)):
            fpath = os.path.join(assets_dir, fname)
            if not os.path.isfile(fpath) or fname.startswith(".") or fname == "SHA256SUMS.txt":
                continue
            checksums.append(f"{compute_sha256(fpath)}  {fname}")

    checksum_block = "\n".join(checksums) if checksums else "详见附件 SHA256SUMS.txt"

    markdown = f"""## 更新内容 ({tag})

- **连接管理全面升级**：新增连接详情弹窗（支持查看完整路径与分流规则、一键复制目标/JSON、单条断开），支持按 6 种规则排序，支持实时上下行速率计算与快捷联动过滤。
- **订阅配置桌面端交互增强**：新增桌面端鼠标右键快捷菜单，卡片实时统计节点数量，配置覆写标签点击直达，支持在文件夹中显示定位 YAML 文件、复制路径及创建配置副本。
- **界面视觉微调与重构**：首页卡片图标轻量化线性风，状态标签改用极简无框原点指示，微调卡片选中态微光蓝底衬，重构捐赠页面为现代极简卡片与高清二维码。
- **问题修复**：修复连接关闭全部按钮常驻置灰逻辑，修复节点国旗 Emoji 系统字体回退，优化桌面侧边栏居中对齐。

## 选包建议

- **Windows**：提供 `x64` 与 `arm64` 架构，可选 `Setup.exe`（安装版）或 `.zip`（便携版）
- **Android**：提供 `arm64-v8a`（主流推荐）、`armeabi-v7a`、`x86_64` 与 `universal`（通用版）
- **macOS**：`universal.dmg` / `.zip`（Apple Silicon `arm64` 与 Intel `x64` 双架构通用，如遇拦截执行 `sudo xattr -rd com.apple.quarantine /Applications/Wmimo.app`）
- **Linux**：提供 `x64` 与 `arm64` 架构，含 `.AppImage` / `.deb` / `.rpm` / `.pkg.tar.zst` / `.tar.gz`
- **iOS**：`universal.ipa`（`arm64`，支持 TrollStore / AltStore 安装）

<details>
<summary>SHA-256 校验和</summary>

```text
{checksum_block}
```

</details>
"""

    with open(output_file, "w", encoding="utf-8") as f:
        f.write(markdown)

    print(f"Successfully generated simplified release notes at {output_file}")


if __name__ == "__main__":
    main()
