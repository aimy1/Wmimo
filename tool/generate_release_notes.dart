import 'dart:io';
import 'package:crypto/crypto.dart';

String formatSize(int bytes) {
  if (bytes <= 0) return 'N/A';
  final units = ['B', 'KB', 'MB', 'GB'];
  double size = bytes.toDouble();
  for (int i = 0; i < units.length; i++) {
    if (size < 1024.0 || i == units.length - 1) {
      return i == 0 ? '${size.toInt()} B' : '${size.toStringAsFixed(1)} ${units[i]}';
    }
    size /= 1024.0;
  }
  return '${size.toStringAsFixed(1)} MB';
}

String computeSha256(File file) {
  final bytes = file.readAsBytesSync();
  return sha256.convert(bytes).toString();
}

class AssetInfo {
  final String name;
  final String size;
  final String sha256;
  final String url;

  AssetInfo({
    required this.name,
    required this.size,
    required this.sha256,
    required this.url,
  });
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
  final repo = args[1].trim();
  final assetsDir = Directory(args[2].trim());
  final outputFile = File(args[3].trim());
  String buildNumber = args.length > 4 ? args[4].trim() : '';

  final rawVer = tag.replaceFirst(RegExp(r'^v'), '');
  final baseVer = rawVer.split('+')[0].split('.').take(3).join('.');
  if (buildNumber.isEmpty) {
    if (tag.contains('+')) {
      buildNumber = tag.split('+')[1];
    } else {
      final parts = rawVer.split('.');
      buildNumber = parts.length > 3 ? parts[3] : '1512';
    }
  }

  final nowUtc = DateTime.now().toUtc();
  final releaseDate = '${nowUtc.year}-${nowUtc.month.toString().padLeft(2, '0')}-${nowUtc.day.toString().padLeft(2, '0')} ${nowUtc.hour.toString().padLeft(2, '0')}:${nowUtc.minute.toString().padLeft(2, '0')} UTC';
  final baseDownloadUrl = 'https://github.com/$repo/releases/download/$tag';

  final filesMap = <String, AssetInfo>{};
  final checksumsList = <String>[];

  if (assetsDir.existsSync()) {
    final list = assetsDir.listSync().whereType<File>().toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    for (final file in list) {
      final fname = file.uri.pathSegments.last;
      if (fname.isEmpty || fname.startsWith('.')) continue;

      final bytes = file.lengthSync();
      final sizeStr = formatSize(bytes);
      final sha = computeSha256(file);

      if (fname != 'SHA256SUMS.txt') {
        checksumsList.add('$sha  $fname');
      }

      filesMap[fname] = AssetInfo(
        name: fname,
        size: sizeStr,
        sha256: sha,
        url: '$baseDownloadUrl/$fname',
      );
    }
  }

  AssetInfo getInfo(RegExp pattern, String defaultName) {
    for (final entry in filesMap.entries) {
      if (pattern.hasMatch(entry.key)) {
        return entry.value;
      }
    }
    return AssetInfo(
      name: defaultName,
      size: 'Auto',
      sha256: '自动计算',
      url: '$baseDownloadUrl/$defaultName',
    );
  }

  // Windows
  final winX64Exe = getInfo(RegExp(r'Windows.*x64.*Setup.*\.exe$', caseSensitive: false), 'Wmimo-Windows-x64-Setup-$tag.exe');
  final winX64Zip = getInfo(RegExp(r'Windows.*x64.*\.zip$', caseSensitive: false), 'Wmimo-Windows-x64-$tag.zip');
  final winArm64Exe = getInfo(RegExp(r'Windows.*arm64.*Setup.*\.exe$', caseSensitive: false), 'Wmimo-Windows-arm64-Setup-$tag.exe');
  final winArm64Zip = getInfo(RegExp(r'Windows.*arm64.*\.zip$', caseSensitive: false), 'Wmimo-Windows-arm64-$tag.zip');

  // Android
  final androidArm64 = getInfo(RegExp(r'Android.*arm64-v8a.*\.apk$', caseSensitive: false), 'Wmimo-Android-arm64-v8a-$tag.apk');
  final androidUniv = getInfo(RegExp(r'Android.*universal.*\.apk$', caseSensitive: false), 'Wmimo-Android-universal-$tag.apk');
  final androidArmv7 = getInfo(RegExp(r'Android.*armeabi-v7a.*\.apk$', caseSensitive: false), 'Wmimo-Android-armeabi-v7a-$tag.apk');
  final androidX86_64 = getInfo(RegExp(r'Android.*x86_64.*\.apk$', caseSensitive: false), 'Wmimo-Android-x86_64-$tag.apk');

