//
//  MockCLLocationManager.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import CoreLocation

class MockCLLocationManager: CLLocationManager {
    var mockDelegate: CLLocationManagerDelegate?

    override var delegate: CLLocationManagerDelegate? {
        didSet {
            mockDelegate = delegate
        }
    }

    func simulateLocationUpdate(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        mockDelegate?.locationManager?(self, didUpdateLocations: [location])
    }

    func simulateAuthorization(status: CLAuthorizationStatus) {
        mockDelegate?.locationManager?(self, didChangeAuthorization: status)
    }
}
