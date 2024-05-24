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


class AppDelegate: NSObject, UIApplicationDelegate  {
    
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

        return true
      
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
