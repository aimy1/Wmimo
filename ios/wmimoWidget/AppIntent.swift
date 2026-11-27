import Foundation
import WidgetKit
import AppIntents
import NetworkExtension

public struct WmimoWidgetNodeItem: Codable, Sendable, Hashable {
    public var name: String
    public var displayName: String?
    public var delay: Int?
    public var selected: Bool

    public var effectiveDisplayName: String {
        if let disp = displayName, !disp.isEmpty {
            return disp
        }
        return name
    }

    public init(name: String, displayName: String? = nil, delay: Int? = nil, selected: Bool = false) {
        self.name = name
        self.displayName = displayName ?? name
        self.delay = delay
        self.selected = selected
    }
}

public struct WmimoWidgetProfileItem: Codable, Sendable, Hashable {
    public var id: String
    public var name: String
    public var selected: Bool

    public init(id: String, name: String, selected: Bool = false) {
        self.id = id
        self.name = name
        self.selected = selected
    }
}

public struct WmimoWidgetSnapshot: Codable, Sendable {
    public var version: Int = 1
    public var updatedAt: Int64 = 0
    public var connected: Bool = false
    public var transitioning: Bool = false
    public var vpnState: String = "disconnected"
    public var mode: String = "rule"
    public var profileId: String = ""
    public var profileName: String = ""
    public var groupName: String = "节点选择"
    public var currentNode: String = ""
    public var currentNodeDisplay: String? = nil
    public var currentDelay: Int? = nil

    public var effectiveCurrentNodeDisplay: String {
        if let disp = currentNodeDisplay, !disp.isEmpty {
            return disp
        }
        return currentNode
    }
    public var controlPort: Int = 9090
    public var controlSecret: String = ""
    public var upSpeed: Int64 = 0
    public var downSpeed: Int64 = 0
    public var upSpeedText: String = "0 B/s"
    public var downSpeedText: String = "0 B/s"
    public var upTotal: Int64 = 0
    public var downTotal: Int64 = 0
    public var upTotalText: String = "0 B"
    public var downTotalText: String = "0 B"
    public var sessionTotalText: String = "0 B"
    public var subUsed: Int64 = 0
    public var subTotal: Int64 = 0
    public var subUsedText: String = "0 B"
    public var subTotalText: String = "0 B"
    public var subRemainingText: String = ""
    public var subPercent: Int = 0
    public var subExpire: String = ""
    public var actionToken: String = ""
    public var nodes: [WmimoWidgetNodeItem] = []
    public var profiles: [WmimoWidgetProfileItem] = []
    public var labels: [String: String] = [:]

    public init() {}

    public func label(_ key: String, fallback: String) -> String {
        if let val = labels[key], !val.isEmpty {
            return val
        }
        return WmimoWidgetBuiltInI18n.resolve(key, fallback: fallback)
    }
}

