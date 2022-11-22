import CoreLocation
import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import PhotosUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let tokenManager: TokenManager = KeychainTokenManager()
    private var locationManager: CLLocationManager?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        self.requestNotificationAuthorization()
        self.requestLocationAuthorization()
        self.requestPhotoAuthorization()
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else {
            Logger.print("fcm token not exists.")
            return
        }
        tokenManager.save(token: fcmToken, with: .fcmToken)
        Logger.print(fcmToken)
    }
}

// MARK: - Notification
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .badge, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

// MARK: - CoreLocation
extension AppDelegate: CLLocationManagerDelegate {
    func requestLocationAuthorization() {
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .authorized:
            print("authorized")
        @unknown default:
            fatalError()
        }
        print(status.rawValue)
    }
}

// MARK: - Photo
extension AppDelegate {
    func requestPhotoAuthorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            Logger.print(status)
        }
    }
}
