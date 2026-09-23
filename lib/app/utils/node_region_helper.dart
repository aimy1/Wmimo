import 'package:wmimo/app/clash/clash_http_api.dart';

class NodeRegion {
  final String code;
  final String name;
  final String nameEn;
  final String flag;
  final List<String> keywords;
  final List<String> codes;

  const NodeRegion({
    required this.code,
    required this.name,
    required this.nameEn,
    required this.flag,
    required this.keywords,
    this.codes = const [],
  });

  static const NodeRegion all = NodeRegion(
    code: "ALL",
    name: "全部",
    nameEn: "All",
    flag: "🌍",
    keywords: [],
  );

  static const NodeRegion other = NodeRegion(
    code: "OTHER",
    name: "其他",
    nameEn: "Others",
    flag: "🌐",
    keywords: [],
  );
}

class LatencyTestTarget {
  final String id;
  final String name;
  final String nameEn;
  final String icon;
  final String url;

  const LatencyTestTarget({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.icon,
    required this.url,
  });

  static const List<LatencyTestTarget> presets = [
    LatencyTestTarget(
      id: "cloudflare",
      name: "默认测试 (Cloudflare)",
      nameEn: "Default (Cloudflare)",
      icon: "⚡",
      url: "https://cp.cloudflare.com/generate_204",
    ),
    LatencyTestTarget(
      id: "google",
      name: "YouTube / Google",
      nameEn: "YouTube / Google",
      icon: "🔴",
      url: "https://www.google.com/generate_204",
    ),
    LatencyTestTarget(
      id: "openai",
      name: "OpenAI / ChatGPT",
      nameEn: "OpenAI / ChatGPT",
      icon: "🤖",
      url: "https://chatgpt.com",
    ),
    LatencyTestTarget(
      id: "bilibili",
      name: "哔哩哔哩 (Bilibili)",
      nameEn: "Bilibili",
      icon: "📺",
      url: "https://www.bilibili.com",
    ),
    LatencyTestTarget(
      id: "netflix",
      name: "Netflix",
      nameEn: "Netflix",
      icon: "🎬",
      url: "https://www.netflix.com",
    ),
    LatencyTestTarget(
      id: "github",
      name: "GitHub",
      nameEn: "GitHub",
      icon: "🐙",
      url: "https://github.com",
    ),
  ];

  static LatencyTestTarget get defaultTarget => presets.first;
}

