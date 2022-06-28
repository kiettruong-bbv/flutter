import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if let path = Bundle.main.url(forResource: "Info", withExtension: "plist"),
           let dict = NSDictionary(contentsOf: path) as? [String: Any] {
            
            let googleApiKey = dict["GOOGLE_API_KEY"] as? String
            GMSServices.provideAPIKey(googleApiKey ?? "")
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
