// ignore_for_file: empty_catches

import 'dart:io';

import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libclash_vpn_service/vpn_service.dart';
import 'package:tuple/tuple.dart';

//flutter showdialog setstate https://stackoverflow.com/questions/58977815/flutter-setstate-on-showdialog
class DialogUtilsResult<T> {
  DialogUtilsResult(this.data);
  T? data;
}

class DialogUtils {
  static Future<void> Function(BuildContext context, String text)? faqCallback;

  static Future<void> showAlertDialog(
    BuildContext context,
    String text, {
    bool showCopy = false,
    bool showFAQ = false,
    bool withVersion = false,
  }) async {
    if (!context.mounted) {
      return;
    }
    double width = 60;
    if (showCopy) {
      width = 20;
    }
    if (withVersion) {
      text =
          "${AppUtils.getBuildinVersion()} ${Platform.operatingSystem}\n\n$text";
    }

    const int kMaxLength = 1024;
    if (text.length > kMaxLength) {
      text = text.substring(
        0,
        kMaxLength,
      ); //android https://www.cnblogs.com/yyhimmy/p/12583251.html
    }

    if (showFAQ && Platform.isAndroid) {
      String version = await FlutterVpnService.getSystemVersion();
      int? v = int.tryParse(version);
      if (v != null && v == 27) {
        //android 8.1 flutter_inappwebview_android exception:AbstractMethodError: abstract method "void android.webkit.WebSettings.setSafeBrowsingEnabled(boolean)"
        showFAQ = false;
      }
      if (!context.mounted) {
        return;
      }
    }

    final tcontext = Translations.of(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: "showAlertDialog"),
      builder: (context) {
        return SimpleDialog(
          title: Text(
            tcontext.meta.tips,
            style: const TextStyle(fontSize: ThemeConfig.kFontSizeListSubItem),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: ThemeConfig.kFontSizeListSubItem,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text(tcontext.meta.ok),
                  onPressed: () {
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pop(context);
                  },
                ),
                if (showCopy) ...[
                  SizedBox(width: width),
                  ElevatedButton(
                    child: Text(tcontext.meta.copy),
                    onPressed: () async {
                      try {
                        await Clipboard.setData(ClipboardData(text: text));
                      } catch (e) {}
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            if (showFAQ) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ElevatedButton(
                  child: Text(tcontext.meta.faq),
                  onPressed: () async {
                    await faqCallback?.call(context, text);
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  static Future<bool?> showConfirmDialog(
    BuildContext context,
    String text, {
    bool showCopy = false,
    bool withVersion = false,
  }) async {
    if (!context.mounted) {
      return null;
    }
    if (withVersion) {
      text =
          "${AppUtils.getBuildinVersion()} ${Platform.operatingSystem}\n\n$text";
    }
    final tcontext = Translations.of(context);
    return await showDialog<bool>(
      context: context,
      routeSettings: const RouteSettings(name: "showConfirmDialog"),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                text,
                maxLines: 20,
                style: const TextStyle(
                  fontSize: ThemeConfig.kFontSizeListSubItem,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text(tcontext.meta.cancel),
                  onPressed: () {
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pop(context, false);
                  },
                ),
                const SizedBox(width: 60),
                ElevatedButton(
                  child: Text(tcontext.meta.ok),
                  onPressed: () {
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (showCopy) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ElevatedButton(
                  child: Text(tcontext.meta.copy),
                  onPressed: () async {
                    try {
                      await Clipboard.setData(ClipboardData(text: text));
                    } catch (e) {}
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  static Future<String?> showPasswordInputDialog(BuildContext context) async {
    final tcontext = Translations.of(context);
    String? password = await DialogUtils.showTextInputDialog(
      context,
      tcontext.meta.sudoPassword,
      "",
      null,
      null,
      null,
      (text) {
        return text.isNotEmpty;
      },
      obscureText: true,
    );
    return password;
  }

  static Future<String?> showTextInputDialog(
    BuildContext context,
    String title,
    String text,
    String? labelText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool Function(String) callback, {
    bool obscureText = false,
  }) async {
    if (!context.mounted) {
      return null;
    }
    final tcontext = Translations.of(context);
    final textController = TextEditingController();
    textController.value = textController.value.copyWith(text: text);
    return showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: "showTextInputDialog"),
      builder: (context) {
        return SimpleDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: ThemeConfig.kFontSizeListSubItem),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: textController,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: labelText),
                textAlign: TextAlign.end,
                obscureText: obscureText,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text(tcontext.meta.cancel),
                  onPressed: () {
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pop(context, null);
                  },
                ),
                const SizedBox(width: 60),
                ElevatedButton(
                  child: Text(tcontext.meta.ok),
                  onPressed: () {
                    if (!context.mounted) {
                      return;
                    }
                    if (callback(textController.text)) {
                      Navigator.pop(context, textController.text);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static Future<Tuple2<int, int>?> showTextIntRangeInputDialog(
    BuildContext context,
    String title,
    Tuple2<int, int>? labelText,
    bool Function(Tuple2<int, int>) callback,
  ) async {
    if (!context.mounted) {
      return null;
    }
    final tcontext = Translations.of(context);
    final textControllerL = TextEditingController();
    final textControllerR = TextEditingController();
    textControllerL.value = textControllerL.value.copyWith(
      text: labelText != null ? labelText.item1.toString() : "",
    );
    textControllerR.value = textControllerR.value.copyWith(
      text: labelText != null ? labelText.item2.toString() : "",
    );
    return showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: "showTextIntRangeInputDialog"),
      builder: (context) {
        return SimpleDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: ThemeConfig.kFontSizeListSubItem),
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: textControllerL,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                const Text(
                  "-",
                  style: TextStyle(fontSize: ThemeConfig.kFontSizeListSubItem),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: textControllerR,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text(tcontext.meta.cancel),
                  onPressed: () {
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pop(context, null);
                  },
                ),
                const SizedBox(width: 60),
                ElevatedButton(
                  child: Text(tcontext.meta.ok),
                  onPressed: () {
                    if (!context.mounted) {
                      return;
                    }
                    if (textControllerL.text.isNotEmpty &&
                        textControllerR.text.isNotEmpty &&
                        callback(
                          Tuple2(
                            int.parse(textControllerL.text),
                            int.parse(textControllerR.text),
                          ),
                        )) {
                      Navigator.pop(
                        context,
                        Tuple2(
                          int.parse(textControllerL.text),
                          int.parse(textControllerR.text),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static Future<int?> showIntInputDialog(
    BuildContext context,
    String title,
    int? value,
    int? min,
    int? max,
  ) async {
    String mm = (min != null && max != null) ? "$min-$max" : "";
    String? text = await DialogUtils.showTextInputDialog(
      context,
      title,
      value != null ? value.toString() : "",
      mm,
      TextInputType.number,
      [FilteringTextInputFormatter.digitsOnly],
      (text) {
        text = text.trim();
        int? p = int.tryParse(text);
        if (p == null) {
          return false;
        }
        if (min != null) {
          if (p < min) {
            return false;
          }
        }
        if (max != null) {
          if (p > max) {
            return false;
          }
        }

        return true;
      },
    );
    if (text == null) {
      return null;
    }
    return int.tryParse(text);
  }

  static Future<Tuple2<int, int>?> showIntRangeInputDialog(
    BuildContext context,
    String title,
    Tuple2<int, int>? value,
    int min,
    int max,
  ) async {
    return await DialogUtils.showTextIntRangeInputDialog(
      context,
      title,
      value,
      (tuple2) {
        if (tuple2.item1 < min ||
            tuple2.item2 > max ||
            tuple2.item1 > tuple2.item2) {
          return false;
        }
        return true;
      },
    );
  }

  static Future<DialogUtilsResult<Duration>?> showTimeIntervalPickerDialog(
    BuildContext context,
    Duration? duration, {
    bool showDays = true,
    bool showHours = true,
    bool showMinutes = true,
    bool showSeconds = true,
    bool showMilliSeconds = false,
    bool showDisable = true,
  }) async {
    if (!context.mounted) {
      return null;
    }
    final tcontext = Translations.of(context);
    final textController = TextEditingController();
    String days = "d(${tcontext.meta.days})";
    String hours = "h(${tcontext.meta.hours})";
    String minutes = "m(${tcontext.meta.minutes})";
    String seconds = "s(${tcontext.meta.seconds})";
    String milliseconds = "ms(${tcontext.meta.milliseconds})";
    List<String> data = [];

    if (showDays) {
      data.add(days);
    }
    if (showHours) {
      data.add(hours);
    }
    if (showMinutes) {
      data.add(minutes);
    }
    if (showSeconds) {
      data.add(seconds);
    }
    if (showMilliSeconds) {
      data.add(milliseconds);
    }
    if (showDisable) {
      data.add(tcontext.meta.disable);
    }
    String selected = data.first;
    if (duration != null) {
      if (duration.inDays > 0) {
        selected = days;
        textController.value = textController.value.copyWith(
          text: duration.inDays.toString(),
        );
      } else if (duration.inHours > 0) {
        selected = hours;
        textController.value = textController.value.copyWith(
          text: duration.inHours.toString(),
        );
      } else if (duration.inMinutes > 0) {
        selected = minutes;
        textController.value = textController.value.copyWith(
          text: duration.inMinutes.toString(),
        );
      } else if (duration.inSeconds > 0) {
        selected = seconds;
        textController.value = textController.value.copyWith(
          text: duration.inSeconds.toString(),
        );
      } else if (duration.inMilliseconds > 0) {
        selected = milliseconds;
        textController.value = textController.value.copyWith(
          text: duration.inMilliseconds.toString(),
        );
      }
    } else {
      selected = tcontext.meta.disable;
      textController.value = textController.value.copyWith(text: "");
    }

    return showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: "showTimeIntervalPickerDialog"),
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "",
            style: TextStyle(fontSize: ThemeConfig.kFontSizeListSubItem),
          ),
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.done,
                        controller: textController,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButtonEx(
                      menuWidth: 200,
                      value: selected,
                      items: _buildDropButtonList(data),
                      onChanged: (String? sel) {
                        selected = sel ?? data.first;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text(tcontext.meta.cancel),
                      onPressed: () {
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.pop(context, null);
                      },
                    ),
                    const SizedBox(width: 60),
                    ElevatedButton(
                      child: Text(tcontext.meta.ok),
                      onPressed: () {
                        if (!context.mounted) {
                          return;
                        }
                        int? value = int.tryParse(textController.text);
                        if (value == null) {
                          Navigator.pop(context, null);
                          return;
                        }
                        Duration? duration;
                        if (selected == days) {
                          duration = Duration(days: value);
                        } else if (selected == hours) {
                          duration = Duration(hours: value);
                        } else if (selected == minutes) {
                          duration = Duration(minutes: value);
                        } else if (selected == seconds) {
                          duration = Duration(seconds: value);
                        } else if (selected == milliseconds) {
                          duration = Duration(milliseconds: value);
                        } else if (selected == tcontext.meta.disable) {}

                        Navigator.pop(context, DialogUtilsResult(duration));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static Future<DialogUtilsResult<String>?> showStringPickerDialog(
    BuildContext context,
    String title,
    List<String> strings,
    String? selected,
  ) async {
    if (!context.mounted) {
      return null;
    }
    final tcontext = Translations.of(context);
    final textController = TextEditingController();

    textController.value = textController.value.copyWith(text: selected ?? "");

    return showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: "showStringPickerDialog"),
      builder: (context) {
        return SimpleDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: ThemeConfig.kFontSizeListSubItem),
          ),
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonEx(
                      menuWidth: 200,
                      value: selected,
                      items: _buildDropButtonList(strings),
                      onChanged: (String? sel) {
                        selected = sel ?? strings.first;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text(tcontext.meta.cancel),
                      onPressed: () {
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.pop(context, null);
                      },
                    ),
                    const SizedBox(width: 60),
                    ElevatedButton(
                      child: Text(tcontext.meta.ok),
                      onPressed: () {
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.pop(context, DialogUtilsResult(selected));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static List<DropdownMenuItem<String>> _buildDropButtonList(
    List<String> data,
  ) {
    return data.map((String value) {
      return DropdownMenuItem<String>(value: value, child: Text(value));
    }).toList();
  }

  static Future<void> showLoadingDialog(
    BuildContext context, {
    String? text,
  }) async {
    if (!context.mounted) {
      return;
    }
    final tcontext = Translations.of(context);
    return showDialog(
      context: context,
      routeSettings: const RouteSettings(name: "showLoadingDialog"),
      barrierDismissible: false,
      fullscreenDialog: true,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: SimpleDialog(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const RepaintBoundary(child: CircularProgressIndicator()),
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    child: Text(text ?? tcontext.meta.loading),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showQRContentDialog(
    BuildContext context,
    String text,
  ) async {
    if (!context.mounted) {
      return;
    }
    final tcontext = Translations.of(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: "showQRContentDialog"),
      builder: (context) {
        return SimpleDialog(
          title: Text(
            tcontext.meta.qrcodeScanResult,
            style: const TextStyle(fontSize: ThemeConfig.kFontSizeListSubItem),
          ),
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: ThemeConfig.kFontSizeListSubItem,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: Text(tcontext.meta.add),
                  onPressed: () {
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static Future<void> showDonateDialog(BuildContext context) async {
    const String walletAddress =
        "0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345";
    const String networkName = "APTOS";
    const String currency = "USDT (Tether USD)";

    await showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final cardBg = isDark ? const Color(0xFF131B2E) : Colors.white;
        final subCardBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
        const usdtColor = Color(0xFF26A17B);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            width: 370,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.blueGrey)
                      .withValues(alpha: 0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Header Row with Close Icon
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 14, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: usdtColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: usdtColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "支持与捐赠",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Wmimo 纯粹开源 · 感谢您的同行与支持",
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.55),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(context),
                        splashRadius: 18,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, thickness: 0.6),

                // Content Scroll Body
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Currency & Network Badges
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: usdtColor.withValues(alpha: isDark ? 0.2 : 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: usdtColor.withValues(alpha: 0.3),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.monetization_on_rounded,
                                    size: 13,
                                    color: usdtColor,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    currency,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: usdtColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ThemeDefine.kColorBlue.withValues(
                                  alpha: isDark ? 0.2 : 0.1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: ThemeDefine.kColorBlue.withValues(alpha: 0.3),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.hub_rounded,
                                    size: 13,
                                    color: ThemeDefine.kColorBlue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    networkName,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: ThemeDefine.kColorBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // QR Code Showcase
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: usdtColor.withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: usdtColor.withValues(alpha: 0.12),
                                blurRadius: 18,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/images/donate_qr.png",
                              width: 175,
                              height: 175,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "📱 扫一扫 · 支持 Aptos 兼容钱包及交易所扫码",
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Wallet Address Card (Interactive)
                        Material(
                          color: subCardBg,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              Clipboard.setData(
                                const ClipboardData(text: walletAddress),
                              );
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("钱包地址已复制到剪贴板"),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: theme.dividerColor.withValues(alpha: 0.35),
                                  width: 0.8,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "收款地址 (Deposit Address)",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: usdtColor.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.copy_rounded,
                                              size: 11,
                                              color: usdtColor,
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                              "点击复制",
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w600,
                                                color: usdtColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SelectableText(
                                    walletAddress,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontFamily: "monospace",
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Main Copy CTA Button
                        SizedBox(
                          width: double.infinity,
                          height: 42,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: usdtColor,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shadowColor: usdtColor.withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Clipboard.setData(
                                const ClipboardData(text: walletAddress),
                              );
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("钱包地址已复制到剪贴板"),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy_rounded, size: 16),
                            label: const Text(
                              "一键复制钱包地址",
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Tip/Notice
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 13,
                              color: Colors.amber.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "转账时请务必确认选择 APTOS 网络",
                              style: TextStyle(
                                fontSize: 10.5,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.55),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
