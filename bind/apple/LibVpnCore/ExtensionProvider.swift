import Foundation
import NetworkExtension
import os.log

@_silgen_name("LibclashStart")
func LibclashStart(_ homeDir: NSString, _ configPath: NSString) -> NSString?

@_silgen_name("LibclashStop")
func LibclashStop()

@_silgen_name("LibclashIsRunning")
func LibclashIsRunning() -> Bool

@_silgen_name("LibclashGetTraffic")
func LibclashGetTraffic(_ up: UnsafeMutablePointer<Int64>, _ down: UnsafeMutablePointer<Int64>)

open class ExtensionProvider: NEPacketTunnelProvider {
    private let log = OSLog(subsystem: "com.wmimo.app.wmimoService", category: "ExtensionProvider")
    private let platformHelper = DefaultExtensionPlatform()
    private var isTunnelActive = false
    private var trafficTimer: Timer?
    
    open override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        os_log("ExtensionProvider: startTunnel invoked", log: log, type: .info)
        
        let providerConfig = (self.protocolConfiguration as? NETunnelProviderProtocol)?.providerConfiguration
        
        var mixedPort = 7890
        if let port = options?["mixedPort"] as? Int {
            mixedPort = port
        } else if let portStr = options?["mixedPort"] as? String, let port = Int(portStr) {
            mixedPort = port
        } else if let port = providerConfig?["mixedPort"] as? Int {
            mixedPort = port
        }
        
        var configPath = ""
        if let path = options?["sharedConfigPath"] as? String {
            configPath = path
        } else if let path = providerConfig?["sharedConfigPath"] as? String {
            configPath = path
        }
        
        let appGroupId = "group.com.wmimo.app"
        let groupUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
        let homeDir = groupUrl?.path ?? NSTemporaryDirectory()
        
        if configPath.isEmpty, let groupUrl = groupUrl {
            let defaultFile = groupUrl.appendingPathComponent("config.json").path
            if FileManager.default.fileExists(atPath: defaultFile) {
                configPath = defaultFile
            }
        }
        
        os_log("ExtensionProvider: Starting with mixedPort: %{public}d, config: %{public}@", log: log, type: .info, mixedPort, configPath)
        
        // 1. Configure network settings
        let tunnelSettings = platformHelper.setupTunnelNetworkSettings(tunnelRemoteAddress: "198.18.0.1", mtu: 1500)
        platformHelper.configureDns(settings: tunnelSettings, servers: ["198.18.0.2", "1.1.1.1", "8.8.8.8"])
        platformHelper.configureProxy(settings: tunnelSettings, host: "127.0.0.1", port: mixedPort)
        
        setTunnelNetworkSettings(tunnelSettings) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                os_log("Failed to set tunnel network settings: %{public}@", log: self.log, type: .error, error.localizedDescription)
                LibVpnCore.shared.updateState(.error)
                completionHandler(error)
                return
            }
            
            os_log("Tunnel network settings applied successfully", log: self.log, type: .info)
            self.isTunnelActive = true
            LibVpnCore.shared.updateState(.connected)
            
            // 2. Start core bridge if config is available
            if !configPath.isEmpty {
                let err = LibclashStart(homeDir as NSString, configPath as NSString)
                if let err = err {
                    os_log("LibclashStart returned warning: %{public}@", log: self.log, type: .error, err as String)
                } else {
                    os_log("Libclash core started successfully", log: self.log, type: .info)
                }
            }
            
            // 3. Start packet read flow
            self.startPacketFlow()
            
            // 4. Start traffic monitoring
            self.startTrafficMonitor()
            
            completionHandler(nil)
        }
    }
    
    private func startPacketFlow() {
        guard isTunnelActive else { return }
        packetFlow.readPackets { [weak self] (packets, protocols) in
            guard let self = self, self.isTunnelActive else { return }
            // Keep packet flow reading active
            self.startPacketFlow()
        }
    }
    
    private func startTrafficMonitor() {
        DispatchQueue.main.async { [weak self] in
            self?.trafficTimer?.invalidate()
            self?.trafficTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self, self.isTunnelActive else { return }
                var up: Int64 = 0
                var down: Int64 = 0
                LibclashGetTraffic(&up, &down)
                LibVpnCore.shared.updateTraffic(up: up, down: down)
            }
        }
    }
    
    open override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        os_log("ExtensionProvider: stopTunnel invoked with reason: %{public}ld", log: log, type: .info, reason.rawValue)
        isTunnelActive = false
        
        DispatchQueue.main.async { [weak self] in
            self?.trafficTimer?.invalidate()
            self?.trafficTimer = nil
        }
        
        LibclashStop()
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

