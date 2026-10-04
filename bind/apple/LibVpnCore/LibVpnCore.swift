import Foundation

public enum LibVpnCoreState: String {
    case disconnected = "disconnected"
    case connecting = "connecting"
    case connected = "connected"
    case disconnecting = "disconnecting"
    case error = "error"
}

public protocol LibVpnCoreDelegate: AnyObject {
    func onStateChanged(state: LibVpnCoreState)
    func onTrafficUpdate(up: Int64, down: Int64)
}

public final class LibVpnCore {
    public static let shared = LibVpnCore()
    public weak var delegate: LibVpnCoreDelegate?
    
    public private(set) var currentState: LibVpnCoreState = .disconnected
    
    private init() {}
    
    public func updateState(_ newState: LibVpnCoreState) {
        self.currentState = newState
        self.delegate?.onStateChanged(state: newState)
    }
    
    public func updateTraffic(up: Int64, down: Int64) {
        self.delegate?.onTrafficUpdate(up: up, down: down)
    }
}
