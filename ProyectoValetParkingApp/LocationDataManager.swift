//
//  LocationDataManager.swift
//  ProyectoValetParkingApp
//
//  Created by admin on 2/22/24.
//

import Foundation
import CoreLocation

class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var latitud: Double?
    @Published var longitud: Double?
    @Published var establecio = false
   
    override init() {
        super.init()
        locationManager.delegate = self
    }
   
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
           
        case .restricted:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .restricted
            break
           
        case .denied:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .denied
            break
           
        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
           
        default:
            break
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let ubicacion :CLLocation = locations[0]
        latitud = ubicacion.coordinate.latitude
        longitud = ubicacion.coordinate.longitude
        establecio = true
    }
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
   
   
}

