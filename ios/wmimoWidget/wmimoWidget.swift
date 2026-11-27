import Foundation
import WidgetKit
import SwiftUI
import AppIntents
import NetworkExtension

// MARK: - Brand Color Palette (Matching ThemeDefine)

extension Color {
    static let wmimoCyan = Color(red: 0.0, green: 0.737, blue: 0.875)       // #00BCDF
    static let wmimoGreen = Color(red: 0.063, green: 0.725, blue: 0.506)    // #10B981
    static let wmimoAmber = Color(red: 0.961, green: 0.620, blue: 0.043)    // #F59E0B
    static let wmimoRed = Color(red: 0.937, green: 0.267, blue: 0.267)      // #EF4444
    static let wmimoGrey = Color(red: 0.580, green: 0.639, blue: 0.722)     // #94A3B8
    static let wmimoDarkCard = Color(red: 0.110, green: 0.110, blue: 0.118) // #1C1C1E
    static let wmimoDarkInner = Color(red: 0.078, green: 0.078, blue: 0.086)// #141416
    static let wmimoLightInner = Color(red: 0.945, green: 0.961, blue: 0.976)// #F1F5F9
}

struct WmimoCardContainerBackground: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        (colorScheme == .dark ? Color.wmimoDarkCard : Color.white)
    }
}

// MARK: - Shared Timeline Provider & Entry

struct WmimoWidgetEntry: TimelineEntry {
    let date: Date
    let snapshot: WmimoWidgetSnapshot
}

struct WmimoWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> WmimoWidgetEntry {
        WmimoWidgetEntry(date: Date(), snapshot: WmimoWidgetSnapshot())
    }

    func getSnapshot(in context: Context, completion: @escaping (WmimoWidgetEntry) -> Void) {
        let snap = WmimoWidgetStore.loadSnapshot()
        completion(WmimoWidgetEntry(date: Date(), snapshot: snap))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WmimoWidgetEntry>) -> Void) {
        var snap = WmimoWidgetStore.loadSnapshot()
        VpnServiceHandler.shared.getState { status in
            if status != .invalid {
                let liveConnected = (status == .connected)
                let liveTransitioning = (status == .connecting || status == .disconnecting || status == .reasserting)
                if status == .connected || status == .connecting || status == .reasserting {
                    snap.connected = liveConnected
                    snap.transitioning = liveTransitioning
                }
            }
            let now = Date()
            let entry = WmimoWidgetEntry(date: now, snapshot: snap)
            let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: now) ?? now.addingTimeInterval(900)
            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
            completion(timeline)
        }
    }
}

// MARK: - Helper Views & Deep Links

private enum WmimoWidgetUI {
    static func statusColor(for snap: WmimoWidgetSnapshot) -> Color {
        if snap.connected { return .wmimoGreen }
        if snap.transitioning { return .wmimoCyan }
        return .wmimoGrey
    }

    static func statusText(for snap: WmimoWidgetSnapshot) -> String {
        if snap.transitioning {
            return snap.label("connecting", fallback: "Connecting")
        }
        return snap.connected
            ? snap.label("connected", fallback: "Connected")
            : snap.label("disconnected", fallback: "Disconnected")
    }

    static func modeLabel(for snap: WmimoWidgetSnapshot, mode: String? = nil) -> String {
        let m = (mode ?? snap.mode).lowercased()
        switch m {
        case "global":
            return snap.label("modeGlobal", fallback: "Global")
        case "direct":
            return snap.label("modeDirect", fallback: "Direct")
        default:
            return snap.label("modeRule", fallback: "Rule")
        }
    }

    static func delayColor(_ delay: Int?) -> Color {
        guard let d = delay, d > 0 else { return .secondary }
        if d < 300 { return .wmimoGreen }
        if d < 800 { return .wmimoAmber }
        return .wmimoRed
    }

    static func innerSurface(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .wmimoDarkInner : .wmimoLightInner
    }

