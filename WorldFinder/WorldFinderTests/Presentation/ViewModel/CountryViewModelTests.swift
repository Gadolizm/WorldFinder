//
//  CountryViewModelTests.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//
import XCTest
import Combine
@testable import WorldFinder


class CountryViewModelTests: XCTestCase {
    
    var viewModel: CountryViewModel!
    var mockGetCountriesUseCase: MockGetCountriesUseCase!
    var mockManageLocalCountriesUseCase: MockManageLocalCountriesUseCase!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockGetCountriesUseCase = MockGetCountriesUseCase()
        mockManageLocalCountriesUseCase = MockManageLocalCountriesUseCase()
        viewModel = CountryViewModel(
            getCountriesUseCase: mockGetCountriesUseCase,
            manageLocalCountriesUseCase: mockManageLocalCountriesUseCase
        )
    }

    override func tearDown() {
        viewModel = nil
        mockGetCountriesUseCase = nil
        mockManageLocalCountriesUseCase = nil
        cancellables.removeAll()
        super.tearDown()
    }

    // ✅ Test fetching countries successfully
    func testGetCountries_Success() {
        let expectation = self.expectation(description: "Countries fetched successfully")
        mockGetCountriesUseCase.result = .success([Country.sample])

        viewModel.getCountries()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(self.viewModel.countries.isEmpty)
            XCTAssertEqual(self.viewModel.countries.first?.name, "France")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }

    // ✅ Test fetching countries failure
    func testGetCountries_Failure() {
        let expectation = self.expectation(description: "Countries fetch failed")
        mockGetCountriesUseCase.result = .failure(NetworkError.cacheNotFound)

        viewModel.getCountries()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertTrue(self.viewModel.countries.isEmpty, "Expected countries to be empty on failure")
            XCTAssertEqual(self.viewModel.errorMessage?.message, "No cached data found.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }

    // ✅ Test adding a country successfully
    func testAddCountry_Success() {
        viewModel.addCountry(Country.sample)
        XCTAssertEqual(viewModel.selectedCountries.count, 1)
        XCTAssertEqual(viewModel.selectedCountries.first?.name, "France")
    }

    // ✅ Test preventing duplicate countries
    func testAddCountry_Duplicate() {
        viewModel.addCountry(Country.sample)
        viewModel.addCountry(Country.sample) // Trying to add the same country again
        
        XCTAssertEqual(viewModel.selectedCountries.count, 1)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage?.message, "France is already in the selected list.")
    }

    // ✅ Test maximum countries limit
    func testAddCountry_LimitExceeded() {
        let countries = [
            Country.sample,
            Country.defaultCountry,
            Country.germany,
            Country.spain,
            Country.italy
        ]
        
        for country in countries {
            viewModel.addCountry(country)
        }
        
        let ksa = Country.ksa
        
        viewModel.addCountry(ksa) // ✅ This should be rejected
        
        XCTAssertEqual(viewModel.selectedCountries.count, 5, "Should not exceed 5 countries")
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage?.message, "You can only add up to 5 countries.")
    }

    // ✅ Test removing a country
    func testRemoveCountry() {
        viewModel.addCountry(Country.sample)
        XCTAssertEqual(viewModel.selectedCountries.count, 1)
        
        viewModel.removeCountry(at: IndexSet(integer: 0))
        XCTAssertEqual(viewModel.selectedCountries.count, 0)
    }

    // ✅ Test adding a country by name
    func testAddCountryByName() {
        viewModel.countries = [Country.sample]
        viewModel.addCountryByName("France")
        
        XCTAssertEqual(viewModel.selectedCountries.count, 1)
        XCTAssertEqual(viewModel.selectedCountries.first?.name, "France")
    }

    // ✅ Test setting default country
    func testSetDefaultCountry() {
        viewModel.setDefaultCountry()
        XCTAssertEqual(viewModel.selectedCountries.count, 1)
        XCTAssertEqual(viewModel.selectedCountries.first?.name, "Egypt")
    }
}


