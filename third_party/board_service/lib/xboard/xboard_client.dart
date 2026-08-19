class LoginRequest {
  final String email;
  final String password;
  LoginRequest({required this.email, required this.password});
}

class BoardResponse<T> {
  final int statusCode;
  final String message;
  final T? data;
  BoardResponse({this.statusCode = 200, this.message = "", this.data});
  String getFullMessage() => message;
}

class SubscribeData {
  final String subscribeUrl;
  final int? planId;
  SubscribeData({this.subscribeUrl = "", this.planId});
}

class XBoardUserInfo {
  String email = "";
  int transferEnable = 0;
  int u = 0;
  int d = 0;
  int? expiredAt;
  int? planId;
}

class XBoardUserNotice {
  int id = 0;
  String title = "";
  String content = "";
}

class XboardClient {
  String? baseUrl = "";
  String? userAgent = "";
  String? proxyUrl = "";
  Duration timeout = const Duration(seconds: 10);

  XboardClient({
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

  Future<BoardResponse<String>> login(LoginRequest req) async =>
      BoardResponse(statusCode: 200, message: "OK");

  Future<void> logout() async {}

  Future<BoardResponse<SubscribeData>> getSubscribe() async =>
      BoardResponse(statusCode: 200, message: "OK", data: SubscribeData());

  Future<BoardResponse<XBoardUserInfo>> getUserInfo() async =>
      BoardResponse(statusCode: 200, message: "OK", data: XBoardUserInfo());

  Future<List<XBoardUserNotice>> getNotice() async => [];
}