    static func deepLink(action: String, tab: String? = nil, profileId: String? = nil, token: String) -> URL {
        var comps = URLComponents()
        comps.scheme = "wmimo"
        comps.host = "widget"
        var items = [
            URLQueryItem(name: "action", value: action),
            URLQueryItem(name: "token", value: token)
        ]
        if let tab = tab {
            items.append(URLQueryItem(name: "tab", value: tab))
        }
        if let profileId = profileId {
            items.append(URLQueryItem(name: "profileId", value: profileId))
        }
        comps.queryItems = items
        return comps.url ?? URL(string: "wmimo://widget")!
    }
}

// MARK: - 1. Node Status & VPN Control Widget (com.wmimo.app.wmimoWidget)

struct WmimoStatusWidgetView: View {
    var entry: WmimoWidgetProvider.Entry
    @Environment(\.widgetFamily) var family

    private var snap: WmimoWidgetSnapshot { entry.snapshot }

    var body: some View {
        Group {
            switch family {
            case .systemMedium:
                mediumView
            default:
                smallView
            }
        }
        .widgetURL(WmimoWidgetUI.deepLink(action: "open", tab: "home", token: snap.actionToken))
    }

    private var smallView: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Top bar: Status Dot + Status Text + Power Button
            HStack(spacing: 6) {
                Circle()
                    .fill(WmimoWidgetUI.statusColor(for: snap))
                    .frame(width: 8, height: 8)

                Text(WmimoWidgetUI.statusText(for: snap))
                    .font(.system(size: 12, weight: .bold))
                    .lineLimit(1)

                Spacer(minLength: 2)

                Button(intent: ToggleVpnWidgetIntent()) {
                    Image(systemName: snap.connected ? "power.circle.fill" : "power.circle")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(snap.connected ? Color.wmimoGreen : Color.secondary)
                }
                .buttonStyle(.plain)
            }

