import 'dart:convert';

import 'package:wmimo/app/modules/board_provider_manager.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/profile_patch_manager.dart';
import 'package:flutter/material.dart';

class WebviewISPHelper {
  static Map<String, Function> getJavaScriptHandlers() {
    Map<String, Function(BuildContext, String, dynamic, dynamic)> handler = {};
    handler["ispInstallConfig"] = ispInstallConfig;
    handler["ispInfo"] = ispInfo;
    return handler;
  }

  /*
  window.wmimo.callHandler('ispInstallConfig',  '34345345', 'ispUser', 'https://xxxxxx.yaml', 'ispName').then(function(result) {
        console.log(result);
        return result;
    }).catch(function() {
        var event = new Event('error');
        self.dispatchEvent(event);
        if (self.onerror != null) {
          self.onerror(event);
        }
  });
   window.wmimo.callHandler('ispInfo').then(function(result) {
        console.log(result);
        return result;
    }).catch(function() {
        var event = new Event('error');
        self.dispatchEvent(event);
        if (self.onerror != null) {
          self.onerror(event);
        }
  });
  */

  static Future<String> ispInstallConfig(
    BuildContext context,
    String url,
    dynamic javaScriptHandlerArguments,
    dynamic arguments,
  ) async {
    String result = "";

    do {
      if (arguments.length != 4) {
        result = "arguments length != 4";
        break;
      }
      BoardProviderConfig provider =
          javaScriptHandlerArguments as BoardProviderConfig;
      try {
        String urlOrContent = arguments[2] as String;
        final patch = provider.overwrite
            ? kProfilePatchBuildinOverwrite
            : kProfilePatchBuildinNoOverwrite;
        final result1 = await ProfileManager.addRemote(
          urlOrContent,
          remark: provider.name,
          patch: patch,
          userAgent: provider.userAgent,
          xhwid: provider.xhwid,
          updateInterval: const Duration(hours: 24),
          boardProviderId: provider.id,
        );
        if (result1.error != null) {
          result = result1.error!.message;
          break;
        }
      } catch (err) {
        result = err.toString();
      }
    } while (false);

    return result;
  }

  static Future<String> ispInfo(
    BuildContext context,
    String url,
    dynamic javaScriptHandlerArguments,
    dynamic arguments,
  ) async {
    BoardProviderConfig provider =
        javaScriptHandlerArguments as BoardProviderConfig;
    String result = JsonEncoder().convert(provider);
    return result;
  }
}