public enum WmimoWidgetBuiltInI18n {
    private static let table: [String: [String: String]] = [
        "zh-Hans": [
            "connected": "已连接", "connecting": "连接中", "disconnected": "未连接",
            "statusTitle": "节点状态", "trafficTitle": "实时流量", "quickSwitchTitle": "快捷切换",
            "upload": "上传", "download": "下载", "sessionTotal": "本次流量", "quota": "套餐余量",
            "remaining": "剩余", "noProfile": "暂无配置", "noNodes": "暂无节点",
            "tapToConnect": "点击连接", "tapToDisconnect": "点击断开",
            "modeRule": "规则", "modeGlobal": "全局", "modeDirect": "直连",
            "refresh": "刷新", "switchNode": "切换节点", "switchProfile": "切换配置"
        ],
        "zh-Hant": [
            "connected": "已連線", "connecting": "連線中", "disconnected": "未連線",
            "statusTitle": "節點狀態", "trafficTitle": "即時流量", "quickSwitchTitle": "快速切換",
            "upload": "上傳", "download": "下載", "sessionTotal": "本次流量", "quota": "方案餘量",
            "remaining": "剩餘", "noProfile": "暫無配置", "noNodes": "暫無節點",
            "tapToConnect": "點擊連線", "tapToDisconnect": "點擊中斷",
            "modeRule": "規則", "modeGlobal": "全域", "modeDirect": "直連",
            "refresh": "重新整理", "switchNode": "切換節點", "switchProfile": "切換配置"
        ],
        "ja": [
            "connected": "接続済み", "connecting": "接続中", "disconnected": "未接続",
            "statusTitle": "ノード状態", "trafficTitle": "リアルタイム通信量", "quickSwitchTitle": "クイック切替",
            "upload": "アップロード", "download": "ダウンロード", "sessionTotal": "今回の通信量", "quota": "プラン残量",
            "remaining": "残り", "noProfile": "プロファイルなし", "noNodes": "ノードなし",
            "tapToConnect": "タップして接続", "tapToDisconnect": "タップして切断",
            "modeRule": "ルール", "modeGlobal": "グローバル", "modeDirect": "ダイレクト",
            "refresh": "更新", "switchNode": "ノード切替", "switchProfile": "プロファイル切替"
        ],
        "ko": [
            "connected": "연결됨", "connecting": "연결 중", "disconnected": "연결 안 됨",
            "statusTitle": "노드 상태", "trafficTitle": "실시간 트래픽", "quickSwitchTitle": "빠른 전환",
            "upload": "업로드", "download": "다운로드", "sessionTotal": "세션 트래픽", "quota": "데이터 잔여량",
            "remaining": "잔여", "noProfile": "프로필 없음", "noNodes": "노드 없음",
            "tapToConnect": "탭하여 연결", "tapToDisconnect": "탭하여 연결 해제",
            "modeRule": "규칙", "modeGlobal": "글로벌", "modeDirect": "직접 연결",
            "refresh": "새로고침", "switchNode": "노드 전환", "switchProfile": "프로필 전환"
        ],
        "ru": [
            "connected": "Подключено", "connecting": "Подключение", "disconnected": "Отключено",
            "statusTitle": "Статус узла", "trafficTitle": "Трафик", "quickSwitchTitle": "Быстрое переключение",
            "upload": "Отдача", "download": "Загрузка", "sessionTotal": "За сессию", "quota": "Лимит трафика",
            "remaining": "Остаток", "noProfile": "Нет профиля", "noNodes": "Нет узлов",
            "tapToConnect": "Подключить", "tapToDisconnect": "Отключить",
            "modeRule": "Правила", "modeGlobal": "Глобальный", "modeDirect": "Напрямую",
            "refresh": "Обновить", "switchNode": "Сменить узел", "switchProfile": "Сменить профиль"
        ],
        "es": [
            "connected": "Conectado", "connecting": "Conectando", "disconnected": "Desconectado",
            "statusTitle": "Estado del nodo", "trafficTitle": "Tráfico en vivo", "quickSwitchTitle": "Cambio rápido",
            "upload": "Subida", "download": "Bajada", "sessionTotal": "Sesión", "quota": "Cuota del plan",
            "remaining": "Restante", "noProfile": "Sin perfil", "noNodes": "Sin nodos",
            "tapToConnect": "Conectar", "tapToDisconnect": "Desconectar",
            "modeRule": "Regla", "modeGlobal": "Global", "modeDirect": "Directo",
            "refresh": "Actualizar", "switchNode": "Cambiar nodo", "switchProfile": "Cambiar perfil"
        ],
        "ar": [
            "connected": "متصل", "connecting": "جارٍ الاتصال", "disconnected": "غير متصل",
            "statusTitle": "حالة الخادم", "trafficTitle": "حركة المرور الحية", "quickSwitchTitle": "تبديل سريع",
            "upload": "رفع", "download": "تنزيل", "sessionTotal": "الجلسة", "quota": "حصة الباقة",
            "remaining": "المتبقي", "noProfile": "لا يوجد ملف", "noNodes": "لا توجد خوادم",
            "tapToConnect": "انقر للاتصال", "tapToDisconnect": "انقر لقطع الاتصال",
            "modeRule": "قواعد", "modeGlobal": "شامل", "modeDirect": "مباشر",
            "refresh": "تحديث", "switchNode": "تبديل الخادم", "switchProfile": "تبديل الملف"
        ],
        "fa": [
            "connected": "متصل شد", "connecting": "در حال اتصال", "disconnected": "قطع شد",
            "statusTitle": "وضعیت سرور", "trafficTitle": "ترافیک لحظه‌ای", "quickSwitchTitle": "تغییر سریع",
            "upload": "آپلود", "download": "دانلود", "sessionTotal": "ترافیک نشست", "quota": "حجم اشتراک",
            "remaining": "باقی‌مانده", "noProfile": "بدون اشتراک", "noNodes": "بدون سرور",
            "tapToConnect": "لمس برای اتصال", "tapToDisconnect": "لمس برای قطع",
            "modeRule": "قانون", "modeGlobal": "سراسری", "modeDirect": "مستقیم",
            "refresh": "بروزرسانی", "switchNode": "تغییر سرور", "switchProfile": "تغییر اشتراک"
        ]
    ]