            // Middle: Active Node + Delay
            VStack(alignment: .leading, spacing: 3) {
                Text(
                    snap.effectiveCurrentNodeDisplay.isEmpty
                        ? snap.label("noNodes", fallback: "No Nodes")
                        : snap.effectiveCurrentNodeDisplay
                )
                .font(.system(size: 13, weight: .bold))
                .lineLimit(1)

                HStack(spacing: 4) {
                    Text(
                        snap.profileName.isEmpty
                            ? snap.label("noProfile", fallback: "No Profile")
                            : snap.profileName
                    )
                    .font(.system(size: 10.5))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                    Spacer(minLength: 2)

                    if let delay = snap.currentDelay, delay > 0 {
                        Text("\(delay) ms")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(WmimoWidgetUI.delayColor(delay))
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.primary.opacity(0.06), in: RoundedRectangle(cornerRadius: 10))

            Spacer(minLength: 0)

            // Bottom: Mode Cycle Pill + Speed
            HStack(spacing: 6) {
                Button(intent: CycleOutboundModeIntent()) {
                    Text(WmimoWidgetUI.modeLabel(for: snap))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.wmimoCyan)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.wmimoCyan.opacity(0.15), in: Capsule())
                }
                .buttonStyle(.plain)

                Spacer(minLength: 2)

                Text(snap.connected ? "↓ \(snap.downSpeedText)" : "0 B/s")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(snap.connected ? Color.wmimoCyan : Color.secondary)
                    .lineLimit(1)
            }
        }
    }

    private var mediumView: some View {
        HStack(spacing: 12) {
            // Left Column: Status + Toggle + Mode Selector
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(WmimoWidgetUI.statusColor(for: snap))
                        .frame(width: 8, height: 8)
                    Text(WmimoWidgetUI.statusText(for: snap))
                        .font(.system(size: 13, weight: .bold))
                        .lineLimit(1)
                    Spacer()
                    Button(intent: RefreshWmimoWidgetIntent()) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }

                Button(intent: ToggleVpnWidgetIntent()) {
                    HStack(spacing: 6) {
                        Image(systemName: snap.connected ? "shield.fill" : "shield.slash")
                            .font(.system(size: 14, weight: .semibold))
                        Text(
                            snap.connected
                                ? snap.label("tapToDisconnect", fallback: "Disconnect")
                                : snap.label("tapToConnect", fallback: "Connect")
                        )
                        .font(.system(size: 12, weight: .bold))
                        .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .foregroundStyle(snap.connected ? Color.white : Color.primary)
                    .background(
                        snap.connected ? Color.wmimoGreen : Color.primary.opacity(0.08),
                        in: RoundedRectangle(cornerRadius: 10)
                    )
                }
                .buttonStyle(.plain)

                Spacer(minLength: 0)

                // 3 Mode pills
                HStack(spacing: 4) {
                    ForEach(["rule", "global", "direct"], id: \.self) { m in
                        let isSelected = snap.mode.lowercased() == m
                        Button(intent: SetOutboundModeIntent(mode: m)) {
                            Text(WmimoWidgetUI.modeLabel(for: snap, mode: m))
                                .font(.system(size: 10, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 4)
                                .foregroundStyle(isSelected ? Color.wmimoCyan : Color.secondary)
                                .background(
                                    isSelected ? Color.wmimoCyan.opacity(0.16) : Color.primary.opacity(0.05),
                                    in: RoundedRectangle(cornerRadius: 6)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxWidth: .infinity)

            // Right Column: Active Node + Profile + Speed
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(snap.label("statusTitle", fallback: "Node Status"))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    if let delay = snap.currentDelay, delay > 0 {
                        Text("\(delay) ms")
                            .font(.system(size: 10.5, weight: .bold))
                            .foregroundStyle(WmimoWidgetUI.delayColor(delay))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.primary.opacity(0.06), in: Capsule())
                    }
                }

                Text(
                    snap.effectiveCurrentNodeDisplay.isEmpty
                        ? snap.label("noNodes", fallback: "No Nodes")
                        : snap.effectiveCurrentNodeDisplay
                )
                .font(.system(size: 13.5, weight: .bold))
                .lineLimit(1)

                Text(
                    snap.profileName.isEmpty
                        ? snap.label("noProfile", fallback: "No Profile")
                        : snap.profileName
                )
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .lineLimit(1)

                Spacer(minLength: 0)

                HStack {
                    Label(snap.connected ? snap.downSpeedText : "0 B/s", systemImage: "arrow.down")
                        .font(.system(size: 10.5, weight: .bold))
                        .foregroundStyle(Color.wmimoCyan)
                        .lineLimit(1)
                    Spacer()
                    Label(snap.connected ? snap.upSpeedText : "0 B/s", systemImage: "arrow.up")
                        .font(.system(size: 10.5, weight: .semibold))
                        .foregroundStyle(Color.wmimoAmber)
                        .lineLimit(1)
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primary.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct wmimoWidget: Widget {
    let kind: String = "com.wmimo.app.wmimoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WmimoWidgetProvider()) { entry in
            WmimoStatusWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    WmimoCardContainerBackground()
                }
        }
        .configurationDisplayName("Wmimo · Node Status")
        .description("View VPN connection status, active node latency, and toggle proxy in one tap.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - 2. Real-time Traffic & Plan Quota Widget (com.wmimo.app.wmimoWidget.traffic)

struct WmimoTrafficWidgetView: View {
    var entry: WmimoWidgetProvider.Entry
    @Environment(\.widgetFamily) var family

    private var snap: WmimoWidgetSnapshot { entry.snapshot }

    var body: some View {
        Group {
            switch family {
            case .systemMedium:
                mediumTrafficView
            default:
                smallTrafficView
            }
        }
        .widgetURL(WmimoWidgetUI.deepLink(action: "open", tab: "connections", token: snap.actionToken))
    }

    private var smallTrafficView: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 5) {
                Circle()
                    .fill(WmimoWidgetUI.statusColor(for: snap))
                    .frame(width: 7, height: 7)
                Text(snap.label("trafficTitle", fallback: "Live Traffic"))
                    .font(.system(size: 11.5, weight: .bold))
                    .lineLimit(1)
                Spacer()
                Button(intent: RefreshWmimoWidgetIntent()) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("↓ \(snap.label("download", fallback: "Down"))")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(snap.downTotalText)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
                Text(snap.connected ? snap.downSpeedText : "0 B/s")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.wmimoCyan)
                    .lineLimit(1)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color.primary.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("↑ \(snap.label("upload", fallback: "Up"))")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(snap.upTotalText)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
                Text(snap.connected ? snap.upSpeedText : "0 B/s")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.wmimoAmber)
                    .lineLimit(1)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color.primary.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
        }
    }

    private var mediumTrafficView: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack(spacing: 6) {
                Circle()
                    .fill(WmimoWidgetUI.statusColor(for: snap))
                    .frame(width: 8, height: 8)
                Text(snap.label("trafficTitle", fallback: "Live Traffic"))
                    .font(.system(size: 13, weight: .bold))
                Spacer()
                Text(
                    snap.profileName.isEmpty
                        ? snap.label("noProfile", fallback: "No Profile")
                        : snap.profileName
                )
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .lineLimit(1)

                Button(intent: RefreshWmimoWidgetIntent()) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.wmimoCyan)
                }
                .buttonStyle(.plain)
            }

            // Two Speed Cards
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("↓ \(snap.label("download", fallback: "Download"))")
                        .font(.system(size: 10.5))
                        .foregroundStyle(.secondary)
                    Text(snap.connected ? snap.downSpeedText : "0 B/s")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color.wmimoCyan)
                        .lineLimit(1)
                    Text(snap.downTotalText)
                        .font(.system(size: 10.5))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.primary.opacity(0.05), in: RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 3) {
                    Text("↑ \(snap.label("upload", fallback: "Upload"))")
                        .font(.system(size: 10.5))
                        .foregroundStyle(.secondary)
                    Text(snap.connected ? snap.upSpeedText : "0 B/s")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color.wmimoAmber)
                        .lineLimit(1)
                    Text(snap.upTotalText)
                        .font(.system(size: 10.5))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.primary.opacity(0.05), in: RoundedRectangle(cornerRadius: 10))
            }

            // Bottom Quota / Session Bar
            if snap.subTotal > 0 {
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text("\(snap.label("quota", fallback: "Quota")): \(snap.subUsedText) / \(snap.subTotalText)")
                            .font(.system(size: 10.5))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                        Spacer()
                        Text("\(snap.subPercent)%")
                            .font(.system(size: 10.5, weight: .bold))
                            .foregroundStyle(snap.subPercent >= 90 ? Color.wmimoRed : Color.wmimoCyan)
                    }
                    ProgressView(value: Double(min(max(snap.subPercent, 0), 100)), total: 100.0)
                        .tint(snap.subPercent >= 90 ? Color.wmimoRed : Color.wmimoCyan)
                }
            } else {
                HStack {
                    Text("\(snap.label("sessionTotal", fallback: "Session")): \(snap.sessionTotalText)")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    Spacer()
                    if !snap.currentNode.isEmpty {
                        Text(snap.currentNode)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}

struct WmimoTrafficWidget: Widget {
    let kind: String = "com.wmimo.app.wmimoWidget.traffic"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WmimoWidgetProvider()) { entry in
            WmimoTrafficWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    WmimoCardContainerBackground()
                }
        }
        .configurationDisplayName("Wmimo · Live Traffic")
        .description("Monitor real-time upload/download speeds, session traffic, and plan quota.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - 3. Quick Node & Config Switch Widget (com.wmimo.app.wmimoWidget.quickSwitch)

struct WmimoQuickSwitchWidgetView: View {
    var entry: WmimoWidgetProvider.Entry
    @Environment(\.widgetFamily) var family

    private var snap: WmimoWidgetSnapshot { entry.snapshot }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header: Dot + Profile Title + 3 Mode Buttons + Power Toggle
            HStack(spacing: 5) {
                Circle()
                    .fill(WmimoWidgetUI.statusColor(for: snap))
                    .frame(width: 8, height: 8)

                Text(
                    snap.profileName.isEmpty
                        ? snap.label("quickSwitchTitle", fallback: "Quick Switch")
                        : snap.profileName
                )
                .font(.system(size: 12.5, weight: .bold))
                .lineLimit(1)

                Spacer(minLength: 4)

                ForEach(["rule", "global", "direct"], id: \.self) { m in
                    let active = snap.mode.lowercased() == m
                    Button(intent: SetOutboundModeIntent(mode: m)) {
                        Text(WmimoWidgetUI.modeLabel(for: snap, mode: m))
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3.5)
                            .foregroundStyle(active ? Color.wmimoCyan : Color.secondary)
                            .background(
                                active ? Color.wmimoCyan.opacity(0.16) : Color.primary.opacity(0.06),
                                in: Capsule()
                            )
                    }
                    .buttonStyle(.plain)
                }

                Button(intent: ToggleVpnWidgetIntent()) {
                    Image(systemName: snap.connected ? "power.circle.fill" : "power.circle")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(snap.connected ? Color.wmimoGreen : Color.secondary)
                }
                .buttonStyle(.plain)
            }

            // Nodes Grid (4 slots on Medium, 6 slots on Large)
            let maxSlots = (family == .systemLarge) ? 6 : 4
            let displayNodes = Array(snap.nodes.prefix(maxSlots))

            if displayNodes.isEmpty {
                HStack {
                    Spacer()
                    Text(snap.label("noNodes", fallback: "No Nodes"))
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .background(Color.primary.opacity(0.04), in: RoundedRectangle(cornerRadius: 10))
            } else {
                let columns = [
                    GridItem(.flexible(), spacing: 6),
                    GridItem(.flexible(), spacing: 6)
                ]
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(displayNodes, id: \.name) { item in
                        let isSelected = item.selected || (!snap.currentNode.isEmpty && item.name == snap.currentNode)
                        Button(
                            intent: SwitchProxyNodeIntent(
                                groupName: snap.groupName,
                                nodeName: item.name
                            )
                        ) {
                            HStack(spacing: 4) {
                                Text(item.effectiveDisplayName)
                                    .font(.system(size: 11.5, weight: .bold))
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                Spacer(minLength: 2)
                                if let d = item.delay, d > 0 {
                                    Text("\(d)ms")
                                        .font(.system(size: 9.5, weight: .bold))
                                        .foregroundStyle(WmimoWidgetUI.delayColor(d))
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(
                                isSelected ? Color.wmimoCyan.opacity(0.16) : Color.primary.opacity(0.05),
                                in: RoundedRectangle(cornerRadius: 10)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        isSelected ? Color.wmimoCyan : Color.clear,
                                        lineWidth: 1.2
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            // On systemLarge, also display Quick Profile Switch Strip
            if family == .systemLarge && !snap.profiles.isEmpty {
                Spacer(minLength: 0)
                Divider()
                VStack(alignment: .leading, spacing: 5) {
                    Text(snap.label("switchProfile", fallback: "Switch Profile"))
                        .font(.system(size: 10.5, weight: .semibold))
                        .foregroundStyle(.secondary)

                    HStack(spacing: 6) {
                        ForEach(Array(snap.profiles.prefix(3)), id: \.id) { prof in
                            Link(
                                destination: WmimoWidgetUI.deepLink(
                                    action: "switch-profile",
                                    profileId: prof.id,
                                    token: snap.actionToken
                                )
                            ) {
                                Text(prof.name)
                                    .font(.system(size: 11, weight: .semibold))
                                    .lineLimit(1)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 5)
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(prof.selected ? Color.wmimoCyan : Color.primary)
                                    .background(
                                        prof.selected ? Color.wmimoCyan.opacity(0.16) : Color.primary.opacity(0.05),
                                        in: RoundedRectangle(cornerRadius: 8)
                                    )
                            }
                        }
                    }
                }
            }
        }
        .widgetURL(WmimoWidgetUI.deepLink(action: "open", tab: "proxies", token: snap.actionToken))
    }
}

struct WmimoQuickSwitchWidget: Widget {
    let kind: String = "com.wmimo.app.wmimoWidget.quickSwitch"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WmimoWidgetProvider()) { entry in
            WmimoQuickSwitchWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    WmimoCardContainerBackground()
                }
        }
        .configurationDisplayName("Wmimo · Quick Switch")
        .description("Switch proxy nodes, outbound routing modes, and profiles directly from your home screen.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
