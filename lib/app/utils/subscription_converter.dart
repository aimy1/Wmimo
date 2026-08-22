import 'dart:convert';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

class SubscriptionConverter {
  /// Safely decode Base64 string with automatic padding and URL-safe handling
  static String? safeBase64Decode(String input) {
    var sanitized = input.trim().replaceAll('\r', '').replaceAll('\n', '').replaceAll(' ', '');
    if (sanitized.isEmpty) return null;
    
    // Replace URL-safe characters
    sanitized = sanitized.replaceAll('-', '+').replaceAll('_', '/');
    
    // Add missing padding
    final remainder = sanitized.length % 4;
    if (remainder > 0) {
      sanitized += '=' * (4 - remainder);
    }

    try {
      final bytes = base64.decode(sanitized);
      return utf8.decode(bytes, allowMalformed: true);
    } catch (_) {
      try {
        final bytes = base64Decode(sanitized);
        return latin1.decode(bytes);
      } catch (_) {
        return null;
      }
    }
  }

  /// Check if the content is a standard Clash YAML containing 'proxies' or 'proxy-providers'
  static bool isClashYaml(String content) {
    final trimmed = content.trim();
    if (trimmed.startsWith('<!DOCTYPE') || trimmed.startsWith('<html')) return false;
    
    try {
      final parsed = loadYaml(content);
      if (parsed is Map) {
        if (parsed['proxies'] is List && (parsed['proxies'] as List).isNotEmpty) {
          return true;
        }
        if (parsed['proxy-providers'] is Map && (parsed['proxy-providers'] as Map).isNotEmpty) {
          return true;
        }
      }
    } catch (_) {}

    return trimmed.contains('proxies:') || trimmed.contains('proxy-providers:');
  }

  /// Parse a single node URI into a Clash proxy Map
  static Map<String, dynamic>? parseNodeUri(String rawLine) {
    var line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) return null;

    try {
      if (line.startsWith('vmess://')) {
        return _parseVmess(line);
      } else if (line.startsWith('vless://')) {
        return _parseVless(line);
      } else if (line.startsWith('ss://')) {
        return _parseShadowsocks(line);
      } else if (line.startsWith('trojan://')) {
        return _parseTrojan(line);
      } else if (line.startsWith('hysteria2://') || line.startsWith('hy2://')) {
        return _parseHysteria2(line);
      } else if (line.startsWith('hysteria://')) {
        return _parseHysteria(line);
      } else if (line.startsWith('tuic://')) {
        return _parseTuic(line);
      }
    } catch (_) {}

