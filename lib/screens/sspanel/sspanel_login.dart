import 'package:wmimo/app/modules/board_provider_manager.dart';
import 'package:wmimo/app/modules/board_session_persistent_manager.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/profile_patch_manager.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/i18n/strings.g.dart';

class SSPanelLogin {
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
    if (session == null || session.ssPanel == null) {
      return BoardSessionLoginError(
        message: t.loginScreen.createSessionFailed,
      );
    }
    //session.ssPanel!.proxyUrl = "127.0.0.1:8888";
    Log.i('sspanel: login, provider: ${provider.name}, email: $email');
    session.ssPanel!.timeout = const Duration(seconds: 10);
    final loginResponse = await session.ssPanel!.login(email, password);
    Log.i(
      'sspanel: login response, provider: ${provider.name}, email: $email, statusCode: ${loginResponse.statusCode}',
    );
    if (loginResponse.statusCode != 200 || loginResponse.ret != true) {
      return BoardSessionLoginError(
        session: session,
        httpStatusCode: loginResponse.statusCode,
        message: loginResponse.getFullMessage(),
      );
    }
    String? err = await getSubscribe(provider, session);
    if (err != null) {
      await session.ssPanel?.logout();
      return BoardSessionLoginError(session: session, message: err);
    }

    onEventLogin.forEach((key, value) {
      value.call();
    });

    return null;
  }

  static Future<String?> getSubscribe(
    BoardProviderConfig provider,
    BoardSession session,
  ) async {
    if (session.ssPanel == null) {
      return null;
    }
    Log.i('sspanel: getSubscribe, provider: ${provider.name}');
    session.ssPanel!.timeout = const Duration(seconds: 30);
    final userProfileUrlResponse = await session.ssPanel!
        .getUserProfileUrlAndToken();
    Log.i(
      'sspanel: getSubscribe response, provider: ${provider.name}, statusCode: ${userProfileUrlResponse.statusCode}',
    );
    if (userProfileUrlResponse.statusCode != 200 ||
        userProfileUrlResponse.ret != true) {
      return userProfileUrlResponse.getFullMessage();
    }
    /*final userSubscribeResponse = await session.ssPanel!.getSubscribe(
      userProfileUrlResponse.data!.item2,
    );
    if (userSubscribeResponse.statusCode != 200 ||
        userSubscribeResponse.ret != true) {
      return userSubscribeResponse.getFullMessage();
    }*/
    Log.i('sspanel: add profile, provider: ${provider.name}');
    final patch = provider.overwrite
        ? kProfilePatchBuildinOverwrite
        : kProfilePatchBuildinNoOverwrite;

    final result = await ProfileManager.addRemote(
      userProfileUrlResponse.data!.item1,
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
    await session.ssPanel?.logout();
  }
}
