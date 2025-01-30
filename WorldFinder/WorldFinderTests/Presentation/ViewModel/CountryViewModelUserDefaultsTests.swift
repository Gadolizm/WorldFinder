//
//  CountryViewModelUserDefaultsTests.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import XCTest
import Combine
@testable import WorldFinder

class CountryViewModelUserDefaultsTests: XCTestCase {
    var viewModel: CountryViewModel!
    var mockUserDefaults: MockUserDefaults!
    var mockUseCase: MockGetCountriesUseCase!

    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        mockUseCase = MockGetCountriesUseCase()
        viewModel = CountryViewModel(getCountriesUseCase: mockUseCase, userDefaults: mockUserDefaults)
        mockUserDefaults.storage.removeAll()
    }

    override func tearDown() {
        viewModel = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    func testSaveAndLoadCountries() {
        let mockCountries = [
            Country(
                name: "United States",
                topLevelDomain: [".us"],
                alpha2Code: "US",
                alpha3Code: "USA",
                callingCodes: ["1"],
                capital: "Washington, D.C.",
                altSpellings: ["US", "USA"],
                subregion: "North America",
                region: "Americas",
                population: 331000000,
                latlng: [37.0902, -95.7129],
                demonym: "American",
                area: 9833517.0,
                timezones: ["UTC−12:00"],
                borders: ["CAN", "MEX"],
                nativeName: "United States",
                numericCode: "1",
                flags: Country.Flag(svg: "", png: ""),
                currencies: [],
                languages: [],
                translations: [:],
                flag: "",
                regionalBlocs: [],
                cioc: nil,
                independent: true
            )
        ]

        // Save data
        viewModel.countries = mockCountries
        viewModel.saveCountriesToUserDefaults()

        // Clear list before loading to verify correct retrieval
        viewModel.countries = []
        viewModel.loadCountriesFromUserDefaults()

        // ✅ Corrected Assertions
        XCTAssertEqual(viewModel.countries.count, 1, "❌ Expected only 1 country, but got \(viewModel.countries.count)")
        XCTAssertEqual(viewModel.countries.first?.name, "United States", "❌ Expected 'United States', but got '\(viewModel.countries.first?.name ?? "nil")'")
        XCTAssertEqual(viewModel.countries.first?.alpha2Code, "US", "❌ Expected 'US' alpha2Code, but got '\(viewModel.countries.first?.alpha2Code ?? "nil")'")
    }
}