    return null;
  }

  /// Parse all node URIs from raw text or decoded Base64 lines
  static List<Map<String, dynamic>> parseAllNodes(String text) {
    final List<Map<String, dynamic>> proxies = [];
    final lines = text.split('\n');

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      final node = parseNodeUri(trimmed);
      if (node != null && node['name'] != null && node['server'] != null) {
        // Ensure unique proxy names
        var name = node['name'].toString();
        int count = 1;
        while (proxies.any((p) => p['name'] == name)) {
          name = "${node['name']} ($count)";
          count++;
        }
        node['name'] = name;
        proxies.add(node);
      }
    }

    return proxies;
  }

  /// Convert any subscription format (Base64, raw URIs, or Clash YAML) into a valid Clash YAML
  static String convertToClashYaml(String rawContent) {
    var content = rawContent.trim();
    if (content.isEmpty) return content;

    // 1. If it is already valid Clash YAML with proxies, return as is
    if (isClashYaml(content)) {
      return content;
    }

    // 2. Try parsing directly as multi-line node URIs
    var nodes = parseAllNodes(content);

    // 3. If direct parsing found no nodes, attempt Base64 decode
    if (nodes.isEmpty) {
      final decoded = safeBase64Decode(content);
      if (decoded != null && decoded.isNotEmpty) {
        if (isClashYaml(decoded)) {
          return decoded;
        }
        nodes = parseAllNodes(decoded);
      }
    }

    // If still no nodes parsed, return original content
    if (nodes.isEmpty) {
      return content;
    }

    // 4. Synthesize complete Clash YAML structure with regional groups
    final allProxyNames = nodes.map((e) => e['name'].toString()).toList();
    final List<Map<String, dynamic>> proxyGroups = [];

    // Region classification
    final hkNodes = _filterNodes(allProxyNames, ["香港", "HK", "HONG KONG", "HKG"]);
    final jpNodes = _filterNodes(allProxyNames, ["日本", "JP", "JAPAN", "东京", "大阪", "NRT", "HND", "KIX"]);
    final sgNodes = _filterNodes(allProxyNames, ["新加坡", "SG", "SINGAPORE", "狮城", "SIN"]);
    final twNodes = _filterNodes(allProxyNames, ["台湾", "TW", "TAIWAN", "台北", "TPE"]);
    final usNodes = _filterNodes(allProxyNames, ["美国", "US", "USA", "UNITED STATES", "SJC", "LAX", "JFK"]);
    final krNodes = _filterNodes(allProxyNames, ["韩国", "KR", "KOREA", "首尔", "ICN"]);

    _addRegionGroup(proxyGroups, "🇭🇰 香港节点", hkNodes);
    _addRegionGroup(proxyGroups, "🇯🇵 日本节点", jpNodes);
    _addRegionGroup(proxyGroups, "🇸🇬 新加坡节点", sgNodes);
    _addRegionGroup(proxyGroups, "🇹🇼 台湾节点", twNodes);
    _addRegionGroup(proxyGroups, "🇺🇸 美国节点", usNodes);
    _addRegionGroup(proxyGroups, "🇰🇷 韩国节点", krNodes);

    final autoGroup = <String, dynamic>{
      'name': '自动选择',
      'type': 'url-test',
      'url': 'http://www.gstatic.com/generate_204',
      'interval': 300,
      'tolerance': 50,
      'proxies': List.from(allProxyNames),
    };

    final fallbackGroup = <String, dynamic>{
      'name': '故障转移',
      'type': 'fallback',
      'url': 'http://www.gstatic.com/generate_204',
      'interval': 300,
      'proxies': List.from(allProxyNames),
    };

    final selectorProxies = <String>['自动选择', '故障转移'];
    for (var rg in proxyGroups) {
      selectorProxies.add(rg['name'].toString());
    }
    selectorProxies.addAll(allProxyNames);
    selectorProxies.add('DIRECT');

    final selectGroup = <String, dynamic>{
      'name': '节点选择',
      'type': 'select',
      'proxies': selectorProxies,
    };

    final globalProxies = <String>['节点选择', '自动选择', '故障转移', ...allProxyNames, 'DIRECT'];
    final globalGroup = <String, dynamic>{
      'name': 'GLOBAL',
      'type': 'select',
      'proxies': globalProxies,
    };

    final fullGroups = [selectGroup, autoGroup, fallbackGroup, ...proxyGroups, globalGroup];

    final yamlMap = {
      'port': 7890,
      'socks-port': 7891,
      'allow-lan': true,
      'mode': 'rule',
      'log-level': 'info',
      'external-controller': '127.0.0.1:9090',
      'proxies': nodes,
      'proxy-groups': fullGroups,
      'rules': [
        'GEOIP,LAN,DIRECT,no-resolve',
        'GEOIP,CN,DIRECT',
        'MATCH,节点选择',
      ],
    };

    final yamlWriter = YamlWriter();
    return yamlWriter.write(yamlMap);
  }

  // --- Specific Node Parsers ---

  static Map<String, dynamic>? _parseVmess(String uriStr) {
    final rawBase64 = uriStr.substring('vmess://'.length).trim();
    final jsonStr = safeBase64Decode(rawBase64);
    if (jsonStr == null || jsonStr.isEmpty) return null;

    final json = jsonDecode(jsonStr);
    if (json is! Map) return null;

    final add = json['add']?.toString() ?? "";
    final portVal = json['port'];
    final port = portVal is int ? portVal : (int.tryParse(portVal?.toString() ?? "") ?? 443);
    final id = json['id']?.toString() ?? "";
    final aidVal = json['aid'];
    final aid = aidVal is int ? aidVal : (int.tryParse(aidVal?.toString() ?? "") ?? 0);
    final net = json['net']?.toString() ?? "tcp";
    final type = json['type']?.toString() ?? "none";
    final host = json['host']?.toString() ?? "";
    final path = json['path']?.toString() ?? "";
    final tls = json['tls']?.toString() ?? "";
    final sni = json['sni']?.toString() ?? (host.isNotEmpty ? host : add);
    final ps = json['ps']?.toString() ?? "";
    final scy = json['scy']?.toString() ?? "auto";

    if (add.isEmpty || id.isEmpty) return null;

    final map = <String, dynamic>{
      'name': ps.isNotEmpty ? ps : 'VMess-$add:$port',
      'type': 'vmess',
      'server': add,
      'port': port,
      'uuid': id,
      'alterId': aid,
      'cipher': scy.isNotEmpty ? scy : 'auto',
      'udp': true,
      'tls': tls == 'tls',
      'skip-cert-verify': false,
    };

    if (tls == 'tls' && sni.isNotEmpty) {
      map['servername'] = sni;
    }

    if (net == 'ws') {
      map['network'] = 'ws';
      map['ws-opts'] = {
        'path': path.isNotEmpty ? path : '/',
        if (host.isNotEmpty) 'headers': {'Host': host},
      };
    } else if (net == 'grpc') {
      map['network'] = 'grpc';
      map['grpc-opts'] = {
        'grpc-service-name': path,
      };
    } else if (net == 'h2') {
      map['network'] = 'h2';
      map['h2-opts'] = {
        'path': path.isNotEmpty ? path : '/',
        if (host.isNotEmpty) 'host': [host],
      };
    } else if (net == 'http' && type == 'http') {
      map['network'] = 'http';
      map['http-opts'] = {
        if (path.isNotEmpty) 'path': [path],
        if (host.isNotEmpty) 'headers': {'Host': [host]},
      };
    }

    return map;
  }

  static Map<String, dynamic>? _parseVless(String uriStr) {
    final uri = Uri.tryParse(uriStr);
    if (uri == null) return null;

    final uuid = uri.userInfo;
    final server = uri.host;
    final port = uri.port > 0 ? uri.port : 443;
    final name = uri.hasFragment ? Uri.decodeComponent(uri.fragment) : 'VLESS-$server:$port';
    final params = uri.queryParameters;

    if (uuid.isEmpty || server.isEmpty) return null;

    final type = params['type'] ?? 'tcp';
    final security = params['security'] ?? '';
    final sni = params['sni'] ?? (params['peer'] ?? server);
    final flow = params['flow'] ?? '';
    final path = params['path'] ?? '/';
    final host = params['host'] ?? '';
    final fp = params['fp'] ?? '';
    final pbk = params['pbk'] ?? '';
    final sid = params['sid'] ?? '';

    final map = <String, dynamic>{
      'name': name,
      'type': 'vless',
      'server': server,
      'port': port,
      'uuid': uuid,
      'udp': true,
      'tls': security == 'tls' || security == 'reality',
      'skip-cert-verify': false,
    };

    if (flow.isNotEmpty) map['flow'] = flow;
    if (sni.isNotEmpty) map['servername'] = sni;
    if (fp.isNotEmpty) map['client-fingerprint'] = fp;

    if (security == 'reality') {
      map['reality-opts'] = {
        'public-key': pbk,
        if (sid.isNotEmpty) 'short-id': sid,
      };
    }

    if (type == 'ws') {
      map['network'] = 'ws';
      map['ws-opts'] = {
        'path': path,
        if (host.isNotEmpty) 'headers': {'Host': host},
      };
    } else if (type == 'grpc') {
      map['network'] = 'grpc';
      map['grpc-opts'] = {
        'grpc-service-name': params['serviceName'] ?? path,
      };
    }

    return map;
  }

  static Map<String, dynamic>? _parseShadowsocks(String uriStr) {
    final uri = Uri.tryParse(uriStr);
    if (uri == null) return null;

    String name = uri.hasFragment ? Uri.decodeComponent(uri.fragment) : '';
    String cipher = "";
    String password = "";
    String server = uri.host;
    int port = uri.port;

    // SIP002: ss://BASE64(cipher:password)@server:port#name
    if (uri.userInfo.isNotEmpty && server.isNotEmpty && port > 0) {
      final decodedUserInfo = safeBase64Decode(uri.userInfo);
      if (decodedUserInfo != null && decodedUserInfo.contains(':')) {
        final parts = decodedUserInfo.split(':');
        cipher = parts[0];
        password = parts.sublist(1).join(':');
      } else if (uri.userInfo.contains(':')) {
        final parts = uri.userInfo.split(':');
        cipher = parts[0];
        password = parts.sublist(1).join(':');
      }
    } else {
      // Legacy: ss://BASE64(cipher:password@server:port)#name
      final withoutScheme = uriStr.substring('ss://'.length);
      final atIndex = withoutScheme.indexOf('#');
      final base64Part = atIndex >= 0 ? withoutScheme.substring(0, atIndex) : withoutScheme;
      if (atIndex >= 0 && name.isEmpty) {
        name = Uri.decodeComponent(withoutScheme.substring(atIndex + 1));
      }

      final decoded = safeBase64Decode(base64Part);
      if (decoded != null && decoded.contains('@')) {
        final parts = decoded.split('@');
        final authParts = parts[0].split(':');
        cipher = authParts[0];
        password = authParts.sublist(1).join(':');

        final hostPortParts = parts[1].split(':');
        server = hostPortParts[0];
        port = int.tryParse(hostPortParts.length > 1 ? hostPortParts[1] : "") ?? 8388;
      }
    }

    if (server.isEmpty || port <= 0 || cipher.isEmpty || password.isEmpty) {
      return null;
    }

    return <String, dynamic>{
      'name': name.isNotEmpty ? name : 'SS-$server:$port',
      'type': 'ss',
      'server': server,
      'port': port,
      'cipher': cipher,
      'password': password,
      'udp': true,
    };
  }

  static Map<String, dynamic>? _parseTrojan(String uriStr) {
    final uri = Uri.tryParse(uriStr);
    if (uri == null) return null;

    final password = uri.userInfo;
    final server = uri.host;
    final port = uri.port > 0 ? uri.port : 443;
    final name = uri.hasFragment ? Uri.decodeComponent(uri.fragment) : 'Trojan-$server:$port';
    final params = uri.queryParameters;

    if (password.isEmpty || server.isEmpty) return null;

    final sni = params['sni'] ?? (params['peer'] ?? server);
    final type = params['type'] ?? 'tcp';
    final path = params['path'] ?? '/';
    final host = params['host'] ?? '';
    final allowInsecure = params['allowInsecure'] == '1' || params['insecure'] == '1';

    final map = <String, dynamic>{
      'name': name,
      'type': 'trojan',
      'server': server,
      'port': port,
      'password': password,
      'udp': true,
      'tls': true,
      'skip-cert-verify': allowInsecure,
      if (sni.isNotEmpty) 'sni': sni,
    };

    if (type == 'ws') {
      map['network'] = 'ws';
      map['ws-opts'] = {
        'path': path,
        if (host.isNotEmpty) 'headers': {'Host': host},
      };
    } else if (type == 'grpc') {
      map['network'] = 'grpc';
      map['grpc-opts'] = {
        'grpc-service-name': params['serviceName'] ?? path,
      };
    }

    return map;
  }

  static Map<String, dynamic>? _parseHysteria2(String uriStr) {
    final uri = Uri.tryParse(uriStr);
    if (uri == null) return null;

    final auth = uri.userInfo;
    final server = uri.host;
    final port = uri.port > 0 ? uri.port : 443;
    final name = uri.hasFragment ? Uri.decodeComponent(uri.fragment) : 'Hysteria2-$server:$port';
    final params = uri.queryParameters;

    if (server.isEmpty) return null;

    final sni = params['sni'] ?? server;
    final insecure = params['insecure'] == '1' || params['allowInsecure'] == '1';

    return <String, dynamic>{
      'name': name,
      'type': 'hysteria2',
      'server': server,
      'port': port,
      if (auth.isNotEmpty) 'password': auth,
      if (sni.isNotEmpty) 'sni': sni,
      'skip-cert-verify': insecure,
    };
  }

  static Map<String, dynamic>? _parseHysteria(String uriStr) {
    final uri = Uri.tryParse(uriStr);
    if (uri == null) return null;

    final server = uri.host;
    final port = uri.port > 0 ? uri.port : 443;
    final name = uri.hasFragment ? Uri.decodeComponent(uri.fragment) : 'Hysteria-$server:$port';
    final params = uri.queryParameters;

    if (server.isEmpty) return null;

    final auth = params['auth'] ?? uri.userInfo;
    final peer = params['peer'] ?? server;

    return <String, dynamic>{
      'name': name,
      'type': 'hysteria',
      'server': server,
      'port': port,
      if (auth.isNotEmpty) 'auth-str': auth,
      if (peer.isNotEmpty) 'sni': peer,
      'skip-cert-verify': params['insecure'] == '1',
    };
  }

  static Map<String, dynamic>? _parseTuic(String uriStr) {
    final uri = Uri.tryParse(uriStr);
    if (uri == null) return null;

    final userInfo = uri.userInfo;
    final server = uri.host;
    final port = uri.port > 0 ? uri.port : 8443;
    final name = uri.hasFragment ? Uri.decodeComponent(uri.fragment) : 'TUIC-$server:$port';
    final params = uri.queryParameters;

    if (userInfo.isEmpty || server.isEmpty) return null;

    String uuid = userInfo;
    String password = "";
    if (userInfo.contains(':')) {
      final parts = userInfo.split(':');
      uuid = parts[0];
      password = parts.sublist(1).join(':');
    }

    final sni = params['sni'] ?? server;
    final alpn = params['alpn'] ?? '';

    return <String, dynamic>{
      'name': name,
      'type': 'tuic',
      'server': server,
      'port': port,
      'uuid': uuid,
      if (password.isNotEmpty) 'password': password,
      if (sni.isNotEmpty) 'sni': sni,
      if (alpn.isNotEmpty) 'alpn': [alpn],
      'skip-cert-verify': params['allow_insecure'] == '1' || params['insecure'] == '1',
    };
  }

  static List<String> _filterNodes(List<String> allNodes, List<String> keywords) {
    return allNodes.where((n) {
      final u = n.toUpperCase();
      for (var kw in keywords) {
        if (n.contains(kw) || u.contains(kw.toUpperCase())) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  static void _addRegionGroup(List<Map<String, dynamic>> groups, String name, List<String> nodes) {
    if (nodes.isNotEmpty) {
      groups.add({
        'name': name,
        'type': 'url-test',
        'url': 'http://www.gstatic.com/generate_204',
        'interval': 300,
        'tolerance': 50,
        'proxies': nodes,
      });
    }
  }
}
