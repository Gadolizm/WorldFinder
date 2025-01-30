//
//  CountryViewModel+CLLocationManagerDelegate+extension.swift
//  WorldFinder
//
//  Created by Haitham Gado on 29/01/2025.
//

import CoreLocation


extension CountryViewModel: CLLocationManagerDelegate {
    
    /// CLLocationManagerDelegate: Handles location updates.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        reverseGeocode(location)
        manager.stopUpdatingLocation()
    }
    
    /// Set up CLLocationManager for location access.
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }

    /// Start fetching the user's location.
    func fetchUserLocation() {
        locationManager?.startUpdatingLocation()
    }

    /// Reverse geocode location to find the country.
    private func reverseGeocode(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self, error == nil, let countryName = placemarks?.first?.country else {
                self?.setDefaultCountry()
                return
            }
            self.addCountryByName(countryName)
        }
    }
    
    /// Handle location access denial.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            setDefaultCountry()
        }
    }
}