    public static func resolve(_ key: String, fallback: String) -> String {
        let preferred = Locale.preferredLanguages.first ?? "en"
        let langKey: String
        if preferred.hasPrefix("zh-Hant") || preferred.hasPrefix("zh-TW") || preferred.hasPrefix("zh-HK") {
            langKey = "zh-Hant"
        } else if preferred.hasPrefix("zh") {
            langKey = "zh-Hans"
        } else if preferred.hasPrefix("ja") {
            langKey = "ja"
        } else if preferred.hasPrefix("ko") {
            langKey = "ko"
        } else if preferred.hasPrefix("ru") {
            langKey = "ru"
        } else if preferred.hasPrefix("es") {
            langKey = "es"
        } else if preferred.hasPrefix("ar") {
            langKey = "ar"
        } else if preferred.hasPrefix("fa") {
            langKey = "fa"
        } else {
            return fallback
        }
        return table[langKey]?[key] ?? fallback
    }
}

public enum WmimoWidgetStore {
    public static let appGroupId = "group.com.wmimo.app"
    public static let snapshotKey = "widget_snapshot"
    public static let tokenKey = "widget_action_token"
    public static let overrideModeKey = "override_mode"
    public static let overrideNodeKey = "override_node"
    public static let overrideVpnStoppedKey = "override_vpn_stopped"
    public static let snapshotFileName = "widget_snapshot.json"

    public static func sharedDefaults() -> UserDefaults? {
        UserDefaults(suiteName: appGroupId)
    }

