import 'package:board_service/v2board/v2board_models.dart';
import 'package:wmimo/app/modules/board_provider_manager.dart';
import 'package:wmimo/app/modules/board_session_persistent_manager.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/profile_patch_manager.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/i18n/strings.g.dart';

class V2boardLogin {
  static final Map<int, Function()> onEventLogin = {};
  static final Map<int, Function()> onEventLogout = {};

  static Future<BoardSessionLoginError?> login(
    BoardProviderConfig provider,
    String email,
    String password,
  ) async {
    final session = await BoardSessionPersistentManager.instance().getOrCreate(
      provider,
      email,
    );
    if (session == null || session.v2board == null) {
      return BoardSessionLoginError(
        message: t.loginScreen.createSessionFailed,
      );
    }
    Log.i('v2board: login, provider: ${provider.name}, email: $email');
    //session.v2board!.proxyUrl = "127.0.0.1:8888";
    final loginRequest = LoginRequest(email: email, password: password);
    session.v2board!.timeout = const Duration(seconds: 10);
    final loginResponse = await session.v2board!.login(loginRequest);
    Log.i(
      'v2board: login response, provider: ${provider.name}, email: $email, statusCode: ${loginResponse.statusCode}',
    );
    if (loginResponse.statusCode != 200) {
      return BoardSessionLoginError(
        session: session,
        httpStatusCode: loginResponse.statusCode,
        message: loginResponse.getFullMessage(),
      );
    }
    String? err = await getSubscribe(provider, session);
    if (err != null) {
      await session.v2board?.logout();
      return BoardSessionLoginError(session: session, message: err);
    }

    onEventLogin.forEach((key, value) {
      value.call();
    });

    return null;
  }

  static Future<String?> getSubscribe(
    BoardProviderConfig provider,
    BoardSession session, {
    bool reloadProfile = true,
  }) async {
    /*final userInfoResponse = await session.v2board!.getUserInfo();
    if (userInfoResponse.statusCode != 200) {
      return userInfoResponse.getFullMessage();
    }
    if (userInfoResponse.data!.planId == null ||
        userInfoResponse.data!.planId == 0) {
      return null;
    }*/
    if (session.v2board == null) {
      return null;
    }
    Log.i('v2board: getSubscribe, provider: ${provider.name}');
    final subscribeResponse = await session.v2board!.getSubscribe();
    Log.i(
      'v2board: getSubscribe response, provider: ${provider.name}, statusCode: ${subscribeResponse.statusCode}',
    );
    if (subscribeResponse.statusCode != 200) {
      return subscribeResponse.getFullMessage();
    }
    if (reloadProfile) {
      final patch = provider.overwrite
          ? kProfilePatchBuildinOverwrite
          : kProfilePatchBuildinNoOverwrite;
      Log.i('v2board: add profile, provider: ${provider.name}');
      final result = await ProfileManager.addRemote(
        subscribeResponse.data!.subscribeUrl,
        remark: provider.name,
        patch: patch,
        userAgent: provider.userAgent,
        xhwid: provider.xhwid,
        updateInterval: const Duration(hours: 24),
        boardProviderId: provider.id,
      );
      if (result.error != null) {
        return result.error!.message;
      }
    }

    return null;
  }

  static Future<void> logout() async {
    final currentProfile = ProfileManager.getCurrent();
    final session = BoardSessionPersistentManager.instance().getBySubscribeUrl(
      currentProfile?.url ?? "",
    );
    if (session == null) {
      return;
    }
    onEventLogout.forEach((key, value) {
      value.call();
    });
    await session.v2board?.logout();
  }
}
