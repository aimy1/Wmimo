import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:wmimo/app/runtime/return_result.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:zxing2/qrcode.dart';

class QrcodeUtils {
  static ReturnResult<Image> toImage(String content) {
    try {
      var hints = EncodeHints();
      hints.put<CharacterSetECI>(
        EncodeHintType.characterSet,
        CharacterSetECI.UTF8,
      );
      hints.put<bool>(EncodeHintType.gs1Format, true);
      var qrcode = Encoder.encode(
        content,
        ErrorCorrectionLevel.h,
        hints: hints,
      );
      var matrix = qrcode.matrix!;
      var scale = 4;
      var image = img.Image(
        width: matrix.width * scale,
        height: matrix.height * scale,
        numChannels: 4,
      );
      // Fill white background so saved/copied QR images have proper contrast
      img.fill(image, color: img.ColorRgba8(0xFF, 0xFF, 0xFF, 0xFF));
      for (var x = 0; x < matrix.width; x++) {
        for (var y = 0; y < matrix.height; y++) {
          if (matrix.get(x, y) == 1) {
            img.fillRect(
              image,
              x1: x * scale,
              y1: y * scale,
              x2: x * scale + scale,
              y2: y * scale + scale,
              color: img.ColorRgba8(0, 0, 0, 0xFF),
            );
          }
        }
      }
      final png = img.encodePng(image);
      return ReturnResult(data: Image.memory(png));
    } catch (err) {
      return ReturnResult(error: ReturnResultError(err.toString()));
    }
  }

  static Future<bool> saveAsImage(String content, String path) async {
    try {
      var qrcode = Encoder.encode(content, ErrorCorrectionLevel.h);
      var matrix = qrcode.matrix!;
      var scale = 4;
      var image = img.Image(
        width: matrix.width * scale,
        height: matrix.height * scale,
        numChannels: 4,
      );
      img.fill(image, color: img.ColorRgba8(0xFF, 0xFF, 0xFF, 0xFF));
      for (var x = 0; x < matrix.width; x++) {
        for (var y = 0; y < matrix.height; y++) {
          if (matrix.get(x, y) == 1) {
            img.fillRect(
              image,
              x1: x * scale,
              y1: y * scale,
              x2: x * scale + scale,
              y2: y * scale + scale,
              color: img.ColorRgba8(0, 0, 0, 0xFF),
            );
          }
        }
      }
      final png = img.encodePng(image);
      await File(path).writeAsBytes(png);
    } catch (err) {
      Log.w("QrcodeUtils.saveAsImage exception ${err.toString()}");
      return false;
    }
    return true;
  }

  static Future<String?> scanFromFile(String filePath) async {
    try {
      final image = await img.decodeImageFile(filePath);
      if (image == null) {
        return null;
      }
      return decodeQrFromImage(image);
    } catch (err) {
      Log.w("QrcodeUtils.scanFromFile exception: $err");
      return null;
    }
  }

  static Future<String?> scanFromImageData(Uint8List data) async {
    try {
      final image = img.decodeImage(data);
      if (image == null) {
        return null;
      }
      return decodeQrFromImage(image);
    } catch (err) {
      Log.w("QrcodeUtils.scanFromImageData exception: $err");
      return null;
    }
  }

