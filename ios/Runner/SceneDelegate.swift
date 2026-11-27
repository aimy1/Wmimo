import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    if let url = connectionOptions.urlContexts.first?.url {
      AppDelegate.sharedInstance?.handleIncomingWidgetUrl(url, dispatchImmediately: false)
    }
    super.scene(scene, willConnectTo: session, options: connectionOptions)
  }

  override func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {
    if let url = URLContexts.first?.url {
      AppDelegate.sharedInstance?.handleIncomingWidgetUrl(url, dispatchImmediately: true)
    }
    super.scene(scene, openURLContexts: URLContexts)
  }
}
