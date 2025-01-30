//
//  CountryRepositoryTests.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//
import XCTest
import Combine
@testable import WorldFinder


class CountryRepositoryTests: XCTestCase {
    var repository: CountryRepository!
    var mockService: MockCountryService!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockService = MockCountryService()
        repository = CountryRepository(service: mockService)
    }

    override func tearDown() {
        repository = nil
        mockService = nil
        cancellables.removeAll()
        super.tearDown()
    }

    // ✅ Success Case: Fetching Countries Successfully
    func testGetCountries_Success() {
        // Given: A list of mock countries
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
                timezones: ["UTC−12:00", "UTC−11:00", "UTC−10:00"],
                borders: ["CAN", "MEX"],
                nativeName: "United States",
                numericCode: "840",
                flags: Country.Flag(svg: "https://flagcdn.com/us.svg", png: "https://flagcdn.com/w320/us.png"),
                currencies: [Country.Currency(code: "USD", name: "United States Dollar", symbol: "$")],
                languages: [Country.Language(iso639_1: "en", iso639_2: "eng", name: "English", nativeName: "English")],
                translations: ["de": "Vereinigte Staaten", "es": "Estados Unidos"],
                flag: "https://flagcdn.com/us.svg",
                regionalBlocs: [Country.RegionalBloc(acronym: "NAFTA", name: "North American Free Trade Agreement")],
                cioc: "USA",
                independent: true
            )
        ]
        
        mockService.result = .success(mockCountries)

        let expectation = self.expectation(description: "Fetching countries successfully")

        // When
        repository.getCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure: \(error)")
                }
            }, receiveValue: { countries in
                // Then
                XCTAssertEqual(countries.count, 1)
                XCTAssertEqual(countries[0].name, "United States")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2, handler: nil)
    }

    // ❌ Failure Case: API Error
    func testGetCountries_Failure() {
        // Given: Mock service returns an error
        mockService.result = .failure(URLError(.notConnectedToInternet))

        let expectation = self.expectation(description: "Fetching countries should fail")

        // When
        repository.getCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error, "Expected an error but got nil")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2, handler: nil)
    }
}
