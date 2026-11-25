import 'package:wmimo/app/runtime/return_result.dart';
import 'package:wmimo/app/utils/app_scheme_actions.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/app/utils/system_scheme_utils.dart';
import 'package:wmimo/app/utils/url_launcher_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/add_profile_by_url_screen.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/app/utils/vpn_action_handler.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class SchemeHandler {
  static Future<ReturnResultError?> handle(
    BuildContext context,
    String url,
  ) async {
    //clash://install-config?url=https://xxxxx.com/clash/config
    //clash://connect?background=true
    //clash://disconnect
    //clash://reconnect
    Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      return ReturnResultError("parse url failed: $url");
    }
    if (uri.isScheme(SystemSchemeUtils.getWmimoScheme()) ||
        uri.isScheme(SystemSchemeUtils.getClashScheme())) {
      if (PlatformUtils.isPC()) {
        await windowManager.show();
      }
      if (uri.host == AppSchemeActions.installConfigAction()) {
        return await _installConfig(context, uri);
      } else if (uri.host == AppSchemeActions.connectAction()) {
        if (!context.mounted) return null;
        final tcontext = Translations.of(context);
        bool? ok = await DialogUtils.showConfirmDialog(
          context,
          tcontext.meta.schemeConnectConfirm,
        );
        if (ok != true) return null;
        if (VpnActionHandler.vpnConnect != null) {
          VpnActionHandler.vpnConnect!.call("scheme", false);
        }
        return null;
      } else if (uri.host == AppSchemeActions.disconnectAction()) {
        if (!context.mounted) return null;
        final tcontext = Translations.of(context);
        bool? ok = await DialogUtils.showConfirmDialog(
          context,
          tcontext.meta.schemeDisconnectConfirm,
        );
        if (ok != true) return null;
        if (VpnActionHandler.vpnDisconnect != null) {
          VpnActionHandler.vpnDisconnect!.call("scheme", false);
        }
        return null;
      } else if (uri.host == AppSchemeActions.reconnectAction()) {
        if (!context.mounted) return null;
        final tcontext = Translations.of(context);
        bool? ok = await DialogUtils.showConfirmDialog(
          context,
          tcontext.meta.schemeReconnectConfirm,
        );
        if (ok != true) return null;
        if (VpnActionHandler.vpnReconnect != null) {
          VpnActionHandler.vpnReconnect!.call("scheme", false);
        }
        return null;
      }
    }

    return ReturnResultError("unsupport scheme: ${uri.scheme}");
  }

  static Future<ReturnResultError?> _installConfig(
    BuildContext context,
    Uri uri,
  ) async {
    if (PlatformUtils.isPC()) {
      await windowManager.show();
    }
    String? name;
    String? url;
    bool? overwrite;
    bool? xhwid;

    if (!context.mounted) {
      return null;
    }
    try {
      name = uri.queryParameters["name"];
      url = uri.queryParameters["url"];
      String? ow = uri.queryParameters["overwrite"];
      if (ow != null) {
        if (ow == "true" || ow == "1" || ow == "yes") {
          overwrite = true;
        } else if (ow == "false" || ow == "0" || ow == "no") {
          overwrite = false;
        }
      }
      String? xh = uri.queryParameters["xhwid"] ?? uri.queryParameters["hwid"];
      if (xh != null) {
        if (xh == "true" || xh == "1" || xh == "yes") {
          xhwid = true;
        } else if (xh == "false" || xh == "0" || xh == "no") {
          xhwid = false;
        }
      }
    } catch (err) {
      DialogUtils.showAlertDialog(
        context,
        err.toString(),
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
      return ReturnResultError(err.toString());
    }
    name ??= uri.fragment;
    if (name.isNotEmpty) {
      try {
        name = Uri.decodeComponent(name);
      } catch (err) {}
    }
    if (url != null) {
      try {
        url = Uri.decodeComponent(url);
      } catch (err) {}
    }

    if (url == null || url.isEmpty) {
      return ReturnResultError("url empty");
    }

    if (!context.mounted) {
      return null;
    }
    ReturnResultError? result = await addConfigBySubscriptionLink(
      context,
      url,
      name ?? "",
      overwrite,
      xhwid,
    );

    return result;
  }

  static Future<ReturnResultError?> addConfigBySubscriptionLink(
    BuildContext context,
    String url,
    String name,
    bool? overwrite,
    bool? xhwid,
  ) async {
    int kMaxPush = 1;
    if (AddProfileByUrlScreen.pushed >= kMaxPush) {
      return ReturnResultError("addprofile request already exists");
    }
    UrlLauncherUtils.closeWebview();
    if (!context.mounted) {
      return null;
    }

    bool? ok = await Navigator.push(
      context,
      MaterialPageRoute(
        settings: AddProfileByUrlScreen.routSettings(),
        builder: (context) => AddProfileByUrlScreen(
          url: url,
          remark: name,
          overwrite: overwrite,
          xhwid: xhwid,
        ),
      ),
    );
    if (ok != true) {
      return ReturnResultError("addprofile failed or canceled by user");
    }
    return null;
  }
}
