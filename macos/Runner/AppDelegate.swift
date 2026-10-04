import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    // show window when click from dock icon
    override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows {
                 if !window.isVisible {
                    window.setIsVisible(true)
                }
                window.makeKeyAndOrderFront(self)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
        return true
    }

    override func applicationDidFinishLaunching(_ notify: Notification) {
        if let controller = NSApplication.shared.windows.first?.contentViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "com.wmimo.app/native_helper", binaryMessenger: controller.engine.binaryMessenger)
            channel.setMethodCallHandler { (call, result) in
                switch call.method {
                case "getAppGroupDirectory":
                    let groupUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.wmimo.app")
                    result(groupUrl?.path)
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    }

    override func applicationWillTerminate(_ notify: Notification) {
    }

    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
