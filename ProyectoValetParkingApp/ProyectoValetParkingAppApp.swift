//
//  ProyectoValetParkingAppApp.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 1/29/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    FirebaseApp.configure()

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