    public static func snapshotFileURL() -> URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupId)?
            .appendingPathComponent(snapshotFileName, isDirectory: false)
    }

    public static func getOrCreateToken() -> String {
        let defaults = sharedDefaults()
        if let existing = defaults?.string(forKey: tokenKey), !existing.isEmpty {
            return existing
        }
        let generated = UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
        defaults?.set(generated, forKey: tokenKey)
        return generated
    }

    public static func loadSnapshot() -> WmimoWidgetSnapshot {
        var fromDefaults: WmimoWidgetSnapshot? = nil
        var fromFile: WmimoWidgetSnapshot? = nil

        if let raw = sharedDefaults()?.string(forKey: snapshotKey),
           let data = raw.data(using: .utf8) {
            fromDefaults = parseSnapshotData(data)
        }

        if let url = snapshotFileURL(),
           let data = try? Data(contentsOf: url) {
            fromFile = parseSnapshotData(data)
        }

        var chosen: WmimoWidgetSnapshot
        if let d = fromDefaults, let f = fromFile {
            chosen = (f.updatedAt > d.updatedAt) ? f : d
        } else if let d = fromDefaults {
            chosen = d
        } else if let f = fromFile {
            chosen = f
        } else {
            chosen = WmimoWidgetSnapshot()
        }

        if chosen.actionToken.isEmpty {
            chosen.actionToken = getOrCreateToken()
        }
        return chosen
    }

    public static func saveSnapshot(_ snapshot: WmimoWidgetSnapshot) {
        var mutable = snapshot
        mutable.updatedAt = Int64(Date().timeIntervalSince1970 * 1000)
        guard let data = try? JSONEncoder().encode(mutable),
              let str = String(data: data, encoding: .utf8) else {
            return
        }
        sharedDefaults()?.set(str, forKey: snapshotKey)
        if let url = snapshotFileURL() {
            try? data.write(to: url, options: .atomic)
        }
    }

    public static func recordNativeOverride(
        mode: String? = nil,
        node: String? = nil,
        vpnStopped: Bool? = nil
    ) {
        guard let defaults = sharedDefaults() else { return }
        if let mode = mode, !mode.isEmpty {
            defaults.set(mode, forKey: overrideModeKey)
        }
        if let node = node, !node.isEmpty {
            defaults.set(node, forKey: overrideNodeKey)
        }
        if let vpnStopped = vpnStopped {
            defaults.set(vpnStopped, forKey: overrideVpnStoppedKey)
        }
    }

    private static func parseSnapshotData(_ data: Data) -> WmimoWidgetSnapshot? {
        if let decoded = try? JSONDecoder().decode(WmimoWidgetSnapshot.self, from: data) {
            return decoded
        }
        guard let dict = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
            return nil
        }
        var snap = WmimoWidgetSnapshot()
        snap.version = dict["version"] as? Int ?? 1
        snap.updatedAt = (dict["updatedAt"] as? NSNumber)?.int64Value ?? 0
        snap.connected = dict["connected"] as? Bool ?? false
        snap.transitioning = dict["transitioning"] as? Bool ?? false
        snap.vpnState = dict["vpnState"] as? String ?? "disconnected"
        snap.mode = dict["mode"] as? String ?? "rule"
        snap.profileId = dict["profileId"] as? String ?? ""
        snap.profileName = dict["profileName"] as? String ?? ""
        snap.groupName = dict["groupName"] as? String ?? "节点选择"
        snap.currentNode = dict["currentNode"] as? String ?? ""
        snap.currentNodeDisplay = dict["currentNodeDisplay"] as? String
        if let d = (dict["currentDelay"] as? NSNumber)?.intValue, d > 0 {
            snap.currentDelay = d
        }
        snap.controlPort = (dict["controlPort"] as? NSNumber)?.intValue ?? 9090
        snap.controlSecret = dict["controlSecret"] as? String ?? ""
        snap.upSpeed = (dict["upSpeed"] as? NSNumber)?.int64Value ?? 0
        snap.downSpeed = (dict["downSpeed"] as? NSNumber)?.int64Value ?? 0
        snap.upSpeedText = dict["upSpeedText"] as? String ?? "0 B/s"
        snap.downSpeedText = dict["downSpeedText"] as? String ?? "0 B/s"
        snap.upTotal = (dict["upTotal"] as? NSNumber)?.int64Value ?? 0
        snap.downTotal = (dict["downTotal"] as? NSNumber)?.int64Value ?? 0
        snap.upTotalText = dict["upTotalText"] as? String ?? "0 B"
        snap.downTotalText = dict["downTotalText"] as? String ?? "0 B"
        snap.sessionTotalText = dict["sessionTotalText"] as? String ?? "0 B"
        snap.subUsed = (dict["subUsed"] as? NSNumber)?.int64Value ?? 0
        snap.subTotal = (dict["subTotal"] as? NSNumber)?.int64Value ?? 0
        snap.subUsedText = dict["subUsedText"] as? String ?? "0 B"
        snap.subTotalText = dict["subTotalText"] as? String ?? "0 B"
        snap.subRemainingText = dict["subRemainingText"] as? String ?? ""
        snap.subPercent = (dict["subPercent"] as? NSNumber)?.intValue ?? 0
        snap.subExpire = dict["subExpire"] as? String ?? ""
        snap.actionToken = dict["actionToken"] as? String ?? ""

        if let rawNodes = dict["nodes"] as? [[String: Any]] {
            snap.nodes = rawNodes.map { item in
                let delayVal = (item["delay"] as? NSNumber)?.intValue
                let nName = item["name"] as? String ?? ""
                return WmimoWidgetNodeItem(
                    name: nName,
                    displayName: item["displayName"] as? String ?? nName,
                    delay: (delayVal != nil && delayVal! > 0) ? delayVal : nil,
                    selected: item["selected"] as? Bool ?? false
                )
            }
        }
        if let rawProfiles = dict["profiles"] as? [[String: Any]] {
            snap.profiles = rawProfiles.map { item in
                WmimoWidgetProfileItem(
                    id: item["id"] as? String ?? "",
                    name: item["name"] as? String ?? "",
                    selected: item["selected"] as? Bool ?? false
                )
            }
        }
        if let rawLabels = dict["labels"] as? [String: Any] {
            var map: [String: String] = [:]
            for (k, v) in rawLabels {
                if let s = v as? String {
                    map[k] = s
                }
            }
            snap.labels = map
        }
        return snap
    }

    public static func formatBytes(_ bytes: Int64) -> String {
        if bytes <= 0 {
            return "0 B"
        }
        let kb = 1024.0
        let mb = kb * 1024.0
        let gb = mb * 1024.0
        let tb = gb * 1024.0
        let val = Double(bytes)
        if val >= tb {
            return String(format: "%.1f TB", val / tb)
        }
        if val >= gb {
            return String(format: "%.1f GB", val / gb)
        }
        if val >= mb {
            return String(format: "%.1f MB", val / mb)
        }
        if val >= kb {
            return String(format: "%.1f KB", val / kb)
        }
        return "\(bytes) B"
    }

    public static func performCoreHttpRequest(
        port: Int,
        secret: String,
        path: String,
        method: String = "GET",
        bodyDict: [String: Any]? = nil
    ) async -> Data? {
        let effectivePort = port > 0 ? port : 9090
        guard let url = URL(string: "http://127.0.0.1:\(effectivePort)\(path)") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 1.5
        if !secret.isEmpty {
            request.setValue("Bearer \(secret)", forHTTPHeaderField: "Authorization")
        }
        if let bodyDict = bodyDict,
           let bodyData = try? JSONSerialization.data(withJSONObject: bodyDict) {
            request.httpBody = bodyData
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) {
                return data
            }
        } catch {}
        return nil
    }

    public static func refreshLiveMetricsIfConnected(_ initialSnapshot: WmimoWidgetSnapshot) async -> WmimoWidgetSnapshot {
        var snapshot = initialSnapshot
        let status = await VpnServiceHandler.shared.getCurrentState()
        let isRunning = (status == .connected || status == .connecting || status == .reasserting)
        if status != .invalid {
            snapshot.connected = (status == .connected)
            snapshot.transitioning = (status == .connecting || status == .disconnecting || status == .reasserting)
            snapshot.vpnState = snapshot.connected ? "connected" : (snapshot.transitioning ? "connecting" : "disconnected")
        }
        guard isRunning || snapshot.connected else {
            snapshot.upSpeed = 0
            snapshot.downSpeed = 0
            snapshot.upSpeedText = "0 B/s"
            snapshot.downSpeedText = "0 B/s"
            return snapshot
        }

        if let connData = await performCoreHttpRequest(
            port: snapshot.controlPort,
            secret: snapshot.controlSecret,
            path: "/connections"
        ),
        let obj = (try? JSONSerialization.jsonObject(with: connData)) as? [String: Any] {
            let upTotal = (obj["uploadTotal"] as? NSNumber)?.int64Value ?? snapshot.upTotal
            let downTotal = (obj["downloadTotal"] as? NSNumber)?.int64Value ?? snapshot.downTotal
            snapshot.upTotal = upTotal
            snapshot.downTotal = downTotal
            snapshot.upTotalText = formatBytes(upTotal)
            snapshot.downTotalText = formatBytes(downTotal)
            snapshot.sessionTotalText = formatBytes(upTotal + downTotal)
        }
        return snapshot
    }
}

