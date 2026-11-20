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

  static String privacyPolicyPath([dynamic localeOrIsChinese]) {
    if (localeOrIsChinese is bool) {
      return localeOrIsChinese
          ? 'assets/txts/privacy_policy_cn.txt'
          : 'assets/txts/privacy_policy_en.txt';
    }
    final AppLocale locale = (localeOrIsChinese is AppLocale)
        ? localeOrIsChinese
        : LocaleSettings.currentLocale;
    switch (locale) {
      case AppLocale.zhCn:
        return 'assets/txts/privacy_policy_cn.txt';
      case AppLocale.zhTw:
        return 'assets/txts/privacy_policy_zh_tw.txt';
      case AppLocale.ja:
        return 'assets/txts/privacy_policy_ja.txt';
      case AppLocale.ko:
        return 'assets/txts/privacy_policy_ko.txt';
      case AppLocale.ru:
        return 'assets/txts/privacy_policy_ru.txt';
      case AppLocale.es:
        return 'assets/txts/privacy_policy_es.txt';
      case AppLocale.ar:
        return 'assets/txts/privacy_policy_ar.txt';
      case AppLocale.fa:
        return 'assets/txts/privacy_policy_fa.txt';
      case AppLocale.en:
        return 'assets/txts/privacy_policy_en.txt';
    }
  }

  static Future<String> _loadWithFallback(
    String primaryPath,
    String fallbackPath,
    String label,
  ) async {
    try {
      return await rootBundle.loadString(primaryPath, cache: false);
    } catch (_) {
      try {
        return await rootBundle.loadString(fallbackPath, cache: false);
      } catch (err) {
        return "Failed to load $label: $err";
      }
    }
  }

  static Future<String> loadUserAgreement([dynamic localeOrIsChinese]) {
    return _loadWithFallback(
      userAgreementPath(localeOrIsChinese),
      'assets/txts/user_agreement_en.txt',
      'agreement',
    );
  }

  static Future<String> loadPrivacyPolicy([dynamic localeOrIsChinese]) {
    return _loadWithFallback(
      privacyPolicyPath(localeOrIsChinese),
      'assets/txts/privacy_policy_en.txt',
      'privacy policy',
    );
  }
}