  // macOS
  final macosDmg = getInfo(RegExp(r'macOS.*\.dmg$', caseSensitive: false), 'Wmimo-macOS-universal-$tag.dmg');
  final macosZip = getInfo(RegExp(r'macOS.*\.zip$', caseSensitive: false), 'Wmimo-macOS-universal-$tag.zip');

  // Linux
  final linuxAppImage = getInfo(RegExp(r'Linux.*\.AppImage$', caseSensitive: false), 'Wmimo-Linux-x64-$tag.AppImage');
  final linuxDeb = getInfo(RegExp(r'Linux.*\.deb$', caseSensitive: false), 'Wmimo-Linux-x64-$tag.deb');
  final linuxRpm = getInfo(RegExp(r'Linux.*\.rpm$', caseSensitive: false), 'Wmimo-Linux-x64-$tag.rpm');
  final linuxPacman = getInfo(RegExp(r'Linux.*\.pkg\.tar\.zst$', caseSensitive: false), 'Wmimo-Linux-x64-$tag.pkg.tar.zst');
  final linuxTar = getInfo(RegExp(r'Linux.*\.tar\.gz$', caseSensitive: false), 'Wmimo-Linux-x64-$tag.tar.gz');

  // iOS
  final iosIpa = getInfo(RegExp(r'iOS.*\.ipa$', caseSensitive: false), 'Wmimo-iOS-universal-$tag.ipa');

  final checksumBlock = checksumsList.isNotEmpty
      ? checksumsList.join('\n')
      : 'SHA256SUMS.txt 将在构建完成后由工作流自动计算并上传。';

  final buffer = StringBuffer();
  buffer.writeln('# 🚀 Wmimo $tag 发布说明 / Release Notes\n');
  buffer.writeln('> 简洁、现代、高性能的跨平台 Clash / Mihomo 桌面与移动端图形客户端。');
  buffer.writeln('> A sleek, modern, high-performance cross-platform Clash / Mihomo GUI proxy client.\n');
  buffer.writeln('---\n');

  buffer.writeln('### 📌 版本概要 / Version Overview\n');
  buffer.writeln('| 项目 / Item | 信息 / Details |');
  buffer.writeln('| :--- | :--- |');
  buffer.writeln('| **版本发布标签 (Release Tag)** | `$tag` |');
  buffer.writeln('| **基础版本 (Base Version)** | `v$baseVer` |');
  buffer.writeln('| **内部构建号 (Build Number)** | `$buildNumber` |');
  buffer.writeln('| **完整版本号 (Full Version)** | `$baseVer.$buildNumber` (`$baseVer+$buildNumber`) |');
  buffer.writeln('| **构建时间 (Build Time)** | `$releaseDate` |');
  buffer.writeln('| **开源主页 (Repository)** | [github.com/$repo](https://github.com/$repo) |\n');
  buffer.writeln('---\n');

  buffer.writeln('### 📦 全平台软件包直接下载 / Downloads by Platform\n');
  buffer.writeln('> [!TIP]');
  buffer.writeln('> **💡 新手快速选包指南 / Quick Guide**：');
  buffer.writeln('> - **Windows**：推荐下载 `Wmimo-Windows-x64-Setup`（适用于绝大多数 64 位 Windows 10/11 电脑）。');
  buffer.writeln('> - **Android**：推荐下载 `Wmimo-Android-arm64-v8a`（99% 现代安卓手机与平板的首选，体积更小、运行更流畅）。');
  buffer.writeln('> - **macOS**：推荐下载 `Wmimo-macOS-universal.dmg`（同时原生支持 Apple Silicon M1/M2/M3/M4 及 Intel 芯片，拖拽安装即可）。');
  buffer.writeln('> - **Linux**：推荐下载 `Wmimo-Linux-x64.AppImage`（无需安装，全发行版双击即用）。');
  buffer.writeln('> - **iOS**：下载 `Wmimo-iOS-universal.ipa`（适用于 TrollStore 永久免签安装，或使用 AltStore / Sideloadly 侧载）。\n');
  buffer.writeln('---\n');

