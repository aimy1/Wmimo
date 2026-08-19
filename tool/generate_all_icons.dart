import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:image/image.dart' as img;

Uint8List createIco(List<img.Image> images) {
  final pngBuffers = <Uint8List>[];
  for (final image in images) {
    pngBuffers.add(Uint8List.fromList(img.encodePng(image)));
  }

  final count = images.length;
  final headerSize = 6;
  final dirEntrySize = 16;
  int offset = headerSize + count * dirEntrySize;

  final byteData = BytesBuilder();

  // ICONDIR header
  final header = ByteData(6);
  header.setUint16(0, 0, Endian.little);
  header.setUint16(2, 1, Endian.little);
  header.setUint16(4, count, Endian.little);
  byteData.add(header.buffer.asUint8List());

  // ICONDIRENTRY entries
  for (int i = 0; i < count; i++) {
    final image = images[i];
    final pngData = pngBuffers[i];
    final entry = ByteData(16);

    final width = image.width >= 256 ? 0 : image.width;
    final height = image.height >= 256 ? 0 : image.height;

    entry.setUint8(0, width);
    entry.setUint8(1, height);
    entry.setUint8(2, 0);
    entry.setUint8(3, 0);
    entry.setUint16(4, 1, Endian.little);
    entry.setUint16(6, 32, Endian.little);
    entry.setUint32(8, pngData.length, Endian.little);
    entry.setUint32(12, offset, Endian.little);

    byteData.add(entry.buffer.asUint8List());
    offset += pngData.length;
  }

  for (final pngData in pngBuffers) {
    byteData.add(pngData);
  }

  return byteData.toBytes();
}

img.Image createRoundIcon(img.Image src, int size) {
  final resized = img.copyResize(src, width: size, height: size, interpolation: img.Interpolation.linear);
  final output = img.Image(width: size, height: size, numChannels: 4);
  final center = size / 2.0;
  final radius = size / 2.0;

  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final dx = x + 0.5 - center;
      final dy = y + 0.5 - center;
      final dist = math.sqrt(dx * dx + dy * dy);

      if (dist <= radius - 1.0) {
        output.setPixel(x, y, resized.getPixel(x, y));
      } else if (dist <= radius) {
        final alphaFactor = (radius - dist).clamp(0.0, 1.0);
        final p = resized.getPixel(x, y);
        final a = (p.a * alphaFactor).round();
        output.setPixelRgba(x, y, p.r.toInt(), p.g.toInt(), p.b.toInt(), a);
      } else {
        output.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }
  return output;
}

img.Image createMonochromeSilhouette(img.Image src, int size, {bool padding = true}) {
  // Extract white cat face silhouette (cat is white, background & eyes/mouth are blue/cyan)
  final silhouette = img.Image(width: src.width, height: src.height, numChannels: 4);

  for (int y = 0; y < src.height; y++) {
    for (int x = 0; x < src.width; x++) {
      final p = src.getPixel(x, y);
      final r = p.r.toDouble();
      final g = p.g.toDouble();
      final b = p.b.toDouble();
      final a = p.a.toDouble();

      // White cat body has high lightness and low color saturation
      // Cyan bg has high G and B, lower R (r < 100, g > 150, b > 180)
      // White cat has r > 200, g > 200, b > 200
      final isWhite = r > 180 && g > 180 && b > 180 && a > 100;
      if (isWhite) {
        // Calculate softness/smoothness
        final brightness = (r + g + b) / 3.0 / 255.0;
        final outAlpha = ((brightness - 0.6) / 0.4).clamp(0.0, 1.0) * 255.0;
        silhouette.setPixelRgba(x, y, 255, 255, 255, outAlpha.round());
      } else {
        silhouette.setPixelRgba(x, y, 255, 255, 255, 0);
      }
    }
  }

  // Resize to target size with optional padding for status bar / tiles
  final targetSize = size;
  if (!padding) {
    return img.copyResize(silhouette, width: targetSize, height: targetSize, interpolation: img.Interpolation.linear);
  }

  final innerSize = (targetSize * 0.8).round();
  final resizedInner = img.copyResize(silhouette, width: innerSize, height: innerSize, interpolation: img.Interpolation.linear);
  final output = img.Image(width: targetSize, height: targetSize, numChannels: 4);
  img.fill(output, color: img.ColorRgba8(0, 0, 0, 0));

  final offsetX = (targetSize - innerSize) ~/ 2;
  final offsetY = (targetSize - innerSize) ~/ 2;
  img.compositeImage(output, resizedInner, dstX: offsetX, dstY: offsetY);

  return output;
}

