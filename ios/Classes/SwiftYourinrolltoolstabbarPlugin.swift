import Flutter
import UIKit

public class SwiftYourinrolltoolstabbarPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "yourinrolltoolstabbar", binaryMessenger: registrar.messenger())
    let instance = SwiftYourinrolltoolstabbarPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