  // Windows Table
  buffer.writeln('#### 🪟 Windows 专区');
  buffer.writeln('| 软件包名称 | 适用平台 / 架构 | 类型 | 文件大小 | 直接下载链接 |');
  buffer.writeln('| :--- | :--- | :---: | :---: | :---: |');
  buffer.writeln('| `${winX64Exe.name}` | Windows 10 / 11 (64-bit) | 🌟 **推荐安装包** | `${winX64Exe.size}` | [📥 **点击下载**](${winX64Exe.url}) |');
  buffer.writeln('| `${winX64Zip.name}` | Windows 10 / 11 (64-bit) | 免安装便携版 | `${winX64Zip.size}` | [📥 **点击下载**](${winX64Zip.url}) |');
  buffer.writeln('| `${winArm64Exe.name}` | Windows 11 ARM64 (Surface / 骁龙X) | ARM64 安装包 | `${winArm64Exe.size}` | [📥 **点击下载**](${winArm64Exe.url}) |');
  buffer.writeln('| `${winArm64Zip.name}` | Windows 11 ARM64 (Surface / 骁龙X) | ARM64 便携版 | `${winArm64Zip.size}` | [📥 **点击下载**](${winArm64Zip.url}) |\n');
  buffer.writeln('---\n');

  // Android Table
  buffer.writeln('#### 🤖 Android 专区');
  buffer.writeln('| 软件包名称 | 适用设备 / 架构 | 类型 | 文件大小 | 直接下载链接 |');
  buffer.writeln('| :--- | :--- | :---: | :---: | :---: |');
  buffer.writeln('| `${androidArm64.name}` | 现代主流安卓手机 / 平板 (arm64-v8a) | 🌟 **首选推荐** | `${androidArm64.size}` | [📥 **点击下载**](${androidArm64.url}) |');
  buffer.writeln('| `${androidUniv.name}` | 全机型通用 (Universal All ABIs) | 完整通用包 | `${androidUniv.size}` | [📥 **点击下载**](${androidUniv.url}) |');
  buffer.writeln('| `${androidArmv7.name}` | 老旧 32 位设备 / 旧安卓电视盒子 | 32位兼容包 | `${androidArmv7.size}` | [📥 **点击下载**](${androidArmv7.url}) |');
  buffer.writeln('| `${androidX86_64.name}` | PC 安卓模拟器 (雷电/MuMu) / x86 车机 | x86_64 专用 | `${androidX86_64.size}` | [📥 **点击下载**](${androidX86_64.url}) |\n');
  buffer.writeln('---\n');

  // macOS Table
  buffer.writeln('#### 🍏 macOS 专区');
  buffer.writeln('| 软件包名称 | 适用架构 | 类型 | 文件大小 | 直接下载链接 |');
  buffer.writeln('| :--- | :--- | :---: | :---: | :---: |');
  buffer.writeln('| `${macosDmg.name}` | Apple Silicon (M1~M4) & Intel x64 | 🌟 **推荐 DMG** | `${macosDmg.size}` | [📥 **点击下载**](${macosDmg.url}) |');
  buffer.writeln('| `${macosZip.name}` | Apple Silicon (M1~M4) & Intel x64 | 便携绿色归档 | `${macosZip.size}` | [📥 **点击下载**](${macosZip.url}) |\n');
  buffer.writeln('---\n');

  // Linux Table
  buffer.writeln('#### 🐧 Linux 专区');
  buffer.writeln('| 软件包名称 | 适用 Linux 发行版 | 类型 | 文件大小 | 直接下载链接 |');
  buffer.writeln('| :--- | :--- | :---: | :---: | :---: |');
  buffer.writeln('| `${linuxAppImage.name}` | 全主流 Linux 发行版 (独立沙箱) | 🌟 **推荐独立版** | `${linuxAppImage.size}` | [📥 **点击下载**](${linuxAppImage.url}) |');
  buffer.writeln('| `${linuxDeb.name}` | Ubuntu / Debian / Linux Mint / Deepin / UOS | 原生 DEB 安装包 | `${linuxDeb.size}` | [📥 **点击下载**](${linuxDeb.url}) |');
  buffer.writeln('| `${linuxRpm.name}` | Fedora / RedHat / CentOS / openSUSE | 原生 RPM 安装包 | `${linuxRpm.size}` | [📥 **点击下载**](${linuxRpm.url}) |');
  buffer.writeln('| `${linuxPacman.name}` | Arch Linux / Manjaro | 原生 Pacman 包 | `${linuxPacman.size}` | [📥 **点击下载**](${linuxPacman.url}) |');
  buffer.writeln('| `${linuxTar.name}` | Linux x64 通用二进制压缩包 | 绿色免安装包 | `${linuxTar.size}` | [📥 **点击下载**](${linuxTar.url}) |\n');
  buffer.writeln('---\n');