  /// Robust multi-pass QR code decoder supporting:
  /// 1. Transparent PNG alpha-compositing over white background
  /// 2. `DecodeHintType.tryHarder` + UTF-8 hints
  /// 3. `HybridBinarizer` (local adaptive thresholding for screenshots with dark UI)
  ///    and `GlobalHistogramBinarizer`
  /// 4. Inverted luminance fallback (dark-mode / light-on-dark QR codes)
  /// 5. Quiet-zone border padding (tightly cropped screenshots like PixPin)
  /// 6. Multi-scale & sub-region scanning for Retina / full-window screenshots
  static String? decodeQrFromImage(img.Image original) {
    // 1. Try direct image
    final directResult = _tryDecodeSingleImage(original);
    if (directResult != null && directResult.isNotEmpty) {
      return directResult;
    }

    // 2. Try with added white quiet-zone border (fixes tightly cropped QR codes)
    final padded = _addWhiteQuietZone(original, borderRatio: 0.12);
    final paddedResult = _tryDecodeSingleImage(padded);
    if (paddedResult != null && paddedResult.isNotEmpty) {
      return paddedResult;
    }

    // 3. Try scaled versions (Retina 2x/3x large screenshots or very small QR images)
    final maxDim = math.max(original.width, original.height);
    if (maxDim > 900) {
      for (final targetMax in [800, 500]) {
        final scale = targetMax / maxDim;
        final resized = img.copyResize(
          original,
          width: math.max(64, (original.width * scale).round()),
          height: math.max(64, (original.height * scale).round()),
          interpolation: img.Interpolation.average,
        );
        final res = _tryDecodeSingleImage(resized) ??
            _tryDecodeSingleImage(_addWhiteQuietZone(resized, borderRatio: 0.12));
        if (res != null && res.isNotEmpty) {
          return res;
        }
      }
    } else if (maxDim < 240) {
      final upscaled = img.copyResize(
         padded,
        width: padded.width * 2,
        height: padded.height * 2,
        interpolation: img.Interpolation.nearest,
      );
      final res = _tryDecodeSingleImage(upscaled);
      if (res != null && res.isNotEmpty) {
        return res;
      }
    }

    // 4. Try sub-region crops (when QR code is embedded in a larger window screenshot)
    if (original.width >= 200 && original.height >= 200) {
      final crops = <img.Image>[
        // Center 70%
        img.copyCrop(
          original,
          x: (original.width * 0.15).round(),
          y: (original.height * 0.15).round(),
          width: (original.width * 0.70).round(),
          height: (original.height * 0.70).round(),
        ),
        // Top 65%
        img.copyCrop(
          original,
          x: 0,
          y: 0,
          width: original.width,
          height: (original.height * 0.65).round(),
        ),
        // Bottom 65%
        img.copyCrop(
          original,
          x: 0,
          y: (original.height * 0.35).round(),
          width: original.width,
          height: (original.height * 0.65).round(),
        ),
      ];
      for (final crop in crops) {
        final res = _tryDecodeSingleImage(crop) ??
            _tryDecodeSingleImage(_addWhiteQuietZone(crop, borderRatio: 0.12));
        if (res != null && res.isNotEmpty) {
          return res;
        }
      }
    }

    return null;
  }

  static img.Image _addWhiteQuietZone(
    img.Image src, {
    double borderRatio = 0.12,
  }) {
    final pad = math.max(
      16,
      (math.min(src.width, src.height) * borderRatio).round(),
    );
    final dst = img.Image(
      width: src.width + pad * 2,
      height: src.height + pad * 2,
      numChannels: 4,
    );
    img.fill(dst, color: img.ColorRgba8(0xFF, 0xFF, 0xFF, 0xFF));
    img.compositeImage(dst, src, dstX: pad, dstY: pad);
    return dst;
  }

  static String? _tryDecodeSingleImage(img.Image image) {
    final source = _buildLuminanceSource(image);
    final hints = DecodeHints()
      ..put(DecodeHintType.tryHarder)
      ..put(DecodeHintType.characterSet, 'UTF-8');
    final pureHints = DecodeHints()
      ..put(DecodeHintType.tryHarder)
      ..put(DecodeHintType.pureBarcode)
      ..put(DecodeHintType.characterSet, 'UTF-8');

    final reader = QRCodeReader();
    final sources = <LuminanceSource>[source, source.invert()];

    for (final src in sources) {
      final binarizers = <Binarizer>[
        HybridBinarizer(src),
        GlobalHistogramBinarizer(src),
      ];
      for (final binarizer in binarizers) {
        for (final h in [hints, pureHints]) {
          try {
            final bitmap = BinaryBitmap(binarizer);
            final result = reader.decode(bitmap, hints: h);
            if (result.text.isNotEmpty) {
              return result.text;
            }
          } catch (_) {
            // Continue to next binarizer / hint combination
          } finally {
            reader.reset();
          }
        }
      }
    }
    return null;
  }

  /// Builds an [RGBLuminanceSource] while alpha-compositing transparent pixels
  /// onto a white background so transparent PNG QR codes never become solid black.
  static RGBLuminanceSource _buildLuminanceSource(img.Image image) {
    final width = image.width;
    final height = image.height;
    final rgba = image.convert(numChannels: 4);
    final pixels = Int32List(width * height);

    var idx = 0;
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final p = rgba.getPixel(x, y);
        final a = p.a.toInt().clamp(0, 255);
        int r = p.r.toInt().clamp(0, 255);
        int g = p.g.toInt().clamp(0, 255);
        int b = p.b.toInt().clamp(0, 255);
        if (a < 255) {
          // Composite over white (255, 255, 255)
          r = ((r * a) + (255 * (255 - a))) ~/ 255;
          g = ((g * a) + (255 * (255 - a))) ~/ 255;
          b = ((b * a) + (255 * (255 - a))) ~/ 255;
        }
        pixels[idx++] = (0xFF << 24) | (r << 16) | (g << 8) | b;
      }
    }
    return RGBLuminanceSource(width, height, pixels);
  }
}