class NodeRegionHelper {
  static final List<NodeRegion> knownRegions = [
    // 1. 🇭🇰 香港 (Hong Kong)
    const NodeRegion(
      code: "HK",
      name: "香港",
      nameEn: "Hong Kong",
      flag: "🇭🇰",
      keywords: [
        "香港",
        "深港",
        "沪港",
        "广港",
        "中港",
        "HONG KONG",
        "HONGKONG",
      ],
      codes: ["HK", "HKG"],
    ),
    // 2. 🇯🇵 日本 (Japan)
    const NodeRegion(
      code: "JP",
      name: "日本",
      nameEn: "Japan",
      flag: "🇯🇵",
      keywords: [
        "日本",
        "东京",
        "大阪",
        "川崎",
        "名古屋",
        "福冈",
        "JAPAN",
        "TOKYO",
        "OSAKA",
      ],
      codes: ["JP", "JPN", "NRT", "HND", "KIX"],
    ),
    // 3. 🇸🇬 新加坡 (Singapore)
    const NodeRegion(
      code: "SG",
      name: "新加坡",
      nameEn: "Singapore",
      flag: "🇸🇬",
      keywords: [
        "新加坡",
        "狮城",
        "SINGAPORE",
        "CHANGI",
      ],
      codes: ["SG", "SGP", "SIN"],
    ),
    // 4. 🇺🇸 美国 (United States)
    const NodeRegion(
      code: "US",
      name: "美国",
      nameEn: "United States",
      flag: "🇺🇸",
      keywords: [
        "美国",
        "洛杉矶",
        "圣何塞",
        "硅谷",
        "旧金山",
        "西雅图",
        "纽约",
        "芝加哥",
        "达拉斯",
        "俄勒冈",
        "波特兰",
        "凤凰城",
        "拉斯维加斯",
        "迈阿密",
        "UNITED STATES",
        "AMERICA",
        "LOS ANGELES",
        "SAN JOSE",
        "SILICON VALLEY",
        "NEW YORK",
        "SEATTLE",
      ],
      codes: ["US", "USA", "SJC", "LAX", "JFK", "ORD"],
    ),
    // 5. 🇹🇼 台湾 (Taiwan)
    const NodeRegion(
      code: "TW",
      name: "台湾",
      nameEn: "Taiwan",
      flag: "🇹🇼",
      keywords: [
        "台湾",
        "台北",
        "台中",
        "新北",
        "高雄",
        "TAIWAN",
        "TAIPEI",
      ],
      codes: ["TW", "TWN", "TPE"],
    ),
    // 6. 🇰🇷 韩国 (Korea)
    const NodeRegion(
      code: "KR",
      name: "韩国",
      nameEn: "Korea",
      flag: "🇰🇷",
      keywords: [
        "韩国",
        "首尔",
        "仁川",
        "KOREA",
        "SEOUL",
      ],
      codes: ["KR", "KOR", "ICN"],
    ),
    // 7. 🇬🇧 英国 (United Kingdom)
    const NodeRegion(
      code: "UK",
      name: "英国",
      nameEn: "United Kingdom",
      flag: "🇬🇧",
      keywords: [
        "英国",
        "伦敦",
        "曼彻斯特",
        "UNITED KINGDOM",
        "BRITAIN",
        "LONDON",
      ],
      codes: ["UK", "GB", "GBR", "LHR"],
    ),
    // 8. 🇩🇪 德国 (Germany)
    const NodeRegion(
      code: "DE",
      name: "德国",
      nameEn: "Germany",
      flag: "🇩🇪",
      keywords: [
        "德国",
        "法兰克福",
        "柏林",
        "慕尼黑",
        "GERMANY",
        "FRANKFURT",
      ],
      codes: ["DE", "DEU", "FRA"],
    ),
    // 9. 🇫🇷 法国 (France)
    const NodeRegion(
      code: "FR",
      name: "法国",
      nameEn: "France",
      flag: "🇫🇷",
      keywords: [
        "法国",
        "巴黎",
        "马赛",
        "FRANCE",
        "PARIS",
      ],
      codes: ["FR", "FRA", "CDG"],
    ),
    // 10. 🇨🇦 加拿大 (Canada)
    const NodeRegion(
      code: "CA",
      name: "加拿大",
      nameEn: "Canada",
      flag: "🇨🇦",
      keywords: [
        "加拿大",
        "温哥华",
        "多伦多",
        "蒙特利尔",
        "CANADA",
        "VANCOUVER",
        "TORONTO",
      ],
      codes: ["CA", "CAN", "YVR", "YYZ"],
    ),
    // 11. 🇦🇺 澳大利亚 (Australia)
    const NodeRegion(
      code: "AU",
      name: "澳大利亚",
      nameEn: "Australia",
      flag: "🇦🇺",
      keywords: [
        "澳大利亚",
        "澳洲",
        "悉尼",
        "墨尔本",
        "布里斯班",
        "AUSTRALIA",
        "SYDNEY",
        "MELBOURNE",
      ],
      codes: ["AU", "AUS", "SYD"],
    ),
    // 12. 🇷🇺 俄罗斯 (Russia)
    const NodeRegion(
      code: "RU",
      name: "俄罗斯",
      nameEn: "Russia",
      flag: "🇷🇺",
      keywords: [
        "俄罗斯",
        "莫斯科",
        "圣彼得堡",
        "海参崴",
        "伯力",
        "RUSSIA",
        "MOSCOW",
      ],
      codes: ["RU", "RUS", "SVO"],
    ),
    // 13. 🇨🇳 中国大陆 (China)
    const NodeRegion(
      code: "CN",
      name: "中国大陆",
      nameEn: "China",
      flag: "🇨🇳",
      keywords: [
        "中国",
        "国内",
        "回国",
        "北京",
        "上海",
        "广州",
        "深圳",
        "杭州",
        "CHINA",
        "MAINLAND",
      ],
      codes: ["CN", "CHN"],
    ),
    // 14. 🇲🇾 马来西亚 (Malaysia)
    const NodeRegion(
      code: "MY",
      name: "马来西亚",
      nameEn: "Malaysia",
      flag: "🇲🇾",
      keywords: [
        "马来西亚",
        "大马",
        "吉隆坡",
        "MALAYSIA",
        "KUALA LUMPUR",
      ],
      codes: ["MY", "MYS", "KUL"],
    ),
    // 15. 🇹🇭 泰国 (Thailand)
    const NodeRegion(
      code: "TH",
      name: "泰国",
      nameEn: "Thailand",
      flag: "🇹🇭",
      keywords: [
        "泰国",
        "曼谷",
        "THAILAND",
        "BANGKOK",
      ],
      codes: ["TH", "THA", "BKK"],
    ),
    // 16. 🇻🇳 越南 (Vietnam)
    const NodeRegion(
      code: "VN",
      name: "越南",
      nameEn: "Vietnam",
      flag: "🇻🇳",
      keywords: [
        "越南",
        "胡志明",
        "河内",
        "VIETNAM",
        "HANOI",
      ],
      codes: ["VN", "VNM", "SGN"],
    ),
    // 17. 🇮🇳 印度 (India)
    const NodeRegion(
      code: "IN",
      name: "印度",
      nameEn: "India",
      flag: "🇮🇳",
      keywords: [
        "印度",
        "孟买",
        "德里",
        "INDIA",
        "MUMBAI",
        "DELHI",
      ],
      codes: ["IN", "IND", "BOM"],
    ),
    // 18. 🇵🇭 菲律宾 (Philippines)
    const NodeRegion(
      code: "PH",
      name: "菲律宾",
      nameEn: "Philippines",
      flag: "🇵🇭",
      keywords: [
        "菲律宾",
        "马尼拉",
        "PHILIPPINES",
        "MANILA",
      ],
      codes: ["PH", "PHL", "MNL"],
    ),
    // 19. 🇮🇩 印度尼西亚 (Indonesia)
    const NodeRegion(
      code: "ID",
      name: "印尼",
      nameEn: "Indonesia",
      flag: "🇮🇩",
      keywords: [
        "印尼",
        "印度尼西亚",
        "雅加达",
        "INDONESIA",
        "JAKARTA",
      ],
      codes: ["ID", "IDN", "CGK"],
    ),
    // 20. 🇳🇱 荷兰 (Netherlands)
    const NodeRegion(
      code: "NL",
      name: "荷兰",
      nameEn: "Netherlands",
      flag: "🇳🇱",
      keywords: [
        "荷兰",
        "阿姆斯特丹",
        "NETHERLANDS",
        "AMSTERDAM",
      ],
      codes: ["NL", "NLD", "AMS"],
    ),
    // 21. 🇨🇭 瑞士 (Switzerland)
    const NodeRegion(
      code: "CH",
      name: "瑞士",
      nameEn: "Switzerland",
      flag: "🇨🇭",
      keywords: [
        "瑞士",
        "苏黎世",
        "日内瓦",
        "SWITZERLAND",
        "ZURICH",
      ],
      codes: ["CH", "CHE", "ZRH"],
    ),
    // 22. 🇹🇷 土耳其 (Turkey)
    const NodeRegion(
      code: "TR",
      name: "土耳其",
      nameEn: "Turkey",
      flag: "🇹🇷",
      keywords: [
        "土耳其",
        "伊斯坦布尔",
        "TURKEY",
        "ISTANBUL",
      ],
      codes: ["TR", "TUR", "IST"],
    ),
    // 23. 🇦🇷 阿根廷 (Argentina)
    const NodeRegion(
      code: "AR",
      name: "阿根廷",
      nameEn: "Argentina",
      flag: "🇦🇷",
      keywords: [
        "阿根廷",
        "布宜诺斯艾利斯",
        "ARGENTINA",
      ],
      codes: ["AR", "ARG", "EZE"],
    ),
    // 24. 🇧🇷 巴西 (Brazil)
    const NodeRegion(
      code: "BR",
      name: "巴西",
      nameEn: "Brazil",
      flag: "🇧🇷",
      keywords: [
        "巴西",
        "圣保罗",
        "里约",
        "BRAZIL",
        "SAO PAULO",
      ],
      codes: ["BR", "BRA", "GRU"],
    ),
    // 25. 🇦🇪 阿联酋 (UAE)
    const NodeRegion(
      code: "AE",
      name: "阿联酋",
      nameEn: "UAE",
      flag: "🇦🇪",
      keywords: [
        "阿联酋",
        "迪拜",
        "阿布扎比",
        "DUBAI",
      ],
      codes: ["AE", "ARE", "UAE", "DXB"],
    ),
  ];