  // iOS Table
  buffer.writeln('#### 📱 iOS 专区');
  buffer.writeln('| 软件包名称 | 适用设备 | 安装方式 | 文件大小 | 直接下载链接 |');
  buffer.writeln('| :--- | :--- | :---: | :---: | :---: |');
  buffer.writeln('| `${iosIpa.name}` | iPhone / iPad (iOS 14.0+) | TrollStore 永久免签 / AltStore 侧载 | `${iosIpa.size}` | [📥 **点击下载**](${iosIpa.url}) |\n');
  buffer.writeln('---\n');

  // Checksums
  buffer.writeln('### 🔐 完整性校验 (SHA-256 Checksums)\n');
  buffer.writeln('<details>');
  buffer.writeln('<summary><b>🔍 点击展开查看所有安装包的 SHA-256 校验和列表</b></summary>\n');
  buffer.writeln('```text');
  buffer.writeln(checksumBlock);
  buffer.writeln('```\n');
  buffer.writeln('</details>\n');
  buffer.writeln('---\n');

  // Platform Guides
  buffer.writeln('### 💡 各平台安装提示与排障指南 / Platform Notes\n');
  buffer.writeln('<details>');
  buffer.writeln('<summary><b>🪟 Windows 安装与运行说明</b></summary>\n');
  buffer.writeln('- 若首次运行提示 **Windows Defender SmartScreen 已保护你的电脑**，请点击 **「更多信息」**，然后选择 **「仍要运行」** 即可正常使用。');
  buffer.writeln('- 便携版（Zip）解压即可直接运行，数据与配置默认保留在当前目录下的便携模式或系统 AppData 目录中。');
  buffer.writeln('- 如需使用 TUN 虚拟网卡模式，请确保以管理员权限启动客户端。');
  buffer.writeln('</details>\n');

  buffer.writeln('<details>');
  buffer.writeln('<summary><b>🍏 macOS 运行与 Gatekeeper 权限</b></summary>\n');
  buffer.writeln('- 首次打开若提示 **「已损坏，打不开」** 或 **「无法打开，因为无法验证开发者」**，这是 macOS 系统的 Gatekeeper 安全防护机制，请打开终端（Terminal）执行以下命令解除限制：');
  buffer.writeln('  ```bash');
  buffer.writeln('  sudo xattr -rd com.apple.quarantine /Applications/Wmimo.app');
  buffer.writeln('  ```');
  buffer.writeln('</details>\n');

  buffer.writeln('<details>');
  buffer.writeln('<summary><b>🐧 Linux 权限与 TUN 模式配置</b></summary>\n');
  buffer.writeln('- **AppImage 格式**：下载后右键文件属性勾选「允许作为程序执行文件」，或在终端执行：');
  buffer.writeln('  ```bash');
  buffer.writeln('  chmod +x Wmimo-Linux-x64-*.AppImage');
  buffer.writeln('  ./Wmimo-Linux-x64-*.AppImage');
  buffer.writeln('  ```');
  buffer.writeln('- 若使用 TUN 虚拟网卡模式，请在终端执行以下命令为内核服务赋予网络管理权能：');
  buffer.writeln('  ```bash');
  buffer.writeln('  sudo setcap cap_net_admin,cap_net_bind_service=+ep /opt/wmimo/wmimoService');
  buffer.writeln('  ```');
  buffer.writeln('</details>\n');

  buffer.writeln('<details>');
  buffer.writeln('<summary><b>📱 iOS / iPadOS 安装说明</b></summary>\n');
  buffer.writeln('- 推荐使用 **TrollStore** 进行安装，享受永久免签名、后台静默保活与完整的 NetworkExtension VPN 权限支持。');
  buffer.writeln('- 若使用 **AltStore** 或 **Sideloadly** 个人开发者证书侧载，请注意 7 天签名期限并赋予 VPN 扩展对应权限。');
  buffer.writeln('</details>\n');

  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(buffer.toString());
  print('[SUCCESS] Advanced release notes generated at: ${outputFile.path}');
}
