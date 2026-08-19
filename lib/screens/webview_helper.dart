import 'package:flutter/material.dart';
import 'package:wmimo/app/runtime/return_result.dart';
import 'package:wmimo/app/utils/url_launcher_utils.dart';

class WebviewHelper {
  static Future<bool> loadUrl(
    BuildContext context,
    String url,
    String viewTag, {
    String? title,
    bool useInappWebViewForPC = false,
    bool inappWebViewOpenExternal = false,
    bool refreshWhenLoaded = false,
    Map<String, String>? headers,
    Map<String, String>? cookies,
    Map<String, String>? localStorage,
  }) async {
    ReturnResultError? error = await UrlLauncherUtils.loadUrl(url);
    return error != null;
  }
}
