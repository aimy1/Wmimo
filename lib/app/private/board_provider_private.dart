import 'package:tuple/tuple.dart';

class BoardProviderPrivate {
  static Tuple3<String, String, dynamic> getNoticePushUrlAndBody({
    required String app,
    required String version,
    required String did,
    required String pid,
  }) => const Tuple3("", "", "");

  static Tuple3<String, String, dynamic> getBycodeUrlAndBody({
    required String app,
    required String version,
    required String did,
    required String code,
  }) => const Tuple3("", "", "");

  static Tuple3<String, String, dynamic> getNotifyIntegrationUrlAndBody({
    required String app,
    required String version,
    required String did,
    required String url,
    required String type,
  }) => const Tuple3("", "", "");
}
