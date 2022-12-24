//
//  Location.swift
//  Weather-SwiftUI
//
//  Created by Jingwen Shi on 2022-12-23.
//

import Foundation
import CoreLocation


internal class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // Location-related properties and delegate methods.
    private var locationManager: CLLocationManager?
    var locationService: Bool?
    var loading: Bool?
    var location: CLLocationCoordinate2D?

    internal func isSystemLocationServiceEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager = CLLocationManager()
            // Start listening to location service setting changes in ios system
            self.locationManager?.delegate = self
            self.locationService = true
        }
        else {
            self.locationService = false
        }
    }
    
    private func gainLocationAutherationStatus() {
        guard let manager = self.locationManager else {return}
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Please ghange the location setting to allow access of your current location.")
        case .denied:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            fatalError()
        }
    }
    
    // When location service setting changes, execuates the following...
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        gainLocationAutherationStatus()
        manager.startUpdatingLocation()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        print("locations = \(location.latitude) \(location.longitude)")
    }
    
}
