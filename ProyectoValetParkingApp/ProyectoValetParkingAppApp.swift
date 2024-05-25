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
    
        application.registerForRemoteNotifications()

        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in 

            if granted {

                print("PERMITIDO NOTIFICACIONES")

                // DispatchQueue.main.async {
                //     application.shared.registerForRemoteNotifications()
                // }
            }
        
        }
        

        Messaging.messaging().delegate = self

        Messaging.messaging().subscribe(toTopic: "lugar8888"){ error in

            if error == nil {

                print("SI SUSCRITO A LUGAR8888")
            }
            else{

                print("NO SUSCRITO A LUGAR8888")

            }
        }

        return true
      
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        // Messaging.messaging().apnsToken = deviceToken
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