// MARK: - Interactive Widget AppIntents (iOS 17 / 18+)

@available(iOS 17.0, *)
struct ToggleVpnWidgetIntent: AppIntent {
    static let title: LocalizedStringResource = "Toggle Wmimo VPN"
    static let description = IntentDescription("Start or stop the Wmimo VPN tunnel.")

    func perform() async throws -> some IntentResult {
        var snap = WmimoWidgetStore.loadSnapshot()
        let currentStatus = await VpnServiceHandler.shared.getCurrentState()
        let isRunning = (currentStatus == .connected || currentStatus == .connecting || currentStatus == .reasserting) || snap.connected

        if isRunning {
            let _ = await withCheckedContinuation { continuation in
                VpnServiceHandler.shared.stop { _ in
                    continuation.resume(returning: true)
                }
            }
            snap.connected = false
            snap.transitioning = false
            snap.vpnState = "disconnected"
            snap.upSpeed = 0
            snap.downSpeed = 0
            snap.upSpeedText = "0 B/s"
            snap.downSpeedText = "0 B/s"
            WmimoWidgetStore.recordNativeOverride(vpnStopped: true)
        } else if VpnServiceHandler.shared.hasValidConfigFile() {
            let started = await withCheckedContinuation { continuation in
                VpnServiceHandler.shared.start(timeoutInSeconds: 25) { err in
                    continuation.resume(returning: err == nil)
                }
            }
            snap.connected = started
            snap.transitioning = false
            snap.vpnState = started ? "connected" : "disconnected"
            WmimoWidgetStore.recordNativeOverride(vpnStopped: false)
        }

        WmimoWidgetStore.saveSnapshot(snap)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

@available(iOS 17.0, *)
struct RefreshWmimoWidgetIntent: AppIntent {
    static let title: LocalizedStringResource = "Refresh Wmimo Widget"
    static let description = IntentDescription("Refresh live traffic and proxy node status.")

    func perform() async throws -> some IntentResult {
        let current = WmimoWidgetStore.loadSnapshot()
        let snap = await WmimoWidgetStore.refreshLiveMetricsIfConnected(current)
        WmimoWidgetStore.saveSnapshot(snap)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

@available(iOS 17.0, *)
struct CycleOutboundModeIntent: AppIntent {
    static let title: LocalizedStringResource = "Cycle Outbound Mode"
    static let description = IntentDescription("Cycle between Rule, Global, and Direct proxy modes.")

    func perform() async throws -> some IntentResult {
        var snap = WmimoWidgetStore.loadSnapshot()
        let cur = snap.mode.lowercased()
        let next: String
        switch cur {
        case "rule": next = "global"
        case "global": next = "direct"
        default: next = "rule"
        }

        if snap.connected {
            _ = await WmimoWidgetStore.performCoreHttpRequest(
                port: snap.controlPort,
                secret: snap.controlSecret,
                path: "/configs",
                method: "PATCH",
                bodyDict: ["mode": next]
            )
        }
        snap.mode = next
        WmimoWidgetStore.recordNativeOverride(mode: next)
        WmimoWidgetStore.saveSnapshot(snap)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

@available(iOS 17.0, *)
struct SetOutboundModeIntent: AppIntent {
    static let title: LocalizedStringResource = "Set Outbound Mode"
    static let description = IntentDescription("Set Wmimo outbound routing mode.")

    @Parameter(title: "Mode")
    var mode: String

    init() {
        self.mode = "rule"
    }

    init(mode: String) {
        self.mode = mode
    }

    func perform() async throws -> some IntentResult {
        var snap = WmimoWidgetStore.loadSnapshot()
        let target = mode.lowercased()
        if snap.connected {
            _ = await WmimoWidgetStore.performCoreHttpRequest(
                port: snap.controlPort,
                secret: snap.controlSecret,
                path: "/configs",
                method: "PATCH",
                bodyDict: ["mode": target]
            )
        }
        snap.mode = target
        WmimoWidgetStore.recordNativeOverride(mode: target)
        WmimoWidgetStore.saveSnapshot(snap)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

@available(iOS 17.0, *)
struct SwitchProxyNodeIntent: AppIntent {
    static let title: LocalizedStringResource = "Switch Proxy Node"
    static let description = IntentDescription("Switch the active proxy node in Wmimo.")

    @Parameter(title: "Group Name")
    var groupName: String

    @Parameter(title: "Node Name")
    var nodeName: String

    init() {
        self.groupName = "节点选择"
        self.nodeName = ""
    }

    init(groupName: String, nodeName: String) {
        self.groupName = groupName
        self.nodeName = nodeName
    }

    func perform() async throws -> some IntentResult {
        guard !nodeName.isEmpty else { return .result() }
        var snap = WmimoWidgetStore.loadSnapshot()
        let effectiveGroup = groupName.isEmpty ? (snap.groupName.isEmpty ? "节点选择" : snap.groupName) : groupName

        if snap.connected {
            let allowed = CharacterSet.urlPathAllowed.subtracting(CharacterSet(charactersIn: "/"))
            let encodedGroup = effectiveGroup.addingPercentEncoding(withAllowedCharacters: allowed) ?? effectiveGroup
            _ = await WmimoWidgetStore.performCoreHttpRequest(
                port: snap.controlPort,
                secret: snap.controlSecret,
                path: "/proxies/\(encodedGroup)",
                method: "PUT",
                bodyDict: ["name": nodeName]
            )
            if effectiveGroup != "GLOBAL" {
                _ = await WmimoWidgetStore.performCoreHttpRequest(
                    port: snap.controlPort,
                    secret: snap.controlSecret,
                    path: "/proxies/GLOBAL",
                    method: "PUT",
                    bodyDict: ["name": nodeName]
                )
            }
        }

        snap.currentNode = nodeName
        var matchedDisplay = nodeName
        for idx in snap.nodes.indices {
            let isMatch = (snap.nodes[idx].name == nodeName)
            snap.nodes[idx].selected = isMatch
            if isMatch {
                matchedDisplay = snap.nodes[idx].effectiveDisplayName
                if let d = snap.nodes[idx].delay, d > 0 {
                    snap.currentDelay = d
                }
            }
        }
        snap.currentNodeDisplay = matchedDisplay

        WmimoWidgetStore.recordNativeOverride(node: nodeName)
        WmimoWidgetStore.saveSnapshot(snap)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
