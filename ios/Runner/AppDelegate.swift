import Flutter
import UIKit
import NetworkExtension
import os.log

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let CHANNEL = "com.wmimo.app/native_helper"
  private let appGroupId = "group.com.wmimo.app"
  private let tunnelBundleId = "com.wmimo.app.wmimoService"
  private var vpnManager: NETunnelProviderManager?
  private let log = OSLog(subsystem: "com.wmimo.app", category: "AppDelegate")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as? FlutterViewController
    if let messenger = controller?.binaryMessenger {
      setupNativeHelperChannel(messenger: messenger)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "WmimoNativeHelper") {
      setupNativeHelperChannel(messenger: registrar.messenger())
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
