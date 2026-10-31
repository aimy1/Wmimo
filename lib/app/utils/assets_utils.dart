import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wmimo/i18n/strings.g.dart';

abstract class AssetsUtils {
  static Future<bool> copyTo(String key, String savePath) async {
    final bytes = await rootBundle.load(key);
    final file = File(savePath);
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    return await file.exists();
  }

  static String userAgreementPath([dynamic localeOrIsChinese]) {
    if (localeOrIsChinese is bool) {
      return localeOrIsChinese
          ? 'assets/txts/user_agreement_cn.txt'
          : 'assets/txts/user_agreement_en.txt';
    }
    AppLocale locale = (localeOrIsChinese is AppLocale)
        ? localeOrIsChinese
        : LocaleSettings.currentLocale;
    switch (locale) {
      case AppLocale.zhCn:
        return 'assets/txts/user_agreement_cn.txt';
      case AppLocale.zhTw:
        return 'assets/txts/user_agreement_zh_tw.txt';
      case AppLocale.ja:
        return 'assets/txts/user_agreement_ja.txt';
      case AppLocale.ko:
        return 'assets/txts/user_agreement_ko.txt';
      case AppLocale.ru:
        return 'assets/txts/user_agreement_ru.txt';
      case AppLocale.es:
        return 'assets/txts/user_agreement_es.txt';
      case AppLocale.ar:
        return 'assets/txts/user_agreement_ar.txt';
      case AppLocale.fa:
        return 'assets/txts/user_agreement_fa.txt';
      case AppLocale.en:
        return 'assets/txts/user_agreement_en.txt';
    }
  }

  static String privacyPolicyPath() {
    return 'assets/txts/privacy_policy_en.txt';
  }

  static Future<String> loadUserAgreement([dynamic localeOrIsChinese]) async {
    final path = userAgreementPath(localeOrIsChinese);
    try {
      return await rootBundle.loadString(path, cache: false);
    } catch (_) {
      try {
        return await rootBundle.loadString(
          'assets/txts/user_agreement_en.txt',
          cache: false,
        );
      } catch (err) {
        return "Failed to load agreement: $err";
      }
    }
  }
}
