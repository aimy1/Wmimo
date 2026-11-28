import 'dart:convert';
import 'dart:typed_data';

class Crypto {
  static const String _kPrefix = "WMIMO_ENC_V1:";
  static const String _kDefaultSalt = "wmimo_board_session_key_v1";

  static List<int> _deriveKeyBytes(String keyStr) {
    final effective = keyStr.isNotEmpty ? "$keyStr:$_kDefaultSalt" : _kDefaultSalt;
    final raw = utf8.encode(effective);
    final key = Uint8List(32);
    int acc = 0x5A827999;
    for (int i = 0; i < 32; i++) {
      final b = raw[i % raw.length];
      acc = ((acc ^ b) * 0x01000193) & 0xFFFFFFFF;
      key[i] = (acc ^ (acc >> 8) ^ (i * 31)) & 0xFF;
    }
    return key;
  }

  static String encrypt(dynamic p1, [dynamic p2]) {
    final String plaintext = (p2 != null ? p2 : p1)?.toString() ?? "";
    if (plaintext.isEmpty) return "";
    if (plaintext.startsWith(_kPrefix)) return plaintext;
    final String keyStr = (p2 != null ? p1 : _kDefaultSalt)?.toString() ?? _kDefaultSalt;
    final key = _deriveKeyBytes(keyStr);
    final input = utf8.encode(plaintext);
    final out = Uint8List(input.length);
    for (int i = 0; i < input.length; i++) {
      final k = key[i % key.length] ^ ((i * 17 + 0x3D) & 0xFF);
      out[i] = (input[i] ^ k) & 0xFF;
    }
    return "$_kPrefix${base64Url.encode(out)}";
  }

  static String decrypt(dynamic p1, [dynamic p2]) {
    final String ciphertext = (p2 != null ? p2 : p1)?.toString() ?? "";
    if (ciphertext.isEmpty) return "";
    if (!ciphertext.startsWith(_kPrefix)) {
      // Backward compatibility for legacy unencrypted session strings
      return ciphertext;
    }
    try {
      final encoded = ciphertext.substring(_kPrefix.length);
      final String keyStr = (p2 != null ? p1 : _kDefaultSalt)?.toString() ?? _kDefaultSalt;
      final key = _deriveKeyBytes(keyStr);
      final input = base64Url.decode(encoded);
      final out = Uint8List(input.length);
      for (int i = 0; i < input.length; i++) {
        final k = key[i % key.length] ^ ((i * 17 + 0x3D) & 0xFF);
        out[i] = (input[i] ^ k) & 0xFF;
      }
      return utf8.decode(out);
    } catch (_) {
      return ciphertext;
    }
  }
}
