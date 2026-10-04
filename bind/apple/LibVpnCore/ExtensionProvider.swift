import Foundation
import NetworkExtension
import os.log

open class ExtensionProvider: NEPacketTunnelProvider {
    private let log = OSLog(subsystem: "com.wmimo.app.wmimoService", category: "ExtensionProvider")
    private let platformHelper = DefaultExtensionPlatform()
    
    open override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        os_log("ExtensionProvider: startTunnel invoked", log: log, type: .info)
        
        let tunnelSettings = platformHelper.setupTunnelNetworkSettings(tunnelRemoteAddress: "198.18.0.1", mtu: 9000)
        platformHelper.configureDns(settings: tunnelSettings, servers: ["198.18.0.2", "1.1.1.1", "8.8.8.8"])
        
        setTunnelNetworkSettings(tunnelSettings) { [weak self] error in
            if let error = error {
                os_log("Failed to set tunnel network settings: %{public}@", log: self?.log ?? .default, type: .error, error.localizedDescription)
                LibVpnCore.shared.updateState(.error)
                completionHandler(error)
                return
            }
            
            os_log("Tunnel network settings applied successfully", log: self?.log ?? .default, type: .info)
            LibVpnCore.shared.updateState(.connected)
            completionHandler(nil)
        }
    }
    
    open override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        os_log("ExtensionProvider: stopTunnel invoked with reason: %{public}ld", log: log, type: .info, reason.rawValue)
        LibVpnCore.shared.updateState(.disconnected)
        completionHandler()
    }
    
    open override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        guard let message = String(data: messageData, encoding: .utf8) else {
            completionHandler?(nil)
            return
        }
        
        if message == "status" {
            let resp = LibVpnCore.shared.currentState.rawValue
            completionHandler?(resp.data(using: .utf8))
        } else {
            completionHandler?(nil)
        }
    }
    
    open override func sleep(completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    open override func wake() {
    }
}
