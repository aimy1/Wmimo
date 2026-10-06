import AppIntents
import SwiftUI
import WidgetKit
import NetworkExtension

@available(iOS 18.0, *)
struct wmimoWidgetControl: ControlWidget {
    public static let controlKind: String = "com.wmimo.app.wmimoWidget.ControlCenterToggle"
    private static let bundleIdentifier = "com.wmimo.app.wmimoService"
    private static let groupIdentifier = "group.com.wmimo.app"
    private static let defaultSharedDirectory: URL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
    nonisolated public static let configFile: URL? = defaultSharedDirectory?.appendingPathComponent("service.json", isDirectory: false)

    public init() {
        VpnServiceHandler.shared.controlKind = wmimoWidgetControl.controlKind
        VpnServiceHandler.shared.bundleIdentifier = wmimoWidgetControl.bundleIdentifier
        VpnServiceHandler.shared.configFilePath = wmimoWidgetControl.configFile?.path ?? ""
        VpnServiceHandler.shared.uiServerAddress = "Wmimo"
        VpnServiceHandler.shared.uiLocalizedDescription = "Wmimo"
        VpnServiceHandler.shared.getState(result: { _ in })
    }

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: Self.controlKind,
            provider: Provider()
        ) { value in
            ControlWidgetToggle(
                "Wmimo",
                isOn: value,
                action: StartVPNServiceIntent()
            ) { isRunning in
                Label(isRunning ? "ON" : "OFF", systemImage: isRunning ? "shield.fill" : "shield")
            }
        }
        .displayName("ON/OFF")
        .description("Start or Stop Wmimo VPN service")
    }
}

@available(iOS 18.0, *)
extension wmimoWidgetControl {
    struct Provider: ControlValueProvider {
        var previewValue: Bool {
            false
        }

        func currentValue() async throws -> Bool {
            await isRunning()
        }

        func isRunning() async -> Bool {
            let status = await VpnServiceHandler.shared.getCurrentState()
            return status == NEVPNStatus.connecting || status == NEVPNStatus.connected || status == NEVPNStatus.reasserting
        }
    }
}

@available(iOS 18.0, *)
struct StartVPNServiceIntent: SetValueIntent {
    static let title: LocalizedStringResource = "ON/OFF"

    @Parameter(title: "ON")
    var value: Bool

    func perform() async throws -> some IntentResult {
        if let configPath = wmimoWidgetControl.configFile?.path, FileManager.default.fileExists(atPath: configPath) {
            let _ = await withCheckedContinuation { continuation in
                if value {
                    VpnServiceHandler.shared.start(timeoutInSeconds: 30) { err in
                        continuation.resume(returning: err == nil)
                    }
                } else {
                    VpnServiceHandler.shared.stop { err in
                        continuation.resume(returning: err == nil)
                    }
                }
            }
        }

        return .result()
    }
}
