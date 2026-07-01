#if canImport(FirebaseCore)
import FirebaseCore
#endif
import Flutter
#if canImport(GoogleMaps)
import GoogleMaps
#endif
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
#if canImport(FirebaseCore)
    FirebaseApp.configure()
#else
    // FirebaseCore not available; skip configuration to allow build without Firebase.
#endif
    // Google Maps native SDK key (iOS), Google Cloud project dwelleo-60f38.
    // Restrict to the app's bundle id in the console before release.
#if canImport(GoogleMaps)
    GMSServices.provideAPIKey("AIzaSyBOGg7aefYtU8t5GLQWxcEJPjYzYRgWxJo")
#else
    // GoogleMaps not available; skip API key configuration to allow build without Google Maps.
#endif
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}

