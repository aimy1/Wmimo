import Foundation
import NetworkExtension

public protocol ExtensionPlatformInterface {
    func setupTunnelNetworkSettings(tunnelRemoteAddress: String, mtu: Int) -> NEPacketTunnelNetworkSettings
    func configureRoutes(settings: NEPacketTunnelNetworkSettings, routes: [String])
    func configureDns(settings: NEPacketTunnelNetworkSettings, servers: [String])
    func configureProxy(settings: NEPacketTunnelNetworkSettings, host: String, port: Int)
}

public class DefaultExtensionPlatform: ExtensionPlatformInterface {
    public init() {}
    
    public func setupTunnelNetworkSettings(tunnelRemoteAddress: String = "198.18.0.1", mtu: Int = 9000) -> NEPacketTunnelNetworkSettings {
        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: tunnelRemoteAddress)
        settings.mtu = NSNumber(value: mtu)
        
        let ipv4Settings = NEIPv4Settings(addresses: [tunnelRemoteAddress], subnetMasks: ["255.255.0.0"])
        ipv4Settings.includedRoutes = [NEIPv4Route.default()]
        settings.ipv4Settings = ipv4Settings
        
        return settings
    }
    
    public func configureRoutes(settings: NEPacketTunnelNetworkSettings, routes: [String]) {
        if let ipv4 = settings.ipv4Settings {
            var included: [NEIPv4Route] = []
            for r in routes {
                let parts = r.split(separator: "/")
                if parts.count == 2, let maskInt = Int(parts[1]) {
                    let addr = String(parts[0])
                    let mask = prefixLengthToSubnetMask(prefix: maskInt)
                    included.append(NEIPv4Route(destinationAddress: addr, subnetMask: mask))
                }
            }
            if !included.isEmpty {
                ipv4.includedRoutes = included
            }
        }
    }
    
    public func configureDns(settings: NEPacketTunnelNetworkSettings, servers: [String]) {
        let dns = NEDNSSettings(servers: servers.isEmpty ? ["198.18.0.2", "1.1.1.1", "8.8.8.8"] : servers)
        dns.matchDomains = [""]
        settings.dnsSettings = dns
    }
    
    public func configureProxy(settings: NEPacketTunnelNetworkSettings, host: String = "127.0.0.1", port: Int = 7890) {
        let proxySettings = NEProxySettings()
        proxySettings.httpServer = NEProxyServer(address: host, port: port)
        proxySettings.httpsServer = NEProxyServer(address: host, port: port)
        proxySettings.autoProxyConfigurationEnabled = false
        proxySettings.matchDomains = [""]
        proxySettings.exceptionList = [
            "localhost",
            "127.0.0.1",
            "192.168.0.0/16",
            "10.0.0.0/8",
            "172.16.0.0/12",
            "*.local"
        ]
        settings.proxySettings = proxySettings
    }
    
    private func prefixLengthToSubnetMask(prefix: Int) -> String {
        let mask = (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF
        return "\((mask >> 24) & 0xFF).\((mask >> 16) & 0xFF).\((mask >> 8) & 0xFF).\(mask & 0xFF)"
    }
}
