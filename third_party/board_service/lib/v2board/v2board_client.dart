import '../xboard/xboard_client.dart';
export '../xboard/xboard_client.dart' show LoginRequest, BoardResponse, SubscribeData;

class V2boardUserInfo {
  String email = "";
  int transferEnable = 0;
  int u = 0;
  int d = 0;
  int? expiredAt;
  int? planId;
}

class V2boardUserNotice {
  int id = 0;
  String title = "";
  String content = "";
}

class V2boardClient {
  String? baseUrl = "";
  String? userAgent = "";
  String? proxyUrl = "";
  Duration timeout = const Duration(seconds: 10);

  V2boardClient({
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

  void setVersion(dynamic version) {}
  void setAccount(String email, [String? password]) {}
  void setAuthToken(String token) {}
  void setHeadersAndCookiesForBot(dynamic h, dynamic c) {}

  Map<String, String>? getAuthHeaders() => null;
  Map<String, String>? getAuthCookies() => null;
  Map<String, String>? getAuthLocalStorage() => null;

  Future<BoardResponse<String>> login(LoginRequest req) async =>
      BoardResponse(statusCode: 200, message: "OK");

  Future<void> logout() async {}

  Future<BoardResponse<SubscribeData>> getSubscribe() async =>
      BoardResponse(statusCode: 200, message: "OK", data: SubscribeData());

  Future<BoardResponse<V2boardUserInfo>> getUserInfo() async =>
      BoardResponse(statusCode: 200, message: "OK", data: V2boardUserInfo());

  Future<List<V2boardUserNotice>> getNotice() async => [];
}

typedef V2BoardClient = V2boardClient;
