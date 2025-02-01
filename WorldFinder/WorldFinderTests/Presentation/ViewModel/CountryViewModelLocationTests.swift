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
    var mockGetCountriesUseCase: MockGetCountriesUseCase!
    var mockManageLocalCountriesUseCase: MockManageLocalCountriesUseCase!
    
    
    override func setUp() {
        super.setUp()
        mockGetCountriesUseCase = MockGetCountriesUseCase()
        mockManageLocalCountriesUseCase = MockManageLocalCountriesUseCase()
        viewModel = CountryViewModel(
            getCountriesUseCase: mockGetCountriesUseCase,
            manageLocalCountriesUseCase: mockManageLocalCountriesUseCase
        )
        mockLocationManager = MockCLLocationManager()
        viewModel.locationManager = mockLocationManager  // Inject mock location manager
        mockLocationManager.delegate = viewModel
    }
    
    override func tearDown() {
        viewModel = nil
        mockLocationManager = nil
        mockGetCountriesUseCase = nil
        mockManageLocalCountriesUseCase = nil
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
    
    func testLocationAccessDenied() {
        let expectation = self.expectation(description: "Should set default country when location is denied")

        // ✅ Use real CLLocationManager (or ensure MockLocationManager properly triggers the delegate)
        viewModel.locationManager = mockLocationManager

        // ✅ Simulate denied location access
        mockLocationManager.simulateAuthorization(status: .denied)

        // ✅ Wait for `selectedCountries` update
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("🟢 selectedCountries after denial: \(self.viewModel.selectedCountries.map { $0.name })")

            // ✅ Verify that the default country "Egypt" is set
            XCTAssertFalse(self.viewModel.selectedCountries.isEmpty, "❌ selectedCountries should not be empty")
            XCTAssertEqual(self.viewModel.selectedCountries.first?.name, "Egypt", "❌ Expected 'Egypt' but got \(String(describing: self.viewModel.selectedCountries.first?.name))")

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
}
