import 'dart:io';
import 'package:crypto/crypto.dart';

String computeSha256(File file) {
  final bytes = file.readAsBytesSync();
  return sha256.convert(bytes).toString();
}

void main(List<String> args) {
  if (args.length < 4) {
    print('Usage: dart run tool/generate_release_notes.dart <tag> <repo> <assets_dir> <output_file> [build_number]');
    exit(1);
  }

  String tag = args[0].trim();
  if (!tag.startsWith('v')) {
    tag = 'v$tag';
  }
  final assetsDir = Directory(args[2].trim());
  final outputFile = File(args[3].trim());

  final checksumsList = <String>[];
  if (assetsDir.existsSync()) {
    final list = assetsDir.listSync().whereType<File>().toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    for (final file in list) {
      final fname = file.uri.pathSegments.last;
      if (fname.isEmpty || fname.startsWith('.') || fname == 'SHA256SUMS.txt') {
        continue;
      }
      checksumsList.add('${computeSha256(file)}  $fname');
    }
  }

  final checksumBlock = checksumsList.isNotEmpty
      ? checksumsList.join('\n')
      : '详见附件 SHA256SUMS.txt';

  final markdown = '''## 更新内容 ($tag)

- **原生黑色暗黑模式**：全面重构 Dark 模式为纯正原生桌面软件中性黑灰体系（`#121212` / `#1C1C1E`），消除蓝色偏色。
- **沉浸式无边框标题栏**：移除桌面端原生标题栏，左右分栏一通到底，右上角内置主题自适应窗口控制按钮。
- **IP 信息与赞助界面重构**：升级为现代内嵌圆角卡片与 2×2 参数网格布局，修复时区偏移显示与重复操作按钮。
- **高清全 DPI 图标与多架构支持**：重制 10 层全 DPI 矢量抗锯齿 Windows 图标（`.ico`），补齐 Linux `.AppImage` 与 `arm64` 架构安装包。
- **交互优化与内核升级**：修复节点列表地区筛选栏鼠标滚轮横向滚动，同步升级 Mihomo 核心至 `v1.19.33`。

## 选包建议

- **Windows**：提供 `x64` 与 `arm64` 架构，可选 `Setup.exe`（安装版）或 `.zip`（便携版）
- **Android**：提供 `arm64-v8a`（主流推荐）、`armeabi-v7a`、`x86_64` 与 `universal`（通用版）
- **macOS**：`universal.dmg` / `.zip`（Apple Silicon `arm64` 与 Intel `x64` 双架构通用，如遇拦截执行 `sudo xattr -rd com.apple.quarantine /Applications/Wmimo.app`）
- **Linux**：提供 `x64` 与 `arm64` 架构，含 `.AppImage` / `.deb` / `.rpm` / `.pkg.tar.zst` / `.tar.gz`
- **iOS**：`universal.ipa`（`arm64`，支持 TrollStore / AltStore 安装）

<details>
<summary>SHA-256 校验和</summary>

```text
$checksumBlock
```

</details>
''';

  outputFile.writeAsStringSync(markdown);
  print('Successfully generated simplified release notes at ${outputFile.path}');
}
