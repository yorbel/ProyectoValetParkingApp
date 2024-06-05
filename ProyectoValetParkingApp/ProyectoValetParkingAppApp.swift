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
    
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in 

            // if granted {

            //     print("PERMITIDO NOTIFICACIONES")

            
            // }

            if let error = error {

                print("ERROR PERMISO: \(error.localizedDescription)")

            } else {

                DispatchQueue.main.async {

                    application.registerForRemoteNotifications()

                }

            }
        
        }
        

        Messaging.messaging().delegate = self

        // application.registerForRemoteNotifications()

        Messaging.messaging().subscribe(toTopic: "lugar8888"){ error in

            if error == nil {

                print("SI SUSCRITO A LUGAR8888")
            }
            else{

                print("NO SUSCRITO A LUGAR8888")

            }
        }

        FirebaseApp.configure()

        return true
      
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEVICE TOKEN")
        print(deviceToken)
        // Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("ERROR NOTIFICACIONES REMOTAS: \(error.localizedDescription)")
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
