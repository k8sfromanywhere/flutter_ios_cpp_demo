import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "com.example.ios_app/native_hello"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { [weak self] call, result in
        guard call.method == "writeHello" else {
          result(FlutterMethodNotImplemented)
          return
        }

        guard
          let arguments = call.arguments as? [String: Any],
          let count = arguments["count"] as? Int
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "Parameter 'count' is missing", details: nil))
          return
        }

        self?.handleWriteHello(count: count, result: result)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func handleWriteHello(count: Int, result: @escaping FlutterResult) {
    guard
      let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    else {
      result(FlutterError(code: "NO_DOCUMENTS", message: "Failed to locate documents directory", details: nil))
      return
    }

    let fileURL = documentsURL.appendingPathComponent("hello.txt")

    if let contents = HelloWriterBridge.writeHello(withCount: count, toPath: fileURL.path, append: true) {
      result(contents)
    } else {
      result(FlutterError(code: "WRITE_FAILED", message: "Native writer returned empty response", details: nil))
    }
  }
}
