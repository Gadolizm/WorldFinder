//
//  MockCLLocationManager.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import CoreLocation
import XCTest


class MockCLLocationManager: CLLocationManager {
    var mockDelegate: CLLocationManagerDelegate?
    private var fakeAuthorizationStatus: CLAuthorizationStatus = .notDetermined


    override var delegate: CLLocationManagerDelegate? {
        get { return mockDelegate }
        set { mockDelegate = newValue }
    }

    func simulateLocationUpdate(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        mockDelegate?.locationManager?(self, didUpdateLocations: [location])
    }
    
    override var authorizationStatus: CLAuthorizationStatus {
        return fakeAuthorizationStatus
    }

    func simulateAuthorization(status: CLAuthorizationStatus) {
        print("🟡 Simulating authorization status: \(status.rawValue) (\(status))")
        
        fakeAuthorizationStatus = status  // ✅ Store the fake status

        DispatchQueue.main.async {
            if #available(iOS 14.0, *) {
                self.delegate?.locationManagerDidChangeAuthorization?(self)
            } else {
                self.delegate?.locationManager?(self, didChangeAuthorization: status)
            }
        }
    }
}

