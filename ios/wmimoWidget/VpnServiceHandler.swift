import Foundation
import NetworkExtension
import os.log

public final class VpnServiceHandler {
    public static let shared = VpnServiceHandler()
    
    public var controlKind: String = ""
    public var bundleIdentifier: String = "com.wmimo.app.wmimoService"
    public var configFilePath: String = ""
    public var uiServerAddress: String = "Wmimo"
    public var uiLocalizedDescription: String = "Wmimo"
    
    private var vpnManager: NETunnelProviderManager?
    private let log = OSLog(subsystem: "com.wmimo.app.wmimoWidget", category: "VpnServiceHandler")
    
    private init() {}
    
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
        loadOrCreateVpnManager { [weak self] manager, error in
            guard let self = self, let manager = manager else {
                completion(error ?? NSError(domain: "VpnServiceHandler", code: -1, userInfo: [NSLocalizedDescriptionKey: "VPN Manager unavailable"]))
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
                        try manager.connection.startVPNTunnel()
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
        if let existing = self.vpnManager {
            completion(existing)
            return
        }
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, _ in
            let manager = managers?.first { ($0.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier == self?.bundleIdentifier }
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
            let manager = managers?.first { ($0.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier == self.bundleIdentifier } ?? NETunnelProviderManager()
            self.vpnManager = manager
            completion(manager, nil)
        }
    }
}
