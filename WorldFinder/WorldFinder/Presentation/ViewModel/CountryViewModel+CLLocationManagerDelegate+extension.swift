//
//  CountryViewModel+CLLocationManagerDelegate+extension.swift
//  WorldFinder
//
//  Created by Haitham Gado on 29/01/2025.
//

import CoreLocation

extension CountryViewModel: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }

    func fetchUserLocation() {
        guard CLLocationManager.locationServicesEnabled() else { return setDefaultCountry() }
        locationManager?.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        reverseGeocode(location)
    }

    private func reverseGeocode(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            self?.addCountryByName(placemarks?.first?.country ?? self?.defaultCountry.name ?? "Egypt")
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthorizationStatus(manager.authorizationStatus)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthorizationStatus(status)
    }

//    private func handleAuthorization(_ status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse || status == .authorizedAlways {
//            fetchUserLocation()
//        } else {
//            setDefaultCountry()
//        }
//    }
    
    /// Handles different authorization statuses
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        print("🟢 Received authorization status: \(status)")

        switch status {
        case .notDetermined:
            print("ℹ️ Location permission not determined yet.")
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location access granted. Fetching location...")
            fetchUserLocation()
        case .denied, .restricted:
            print("❌ Location access denied/restricted. Calling setDefaultCountry().")
            setDefaultCountry()
        @unknown default:
            print("⚠️ Unknown location authorization status.")
            setDefaultCountry()
        }
    }
}

