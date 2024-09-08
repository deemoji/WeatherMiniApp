//
//  LocationManager.swift
//  
//
//  Created by Дмитрий Мартьянов on 08.09.2024.
//

import CoreLocation

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var onLocationUpdate: ((CLLocation) -> Void)?
    var onAuthorizationStatusChange: ((CLAuthorizationStatus) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        checkAuthorizationStatus()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    private func checkAuthorizationStatus() {
        let status = CLLocationManager.authorizationStatus()
        handleAuthorizationStatus(status)
    }

    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            break
        @unknown default:
            fatalError("Unknown authorization status")
        }
        onAuthorizationStatusChange?(status)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthorizationStatus(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            onLocationUpdate?(location)
        }
    }
}