  static final Map<String, RegExp> _codeRegexCache = {};

  static RegExp _getCodeRegex(String code) {
    return _codeRegexCache.putIfAbsent(
      code,
      () => RegExp(r'(^|[^a-zA-Z0-9])' + RegExp.escape(code) + r'([^a-zA-Z0-9]|$)', caseSensitive: false),
    );
  }

  /// Get the matching NodeRegion for a given node name
  static NodeRegion getRegion(String nodeName) {
    if (nodeName.isEmpty) return NodeRegion.other;
    final upper = nodeName.toUpperCase();

    // Check special system names
    if (nodeName.contains("自动") || upper.contains("AUTO") || upper.contains("URL-TEST")) {
      return const NodeRegion(code: "AUTO", name: "自动选择", nameEn: "Auto", flag: "⚡", keywords: []);
    }
    if (nodeName.contains("故障") || upper.contains("FALLBACK")) {
      return const NodeRegion(code: "FALLBACK", name: "故障转移", nameEn: "Fallback", flag: "🛡️", keywords: []);
    }
    if (nodeName.contains("直连") || upper.contains("DIRECT")) {
      return const NodeRegion(code: "DIRECT", name: "直连", nameEn: "Direct", flag: "🎯", keywords: []);
    }
    if (nodeName.contains("拒绝") || upper.contains("REJECT")) {
      return const NodeRegion(code: "REJECT", name: "拒绝", nameEn: "Reject", flag: "🚫", keywords: []);
    }

    // Step 1: Match Chinese / long keywords (>= 4 chars or non-ascii)
    for (var region in knownRegions) {
      for (var kw in region.keywords) {
        if (kw.codeUnits.any((c) => c > 127)) {
          // Chinese / non-ascii keyword
          if (nodeName.contains(kw)) {
            return region;
          }
        } else if (kw.length >= 4) {
          // Long Latin keyword
          if (upper.contains(kw.toUpperCase())) {
            return region;
          }
        }
      }
    }

    // Step 2: Match 2-letter / 3-letter codes using strict word boundary
    for (var region in knownRegions) {
      for (var code in region.codes) {
        final regex = _getCodeRegex(code);
        if (regex.hasMatch(nodeName)) {
          return region;
        }
      }
    }

    return NodeRegion.other;
  }