//class CountryViewModelTests: XCTestCase {
//    var viewModel: CountryViewModel!
//    var mockUseCase: MockGetCountriesUseCase!
//    var cancellables: Set<AnyCancellable> = []
//    
//    override func setUp() {
//        super.setUp()
//        mockUseCase = MockGetCountriesUseCase()
//        viewModel = CountryViewModel(getCountriesUseCase: mockUseCase)
//        viewModel.selectedCountries = []
//        viewModel.countries.removeAll()
//    }
//    
//    override func tearDown() {
//        viewModel = nil
//        mockUseCase = nil
//        cancellables.removeAll()
//        super.tearDown()
//    }
//    
//    // ✅ Test: Fetch Countries Successfully
//    func testFetchCountries_Success() {
//        // Given: Mock successful country list
//        let mockCountries = [
//            Country(
//                name: "United States",
//                topLevelDomain: [".us"],
//                alpha2Code: "US",
//                alpha3Code: "USA",
//                callingCodes: ["1"],
//                capital: "Washington, D.C.",
//                altSpellings: ["US", "USA"],
//                subregion: "North America",
//                region: "Americas",
//                population: 331000000,
//                latlng: [37.0902, -95.7129],
//                demonym: "American",
//                area: 9833517.0,
//                timezones: ["UTC−12:00", "UTC−11:00", "UTC−10:00"],
//                borders: ["CAN", "MEX"],
//                nativeName: "United States",
//                numericCode: "840",
//                flags: Country.Flag(svg: "https://flagcdn.com/us.svg", png: "https://flagcdn.com/w320/us.png"),
//                currencies: [Country.Currency(code: "USD", name: "United States Dollar", symbol: "$")],
//                languages: [Country.Language(iso639_1: "en", iso639_2: "eng", name: "English", nativeName: "English")],
//                translations: ["de": "Vereinigte Staaten", "es": "Estados Unidos"],
//                flag: "https://flagcdn.com/us.svg",
//                regionalBlocs: [Country.RegionalBloc(acronym: "NAFTA", name: "North American Free Trade Agreement")],
//                cioc: "USA",
//                independent: true
//            )
//        ]
//        
//        mockUseCase.result = .success(mockCountries)
//        let expectation = self.expectation(description: "Fetching countries should be successful")
//        
//        // When
//        viewModel.fetchCountries()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            // Then
//            XCTAssertEqual(self.viewModel.countries.count, 1)
//            XCTAssertEqual(self.viewModel.countries[0].name, "United States")
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 2, handler: nil)
//    }
//    
//    // ❌ Test: Fetch Countries Failure
//    func testFetchCountries_Failure() {
//        // Given: Mock API error
//        mockUseCase.result = .failure(URLError(.notConnectedToInternet))
//        let expectation = self.expectation(description: "Fetching countries should fail")
//        
//        // When
//        viewModel.fetchCountries()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            // Then
//            XCTAssertNotNil(self.viewModel.errorMessage)
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 2, handler: nil)
//    }
//    
//    // ✅ Test: Adding a Country
//    func testAddCountry_Success() {
//        // Given: A country
//        let mockCountry = Country.sample
//        
//        // When
//        viewModel.addCountry(mockCountry)
//        
//        // Then
//        XCTAssertEqual(viewModel.selectedCountries.count, 1)
//        XCTAssertEqual(viewModel.selectedCountries[0].name, "France")
//    }
//    
//    // ❌ Test: Preventing Duplicate Countries
//    func testAddCountry_Duplicate() {
//        // Given: A country already added
//        let mockCountry = Country.sample
//        viewModel.addCountry(mockCountry)
//        
//        // When
//        viewModel.addCountry(mockCountry)
//        
//        // Then
//        XCTAssertEqual(viewModel.selectedCountries.count, 1, "Duplicate country should not be added")
//    }
//    
//    // ❌ Test: Enforcing a Maximum Limit of 5 Countries
//    func testAddCountry_MaxLimit() {
//        // Given: 5 unique countries
//        for i in 1...5 {
//            let country = Country(
//                name: "Country \(i)",
//                topLevelDomain: [".c\(i)"],
//                alpha2Code: "C\(i)",
//                alpha3Code: "C\(i)3",
//                callingCodes: ["+\(i)"],
//                capital: "Capital \(i)",
//                altSpellings: ["Country-\(i)"],
//                subregion: "Region \(i)",
//                region: "Continent \(i)",
//                population: 100000 * i,
//                latlng: [10.0 * Double(i), 20.0 * Double(i)],
//                demonym: "Demonym \(i)",
//                area: Double(500 * i),
//                timezones: ["UTC+\(i)"],
//                borders: [],
//                nativeName: "Native \(i)",
//                numericCode: "\(i)",
//                flags: Country.Flag(svg: "", png: ""),
//                currencies: [],
//                languages: [],
//                translations: [:],
//                flag: "",
//                regionalBlocs: [],
//                cioc: nil,
//                independent: true
//            )
//            viewModel.addCountry(country)
//        }
//
//        // When: Trying to add a 6th country
//        let extraCountry = Country(
//            name: "Extra Country",
//            topLevelDomain: [".ex"],
//            alpha2Code: "EX",
//            alpha3Code: "EX3",
//            callingCodes: ["+99"],
//            capital: "Extra Capital",
//            altSpellings: ["Extra-Country"],
//            subregion: "Extra Region",
//            region: "Extra Continent",
//            population: 999999,
//            latlng: [99.0, 199.0],
//            demonym: "Extra Demonym",
//            area: 99999.0,
//            timezones: ["UTC+99"],
//            borders: [],
//            nativeName: "Extra Native",
//            numericCode: "99",
//            flags: Country.Flag(svg: "", png: ""),
//            currencies: [],
//            languages: [],
//            translations: [:],
//            flag: "",
//            regionalBlocs: [],
//            cioc: nil,
//            independent: true
//        )
//        viewModel.addCountry(extraCountry)
//
//
//        // Then
//        XCTAssertEqual(viewModel.selectedCountries.count, 5, "❌ Should not add more than 5 countries")
//    }
//    // ✅ Test: Removing a Country
//    func testRemoveCountry() {
//        // Given: A country added
//        viewModel.addCountry(Country.sample)
//        
//        // When
//        viewModel.removeCountry(at: IndexSet(integer: 0))
//        
//        // Then
//        XCTAssertEqual(viewModel.selectedCountries.count, 0)
//    }
//    
//    // ✅ Test: Setting Default Country
//    func testSetDefaultCountry() {
//        // Given: The default country is set
//        viewModel.setDefaultCountry()
//        
//        // Then
//        XCTAssertEqual(viewModel.selectedCountries.count, 1)
//        XCTAssertEqual(viewModel.selectedCountries[0].name, "Egypt")
//    }
//}
