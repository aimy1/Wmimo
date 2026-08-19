abstract class BoardSessionPersistent {
  void updateLoginAuthData(String id, String account, String authData);
  void logout(String id, String account);
  void update(String id, String account, String api, dynamic data);
  void updateSubscribeUrl(String id, String account, String subscribeUrl);
  dynamic get(String id, String account, String api);
}