  /// Get the country/region flag emoji for a node name
  static String getFlag(String nodeName) {
    return getRegion(nodeName).flag;
  }

  /// Extract all available regions with their respective node counts from a list of nodes
  static List<RegionNodeSummary> extractAvailableRegions(List<ClashProxiesNode> nodes) {
    final Map<String, int> regionCounts = {};
    final Map<String, NodeRegion> regionMap = {};

    int totalCount = 0;
    for (var node in nodes) {
      totalCount++;
      final region = getRegion(node.name);
      regionCounts[region.code] = (regionCounts[region.code] ?? 0) + 1;
      regionMap[region.code] = region;
    }

    final List<RegionNodeSummary> result = [
      RegionNodeSummary(region: NodeRegion.all, count: totalCount),
    ];

    // Add known regions in defined order
    for (var r in knownRegions) {
      if (regionCounts.containsKey(r.code) && regionCounts[r.code]! > 0) {
        result.add(RegionNodeSummary(region: r, count: regionCounts[r.code]!));
      }
    }

    // Add other region if any
    if (regionCounts.containsKey(NodeRegion.other.code) && regionCounts[NodeRegion.other.code]! > 0) {
      result.add(RegionNodeSummary(region: NodeRegion.other, count: regionCounts[NodeRegion.other.code]!));
    }

    return result;
  }
}

class RegionNodeSummary {
  final NodeRegion region;
  final int count;

  const RegionNodeSummary({
    required this.region,
    required this.count,
  });
}
