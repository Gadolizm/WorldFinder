//
//  CountryViewModelLocationTests.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import XCTest
import CoreLocation
@testable import WorldFinder

class CountryViewModelLocationTests: XCTestCase {
    var viewModel: CountryViewModel!
    var mockLocationManager: MockCLLocationManager!
    var mockUseCase: MockGetCountriesUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockGetCountriesUseCase()
        viewModel = CountryViewModel(getCountriesUseCase: mockUseCase)
        mockLocationManager = MockCLLocationManager()
        viewModel.locationManager = mockLocationManager  // Inject mock location manager
        mockLocationManager.delegate = viewModel
    }

    override func tearDown() {
        viewModel = nil
        mockLocationManager = nil
        mockUseCase = nil
        super.tearDown()
    }

    // ✅ Test: Fetching User Location Successfully
    func testFetchUserLocation_Success() {
        // Given: Mock location (New York, USA)
        let expectation = self.expectation(description: "User location should be fetched")

        // When: Simulating a location update
        mockLocationManager.simulateLocationUpdate(latitude: 40.7128, longitude: -74.0060)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Then: Verify if a country was added
            XCTAssertFalse(self.viewModel.selectedCountries.isEmpty, "❌ Expected a country to be added, but got empty list.")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    // ❌ Test: Location Access Denied (Should Set Default Country)
    func testLocationAccessDenied() {
        // Given: Simulate location access denied
        let expectation = self.expectation(description: "Should set default country when location is denied")

        // When: Simulating denied location access
        mockLocationManager.simulateAuthorization(status: .denied)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Then: Verify that the default country is set
            XCTAssertEqual(self.viewModel.selectedCountries.first?.name, "Egypt", "❌ Expected default country 'Egypt' but got \(String(describing: self.viewModel.selectedCountries.first?.name))")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
}
