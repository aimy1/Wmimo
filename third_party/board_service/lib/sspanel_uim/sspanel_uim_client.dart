import 'package:tuple/tuple.dart';

class SSPanelResponse<T> {
  final int statusCode;
  final String message;
  final bool ret;
  final T? data;
  SSPanelResponse({
    this.statusCode = 200,
    this.message = "",
    this.ret = true,
    this.data,
  });
  String getFullMessage() => message;
}

class SspanelUimUserInfo {
  String email = "";
  int transferEnable = 0;
  int u = 0;
  int d = 0;
  int? expiredAt;
  int? planId;
}

class SspanelUimUserNotice {
  int id = 0;
  String title = "";
  String content = "";
}

class SspanelUimClient {
  String? baseUrl = "";
  String? userAgent = "";
  String? proxyUrl = "";
  Duration timeout = const Duration(seconds: 10);

  SspanelUimClient({
    this.baseUrl = "",
    List<String>? baseDomains,
    String? id,
    dynamic persistent,
  });

  static bool validateEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return email.contains("@");
  }

  static int getPasswordMinLen() => 6;

  void setAccount(String email, [String? password]) {}
  void setAuthToken(String token) {}
  void setHeadersAndCookiesForBot(dynamic h, dynamic c) {}

  Map<String, String>? getAuthHeaders() => null;
  Map<String, String>? getAuthCookies() => null;
  Map<String, String>? getAuthLocalStorage() => null;

  Future<SSPanelResponse<String>> login(String email, String password) async =>
      SSPanelResponse(statusCode: 200, ret: true, message: "OK");

  Future<void> logout() async {}

  Future<SSPanelResponse<Tuple2<String, String>>> getUserProfileUrlAndToken() async =>
      SSPanelResponse(
        statusCode: 200,
        ret: true,
        message: "OK",
        data: const Tuple2<String, String>("", ""),
      );

  Future<SSPanelResponse<SspanelUimUserInfo>> getUserInfo() async =>
      SSPanelResponse(
        statusCode: 200,
        ret: true,
        message: "OK",
        data: SspanelUimUserInfo(),
      );

  Future<List<SspanelUimUserNotice>> getNotice() async => [];
}

typedef SSPanelUimClient = SspanelUimClient;
