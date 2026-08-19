class Crypto {
  static String encrypt(dynamic p1, [dynamic p2]) {
    if (p2 != null) return p2.toString();
    return p1.toString();
  }
  static String decrypt(dynamic p1, [dynamic p2]) {
    if (p2 != null) return p2.toString();
    return p1.toString();
  }
}