img.Image createAdaptiveForeground(img.Image src, int canvasSize) {
  // Android Adaptive icon standard: 432x432 or 512x512 canvas, safe zone is inner 66% (285dp)
  final output = img.Image(width: canvasSize, height: canvasSize, numChannels: 4);
  img.fill(output, color: img.ColorRgba8(0, 0, 0, 0));

  // The icon should occupy ~65% of the canvas in the center
  final iconSize = (canvasSize * 0.65).round();
  final resized = img.copyResize(src, width: iconSize, height: iconSize, interpolation: img.Interpolation.linear);

  final offsetX = (canvasSize - iconSize) ~/ 2;
  final offsetY = (canvasSize - iconSize) ~/ 2;
  img.compositeImage(output, resized, dstX: offsetX, dstY: offsetY);

  return output;
}

img.Image createTvBanner(img.Image src, int width, int height) {
  // 320x180 Android TV banner
  final output = img.Image(width: width, height: height, numChannels: 4);
  // Fill background with matching brand cyan color #00BCDF (rgb: 0, 188, 223)
  img.fill(output, color: img.ColorRgba8(0, 188, 223, 255));

  // Place icon in center (height ~140)
  final iconSize = 130;
  final resized = img.copyResize(src, width: iconSize, height: iconSize, interpolation: img.Interpolation.linear);
  final offsetX = (width - iconSize) ~/ 2;
  final offsetY = (height - iconSize) ~/ 2;
  img.compositeImage(output, resized, dstX: offsetX, dstY: offsetY);

  return output;
}

void saveSvgWithPng(String path, int width, int height, Uint8List pngBytes, {int rx = 115}) {
  final base64Png = base64Encode(pngBytes);
  final svgContent = '''<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 $width $height" width="100%" height="100%">
  <defs>
    <clipPath id="wmimo-icon-clip">
      <rect width="$width" height="$height" rx="$rx" ry="$rx" />
    </clipPath>
  </defs>
  <g clip-path="url(#wmimo-icon-clip)">
    <image href="data:image/png;base64,$base64Png" width="$width" height="$height" />
  </g>
</svg>
''';
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(svgContent);
  print('Generated SVG: $path');
}

