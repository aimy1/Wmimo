class ProxyOption {
  final String host;
  final int port;
  final List<String> bypassDomains;
  ProxyOption(this.host, this.port, this.bypassDomains);
}

class ClashProxyManager {
  static Future<String?> getSystemProxy() async => null;
  static Future<String?> setSystemProxy(bool enable, String host, int port) async => null;
}

class ProxyManager {
  static Future<void> setSystemProxy(ProxyOption option) async {}
  void setExcludeDevices(dynamic d) {}
}
