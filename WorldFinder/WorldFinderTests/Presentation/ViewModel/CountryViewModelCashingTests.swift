//
//  CountryViewModelCashingTests.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import XCTest
import Combine
@testable import WorldFinder


class CountryViewModelCashingTests: XCTestCase {
    
    var viewModel: CountryViewModel!
    var mockManageLocalCountriesUseCase: MockManageLocalCountriesUseCase!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockManageLocalCountriesUseCase = MockManageLocalCountriesUseCase()
        viewModel = CountryViewModel(
            getCountriesUseCase: MockGetCountriesUseCase(),
            manageLocalCountriesUseCase: mockManageLocalCountriesUseCase
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockManageLocalCountriesUseCase = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    // ✅ Test: saveCountries() calls the use case correctly
    func testSaveCountries() {
        let countries = [Country.sample]
        viewModel.countries = countries
        
        viewModel.saveCountries()
        
        XCTAssertEqual(mockManageLocalCountriesUseCase.savedCountries, countries, "❌ Expected countries to be saved correctly.")
    }
    
    // ✅ Test: loadSelectedCountries() fetches correct data
    func testLoadSelectedCountries() {
        let expectation = self.expectation(description: "Load selected countries")
        
        let selectedCountries = [Country.sample]
        mockManageLocalCountriesUseCase.savedSelectedCountries = selectedCountries
        
        viewModel.loadSelectedCountries()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.selectedCountries, selectedCountries, "❌ Expected selected countries to be loaded correctly.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // ✅ Test: saveSelectedCountries() calls use case correctly
    func testSaveSelectedCountries() {
        let selectedCountries = [Country.sample]
        viewModel.selectedCountries = selectedCountries
        
        viewModel.saveSelectedCountries()
        
        XCTAssertEqual(mockManageLocalCountriesUseCase.savedSelectedCountries, selectedCountries, "❌ Expected selected countries to be saved correctly.")
    }
    
    func testClearCache() {
        let expectation = expectation(description: "Cache should be cleared")
        
        // ✅ Set initial data
        viewModel.countries = [Country.sample]
        viewModel.selectedCountries = [Country.sample]
        
        
        // ✅ Observe `selectedCountries` but fulfill only on the first empty state
        viewModel.$selectedCountries
            .dropFirst() // Ignore initial value
            .first(where: { $0.isEmpty }) // ✅ Fulfill expectation only when `selectedCountries` becomes empty
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // ✅ Trigger cache clear
        viewModel.clearCache()
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