void main(List<String> args) async {
  String srcPath = args.isNotEmpty ? args[0] : '';
  if (srcPath.isEmpty || !File(srcPath).existsSync()) {
    final candidatePaths = [
      r'C:\Users\win\.gemini\antigravity-ide\brain\a7eb5ff2-8b08-40e1-a05b-d3fdf8cd4a66\.user_uploaded\media_1787114312410.png',
      r'assets/images/app_icon_256.png',
    ];
    for (final p in candidatePaths) {
      if (File(p).existsSync()) {
        srcPath = p;
        break;
      }
    }
  }

  print('Reading source image from: $srcPath');
  final srcBytes = await File(srcPath).readAsBytes();
  final srcImage = img.decodeImage(srcBytes);
  if (srcImage == null) {
    print('Failed to decode image');
    exit(1);
  }

  print('Source image dimensions: ${srcImage.width}x${srcImage.height}');

  void savePng(String path, int width, int height, {bool grayscale = false}) {
    var resized = img.copyResize(srcImage, width: width, height: height, interpolation: img.Interpolation.linear);
    if (grayscale) {
      resized = img.grayscale(resized);
    }
    final file = File(path);
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(img.encodePng(resized));
    print('Generated: $path (${width}x$height)');
  }

  void saveRound(String path, int size) {
    final roundImg = createRoundIcon(srcImage, size);
    final file = File(path);
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(img.encodePng(roundImg));
    print('Generated Round: $path (${size}x$size)');
  }

  void saveIco(String path, List<int> sizes, {bool grayscale = false}) {
    final images = <img.Image>[];
    for (final size in sizes) {
      var resized = img.copyResize(srcImage, width: size, height: size, interpolation: img.Interpolation.linear);
      if (grayscale) {
        resized = img.grayscale(resized);
      }
      images.add(resized);
    }
    final icoBytes = createIco(images);
    final file = File(path);
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(icoBytes);
    print('Generated ICO: $path with sizes: $sizes');
  }

  void saveSilhouettePng(String path, int size, {bool padding = true}) {
    final sil = createMonochromeSilhouette(srcImage, size, padding: padding);
    final file = File(path);
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(img.encodePng(sil));
    print('Generated Silhouette: $path (${size}x$size)');
  }

  // 1. Flutter Assets
  savePng('assets/images/app_icon_128.png', 128, 128);
  savePng('assets/images/app_icon_256.png', 256, 256);
  savePng('assets/demo/icon_256.png', 256, 256);
  savePng('assets/images/tray.png', 32, 32);
  savePng('assets/images/grey_tray.png', 32, 32, grayscale: true);
  saveIco('assets/images/tray.ico', [16, 32, 48, 64]);
  saveIco('assets/images/grey_tray.ico', [16, 32, 48, 64], grayscale: true);

  // 2. Windows Runner Icon
  saveIco('windows/runner/resources/app_icon.ico', [16, 32, 48, 64, 128, 256]);

  // 3. Android Mipmaps & Drawables
  // Standard launcher icons
  savePng('android/app/src/main/res/mipmap-mdpi/ic_launcher.png', 48, 48);
  savePng('android/app/src/main/res/mipmap-hdpi/ic_launcher.png', 72, 72);
  savePng('android/app/src/main/res/mipmap-xhdpi/ic_launcher.png', 96, 96);
  savePng('android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png', 144, 144);
  savePng('android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png', 192, 192);

  // Round launcher icons (for Android devices supporting round icons)
  saveRound('android/app/src/main/res/mipmap-mdpi/ic_launcher_round.png', 48);
  saveRound('android/app/src/main/res/mipmap-hdpi/ic_launcher_round.png', 72);
  saveRound('android/app/src/main/res/mipmap-xhdpi/ic_launcher_round.png', 96);
  saveRound('android/app/src/main/res/mipmap-xxhdpi/ic_launcher_round.png', 144);
  saveRound('android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_round.png', 192);

  // Adaptive Icon Foreground (432x432)
  final adaptiveFg = createAdaptiveForeground(srcImage, 432);
  File('android/app/src/main/res/drawable/ic_launcher_foreground.png')
    ..parent.createSync(recursive: true)
    ..writeAsBytesSync(img.encodePng(adaptiveFg));
  print('Generated: android/app/src/main/res/drawable/ic_launcher_foreground.png (432x432)');

  // Adaptive Icon Background XML & Definitions
  File('android/app/src/main/res/drawable/ic_launcher_background.xml').writeAsStringSync('''<?xml version="1.0" encoding="utf-8"?>
<color xmlns:android="http://schemas.android.com/apk/res/android"
    android:color="#00BCDF" />
''');
  File('android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml').writeAsStringSync('''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background"/>
    <foreground android:drawable="@drawable/ic_launcher_foreground"/>
</adaptive-icon>
''');
  File('android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml').writeAsStringSync('''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background"/>
    <foreground android:drawable="@drawable/ic_launcher_foreground"/>
</adaptive-icon>
''');

  // Status Bar Monochrome notification icon (white silhouette, transparent background)
  saveSilhouettePng('android/app/src/main/res/drawable/ic_statusbar.png', 24);
  saveSilhouettePng('android/app/src/main/res/drawable/ic_tile.png', 80);

  // TV Banner & Background
  final tvBanner = createTvBanner(srcImage, 320, 180);
  File('android/app/src/main/res/drawable/ic_tv_banner.png').writeAsBytesSync(img.encodePng(tvBanner));
  final tvBg = img.Image(width: 320, height: 180, numChannels: 4);
  img.fill(tvBg, color: img.ColorRgba8(0, 188, 223, 255));
  File('android/app/src/main/res/drawable/ic_tv_banner_background.png').writeAsBytesSync(img.encodePng(tvBg));
  print('Generated TV banners');

  // 4. iOS AppIcon
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png', 20, 20);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png', 40, 40);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png', 60, 60);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png', 29, 29);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png', 58, 58);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png', 87, 87);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png', 40, 40);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png', 80, 80);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png', 120, 120);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-57x57@1x.png', 57, 57);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-57x57@2x.png', 114, 114);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png', 120, 120);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png', 180, 180);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-50x50@1x.png', 50, 50);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-50x50@2x.png', 100, 100);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-72x72@1x.png', 72, 72);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-72x72@2x.png', 144, 144);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png', 76, 76);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png', 152, 152);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png', 167, 167);
  savePng('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png', 1024, 1024);

  // iOS LaunchImage (replace old Clash logo with clean cat icon)
  savePng('ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png', 128, 128);
  savePng('ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png', 256, 256);
  savePng('ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png', 384, 384);
  print('Generated iOS LaunchImage set');

  // 5. macOS AppIcon
  savePng('macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png', 16, 16);
  savePng('macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png', 32, 32);
  savePng('macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png', 64, 64);
  savePng('macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png', 128, 128);
  savePng('macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png', 256, 256);
  savePng('macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png', 512, 512);
  savePng('macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png', 1024, 1024);

  // 6. Web & Dashboard
  saveIco('web/favicon.ico', [16, 32, 48]);
  savePng('web/apple-touch-icon.png', 180, 180);
  savePng('web/pwa-192x192.png', 192, 192);
  savePng('web/pwa-512x512.png', 512, 512);
  savePng('web/pwa-maskable-192x192.png', 192, 192);
  savePng('web/pwa-maskable-512x512.png', 512, 512);

  // Flutter web standard icon paths
  savePng('web/icons/Icon-192.png', 192, 192);
  savePng('web/icons/Icon-512.png', 512, 512);
  savePng('web/icons/Icon-maskable-192.png', 192, 192);
  savePng('web/icons/Icon-maskable-512.png', 512, 512);

  // 7. Zashboard web
  saveIco('assets/zashboard/favicon.ico', [16, 32, 48]);
  savePng('assets/zashboard/apple-touch-icon.png', 180, 180);
  savePng('assets/zashboard/pwa-192x192.png', 192, 192);
  savePng('assets/zashboard/pwa-512x512.png', 512, 512);
  savePng('assets/zashboard/pwa-maskable-192x192.png', 192, 192);
  savePng('assets/zashboard/pwa-maskable-512x512.png', 512, 512);

  // 8. SVGs with embedded high-res PNG
  final png512Bytes = Uint8List.fromList(img.encodePng(img.copyResize(srcImage, width: 512, height: 512, interpolation: img.Interpolation.linear)));
  saveSvgWithPng('web/icon.svg', 512, 512, png512Bytes);
  saveSvgWithPng('web/favicon.svg', 512, 512, png512Bytes);
  saveSvgWithPng('web/favicon-dark.svg', 512, 512, png512Bytes);
  saveSvgWithPng('assets/zashboard/icon.svg', 512, 512, png512Bytes);
  saveSvgWithPng('assets/zashboard/favicon.svg', 512, 512, png512Bytes);
  saveSvgWithPng('assets/zashboard/favicon-dark.svg', 512, 512, png512Bytes);

  print('All icons generated successfully!');
}
