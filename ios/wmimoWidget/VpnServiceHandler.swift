import Foundation
import NetworkExtension
import os.log

public final class VpnServiceHandler: @unchecked Sendable {
    public static let shared = VpnServiceHandler()

    public static let appGroupId = "group.com.wmimo.app"
    public static let defaultBundleId = "com.wmimo.app.wmimoService"

    public var controlKind: String = "com.wmimo.app.wmimoWidget.ControlCenterToggle"
    public var bundleIdentifier: String = VpnServiceHandler.defaultBundleId
    public var configFilePath: String = ""
    public var uiServerAddress: String = "Wmimo"
    public var uiLocalizedDescription: String = "Wmimo"

    private var vpnManager: NETunnelProviderManager?
    private let log = OSLog(subsystem: "com.wmimo.app.wmimoWidget", category: "VpnServiceHandler")

    private init() {
        resolveDefaultConfigPathIfNeeded()
    }

    public func resolveDefaultConfigPathIfNeeded() {
        if !configFilePath.isEmpty && FileManager.default.fileExists(atPath: configFilePath) {
            return
        }
        guard let groupDir = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: Self.appGroupId
        ) else {
            return
        }
        let candidates = ["config.json", "service.json"]
        for name in candidates {
            let candidateUrl = groupDir.appendingPathComponent(name, isDirectory: false)
            if FileManager.default.fileExists(atPath: candidateUrl.path) {
                configFilePath = candidateUrl.path
                return
            }
        }
        configFilePath = groupDir.appendingPathComponent("service.json", isDirectory: false).path
    }

    public func hasValidConfigFile() -> Bool {
        resolveDefaultConfigPathIfNeeded()
        return !configFilePath.isEmpty && FileManager.default.fileExists(atPath: configFilePath)
    }

    public func getState(result: @escaping (NEVPNStatus) -> Void) {
        loadVpnManager { manager in
            result(manager?.connection.status ?? .disconnected)
        }
    }

    public func getCurrentState() async -> NEVPNStatus {
        await withCheckedContinuation { continuation in
            getState { status in
                continuation.resume(returning: status)
            }
        }
    }

    public func start(timeoutInSeconds: Int = 30, completion: @escaping (Error?) -> Void) {
        resolveDefaultConfigPathIfNeeded()
        loadOrCreateVpnManager { [weak self] manager, error in
            guard let self = self, let manager = manager else {
                completion(
                    error ?? NSError(
                        domain: "VpnServiceHandler",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "VPN Manager unavailable"]
                    )
                )
                return
            }

            manager.isEnabled = true
            let proto = (manager.protocolConfiguration as? NETunnelProviderProtocol) ?? NETunnelProviderProtocol()
            proto.providerBundleIdentifier = self.bundleIdentifier
            proto.serverAddress = self.uiServerAddress
            proto.providerConfiguration = [
                "sharedConfigPath": self.configFilePath
            ]
            manager.protocolConfiguration = proto
            manager.localizedDescription = self.uiLocalizedDescription

            manager.saveToPreferences { saveErr in
                if let saveErr = saveErr {
                    completion(saveErr)
                    return
                }
                manager.loadFromPreferences { loadErr in
                    if let loadErr = loadErr {
                        completion(loadErr)
                        return
                    }
                    do {
                        var startOptions: [String: NSObject] = [:]
                        if !self.configFilePath.isEmpty {
                            startOptions["sharedConfigPath"] = self.configFilePath as NSString
                        }
                        try manager.connection.startVPNTunnel(options: startOptions.isEmpty ? nil : startOptions)
                        completion(nil)
                    } catch {
                        completion(error)
                    }
                }
            }
        }
    }

    public func stop(completion: @escaping (Error?) -> Void) {
        loadVpnManager { manager in
            guard let manager = manager else {
                completion(nil)
                return
            }
            manager.connection.stopVPNTunnel()
            completion(nil)
        }
    }

    private func loadVpnManager(completion: @escaping (NETunnelProviderManager?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, _ in
            let manager = managers?.first {
                ($0.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier == self?.bundleIdentifier
            }
            self?.vpnManager = manager
            completion(manager)
        }
    }

    private func loadOrCreateVpnManager(completion: @escaping (NETunnelProviderManager?, Error?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let self = self else {
                completion(nil, nil)
                return
            }
            let manager = managers?.first {
                ($0.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier == self.bundleIdentifier
            } ?? NETunnelProviderManager()
            self.vpnManager = manager
            completion(manager, nil)
        }
    }
}
