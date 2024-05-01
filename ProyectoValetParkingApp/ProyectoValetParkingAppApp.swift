//
//  ProyectoValetParkingAppApp.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 1/29/24.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate  {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in 

            if granted {

                // print("PERMITIDO NOTIFICACIONES")

                // DispatchQueue.main.async {
                //     application.shared.registerForRemoteNotifications()
                // }
            }
        
        }
        
        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self

        return true
      
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            print("fcm", fcm)
        }
    }
    
}

@main
struct ProyectoValetParkingAppApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            IngresarView()
        }
    }
}
