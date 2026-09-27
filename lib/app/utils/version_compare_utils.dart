class VersionCompareUtils {
  static int compareVersion(String ver1, String ver2) {
    String v1Clean = ver1.trim();
    String v2Clean = ver2.trim();

    if (v1Clean.startsWith('v') || v1Clean.startsWith('V')) {
      v1Clean = v1Clean.substring(1);
    }
    if (v2Clean.startsWith('v') || v2Clean.startsWith('V')) {
      v2Clean = v2Clean.substring(1);
    }

    String v1Base = v1Clean.split('+')[0];
    String v2Base = v2Clean.split('+')[0];

    List<String> v1 = v1Base.split(".");
    List<String> v2 = v2Base.split(".");
    int maxLength = v1.length > v2.length ? v1.length : v2.length;

    for (int i = 0; i < maxLength; ++i) {
      int n1 = i < v1.length ? (int.tryParse(v1[i]) ?? 0) : 0;
      int n2 = i < v2.length ? (int.tryParse(v2[i]) ?? 0) : 0;
      if (n1 < n2) {
        return -1;
      }
      if (n1 > n2) {
        return 1;
      }
    }

    // Compare build numbers if present (e.g. 1.1.6+1429 vs 1.1.6+1430)
    int b1 = 0;
    int b2 = 0;
    if (v1Clean.contains('+')) {
      b1 = int.tryParse(v1Clean.split('+')[1]) ?? 0;
    }
    if (v2Clean.contains('+')) {
      b2 = int.tryParse(v2Clean.split('+')[1]) ?? 0;
    }
    if (b1 < b2) {
      return -1;
    }
    if (b1 > b2) {
      return 1;
    }

    return 0;
  }
}
