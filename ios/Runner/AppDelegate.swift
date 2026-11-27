import Flutter
import UIKit
import NetworkExtension
import os.log
#if canImport(WidgetKit)
import WidgetKit
#endif

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  static weak var sharedInstance: AppDelegate?
  private let CHANNEL = "com.wmimo.app/native_helper"
  private let WIDGET_CHANNEL = "com.wmimo.app/widget"
  private let appGroupId = "group.com.wmimo.app"
  private let tunnelBundleId = "com.wmimo.app.wmimoService"
  private var vpnManager: NETunnelProviderManager?
  private var widgetChannel: FlutterMethodChannel?
  private var pendingWidgetUri: String?
  private var lastWidgetReloadTime: TimeInterval = 0
  private let log = OSLog(subsystem: "com.wmimo.app", category: "AppDelegate")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    AppDelegate.sharedInstance = self
    if let launchUrl = launchOptions?[.url] as? URL {
      handleIncomingWidgetUrl(launchUrl, dispatchImmediately: false)
    }
    let controller = window?.rootViewController as? FlutterViewController
    if let messenger = controller?.binaryMessenger {
      setupNativeHelperChannel(messenger: messenger)
      setupWidgetChannel(messenger: messenger)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    handleIncomingWidgetUrl(url, dispatchImmediately: true)
    return super.application(app, open: url, options: options)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "WmimoNativeHelper") {
      setupNativeHelperChannel(messenger: registrar.messenger())
      setupWidgetChannel(messenger: registrar.messenger())
    }
  }

  func handleIncomingWidgetUrl(_ url: URL, dispatchImmediately: Bool) {
    guard url.scheme == "wmimo", url.host == "widget" else { return }
    let uriStr = url.absoluteString
    if dispatchImmediately, let channel = widgetChannel {
      channel.invokeMethod("onWidgetAction", arguments: ["uri": uriStr])
      return
    }
    pendingWidgetUri = uriStr
  }

  private func getOrCreateWidgetToken() -> String {
    let defaults = UserDefaults(suiteName: appGroupId) ?? UserDefaults.standard
    if let existing = defaults.string(forKey: "widget_action_token"), !existing.isEmpty {
      return existing
    }
    let generated = UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
    defaults.set(generated, forKey: "widget_action_token")
    return generated
  }

  private func setupWidgetChannel(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: WIDGET_CHANNEL, binaryMessenger: messenger)
    self.widgetChannel = channel
    channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else {
        result(nil)
        return
      }
      let defaults = UserDefaults(suiteName: self.appGroupId) ?? UserDefaults.standard

      switch call.method {
      case "getWidgetToken":
        result(self.getOrCreateWidgetToken())

      case "syncWidgetSnapshot":
        let args = call.arguments as? [String: Any]
        let snapshot = args?["snapshot"] as? String ?? ""
        let forceReload = args?["forceReload"] as? Bool ?? false

        if !snapshot.isEmpty {
          defaults.set(snapshot, forKey: "widget_snapshot")
          if let groupDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.appGroupId),
             let data = snapshot.data(using: .utf8) {
            let fileUrl = groupDir.appendingPathComponent("widget_snapshot.json", isDirectory: false)
            try? data.write(to: fileUrl, options: .atomic)
          }
        }

        #if canImport(WidgetKit)
        let now = Date().timeIntervalSince1970
        if forceReload || (now - self.lastWidgetReloadTime >= 15.0) {
          self.lastWidgetReloadTime = now
          if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
          }
          if #available(iOS 18.0, *) {
            ControlCenter.shared.reloadAllControls()
          }
        }
        #endif
        result(true)

      case "consumeNativeOverrides":
        var map: [String: Any] = [:]
        if let mode = defaults.string(forKey: "override_mode"), !mode.isEmpty {
          map["mode"] = mode
        }
        if let node = defaults.string(forKey: "override_node"), !node.isEmpty {
          map["currentNode"] = node
        }
        if defaults.bool(forKey: "override_vpn_stopped") {
          map["vpnStopped"] = true
        }
        defaults.removeObject(forKey: "override_mode")
        defaults.removeObject(forKey: "override_node")
        defaults.removeObject(forKey: "override_vpn_stopped")
        result(map)

      case "getPendingWidgetAction":
        if let uriStr = self.pendingWidgetUri, !uriStr.isEmpty {
          self.pendingWidgetUri = nil
          result(["uri": uriStr])
        } else {
          result(nil)
        }

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func setupNativeHelperChannel(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else {
        result(FlutterError(code: "DEALLOCATED", message: "AppDelegate deallocated", details: nil))
        return
      }

      switch call.method {
      case "checkVpnPermission":
        self.loadVpnManager { manager in
          result(manager != nil && manager?.isEnabled == true)
        }

      case "requestVpnPermission":
        self.loadOrCreateVpnManager { manager, error in
          if let error = error {
            result(FlutterError(code: "VPN_PERMISSION_ERROR", message: error.localizedDescription, details: nil))
            return
          }
          result(manager != nil)
        }

      case "startVpnService":
        let args = call.arguments as? [String: Any]
        let mixedPort = args?["mixedPort"] as? Int ?? 7890
        let configPath = args?["configPath"] as? String ?? ""

        self.loadOrCreateVpnManager { manager, error in
          guard let manager = manager else {
            result(FlutterError(code: "VPN_MANAGER_UNAVAILABLE", message: error?.localizedDescription ?? "VPN manager unavailable", details: nil))
            return
          }

          manager.isEnabled = true
          let proto = (manager.protocolConfiguration as? NETunnelProviderProtocol) ?? NETunnelProviderProtocol()
          proto.providerBundleIdentifier = self.tunnelBundleId
          proto.serverAddress = "Wmimo"

          var providerConfig: [String: Any] = ["mixedPort": mixedPort]

          // Sync config file to App Group shared container
          if !configPath.isEmpty, let groupDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.appGroupId) {
            let sharedConfigFile = groupDir.appendingPathComponent("config.json")
            try? FileManager.default.removeItem(at: sharedConfigFile)
            do {
              try FileManager.default.copyItem(atPath: configPath, toPath: sharedConfigFile.path)
              providerConfig["sharedConfigPath"] = sharedConfigFile.path
            } catch {
              os_log("Failed to copy config to App Group: %{public}@", log: self.log, type: .error, error.localizedDescription)
            }
          }

          proto.providerConfiguration = providerConfig
          manager.protocolConfiguration = proto

          manager.saveToPreferences { saveErr in
            if let saveErr = saveErr {
              result(FlutterError(code: "SAVE_FAILED", message: saveErr.localizedDescription, details: nil))
              return
            }

            manager.loadFromPreferences { _ in
              do {
                var startOptions: [String: NSObject] = [
                  "mixedPort": "\(mixedPort)" as NSString
                ]
                if let path = providerConfig["sharedConfigPath"] as? String {
                  startOptions["sharedConfigPath"] = path as NSString
                }
                try manager.connection.startVPNTunnel(options: startOptions)
                result(true)
              } catch {
                result(FlutterError(code: "START_FAILED", message: error.localizedDescription, details: nil))
              }
            }
          }
        }

      case "stopVpnService":
        self.loadVpnManager { manager in
          manager?.connection.stopVPNTunnel()
          result(true)
        }

      case "getVpnStatus":
        self.loadVpnManager { manager in
          guard let status = manager?.connection.status else {
            result("disconnected")
            return
          }
          switch status {
          case .connected: result("connected")
          case .connecting: result("connecting")
          case .disconnecting: result("disconnecting")
          default: result("disconnected")
          }
        }

      case "getAppGroupDirectory":
        if let containerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.appGroupId) {
          result(containerUrl.path)
        } else {
          result(nil)
        }

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func loadVpnManager(completion: @escaping (NETunnelProviderManager?) -> Void) {
    if let existing = self.vpnManager {
      completion(existing)
      return
    }
    NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, _ in
      let manager = managers?.first { ($0.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier == self?.tunnelBundleId }
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

      let manager = managers?.first { ($0.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier == self.tunnelBundleId } ?? NETunnelProviderManager()
      
      let proto = (manager.protocolConfiguration as? NETunnelProviderProtocol) ?? NETunnelProviderProtocol()
      proto.providerBundleIdentifier = self.tunnelBundleId
      proto.serverAddress = "Wmimo"
      manager.protocolConfiguration = proto
      manager.localizedDescription = "Wmimo"
      manager.isEnabled = true

      manager.saveToPreferences { saveError in
        if let saveError = saveError {
          completion(nil, saveError)
        } else {
          manager.loadFromPreferences { _ in
            self.vpnManager = manager
            completion(manager, nil)
          }
        }
      }
    }
  }
}
