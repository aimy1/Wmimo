//
//  wmimoWidgetControl.swift
//  wmimoWidget
//
//  Created by user on 2026/1/19.
//

import AppIntents
import SwiftUI
import WidgetKit

import NetworkExtension

struct wmimoWidgetControl: ControlWidget {
    public static let controlKind: String = "com.wmimo.app.wmimoWidget.ControlCenterToggle"
    private static let bundleIdentifier = "com.wmimo.app.wmimoService"
    private static let groupIdentifier = "group.com.wmimo.app"
    private static let defaultSharedDirectory: URL! = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)!
    public static let configFile = defaultSharedDirectory.appendingPathComponent("service.json", isDirectory: false)
    public init(){
        VpnServiceHandler.shared.controlKind = wmimoWidgetControl.controlKind
        VpnServiceHandler.shared.bundleIdentifier = wmimoWidgetControl.bundleIdentifier
        VpnServiceHandler.shared.configFilePath = wmimoWidgetControl.configFile.path()
        VpnServiceHandler.shared.uiServerAddress = "Wmimo"
        VpnServiceHandler.shared.uiLocalizedDescription = "Wmimo"
        VpnServiceHandler.shared.getState(result: {_ in })
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
                Label(isRunning ? "ON" : "OFF", image: "control_widget")
            }
        }
        .displayName("ON/OFF")
        .description("Start or Stop Wmimo VPN service")
    }
}

extension wmimoWidgetControl {
    struct Provider: ControlValueProvider {
         var previewValue: Bool {
            false
        }

        func currentValue() async throws -> Bool {
            let runing = await isRunning()
            return runing
        }

        func isRunning() async -> Bool {
            let status = await VpnServiceHandler.shared.getCurrentState()
            return status == NEVPNStatus.connecting || status == NEVPNStatus.connected || status == NEVPNStatus.reasserting
        }
    }
}

struct StartVPNServiceIntent: SetValueIntent {
    static let title: LocalizedStringResource = "ON/OFF"

    @Parameter(title: "ON")
    var value: Bool

    func perform() async throws -> some IntentResult {
        if await FileManager.default.fileExists(atPath: wmimoWidgetControl.configFile.path()) {
            await withCheckedContinuation { continuation in
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
