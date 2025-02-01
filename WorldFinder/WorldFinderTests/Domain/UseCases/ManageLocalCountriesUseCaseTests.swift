//
//  ManageLocalCountriesUseCaseTests.swift
//  WorldFinder
//
//  Created by Haitham Gado on 01/02/2025.
//

import XCTest
import Combine
@testable import WorldFinder

class ManageLocalCountriesUseCaseTests: XCTestCase {
    var useCase: ManageLocalCountriesUseCase!
    var mockRepository: MockCountryRepository!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockRepository = MockCountryRepository()
        useCase = ManageLocalCountriesUseCase(repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        cancellables.removeAll()
        super.tearDown()
    }

    // ✅ Test saving countries
    func testSaveCountries() {
        let countries = [Country.sample, Country.defaultCountry]
        useCase.saveCountries(countries)
        XCTAssertEqual(mockRepository.mockCountries, countries, "Countries should be saved correctly")

    }

    // ✅ Test loading countries from cache
    func testLoadCountriesFromCache() {
        let expectation = self.expectation(description: "Load countries from cache")
        let countries = [Country.sample, Country.defaultCountry]
        mockRepository.mockCountries = countries
        
        useCase.loadCountriesFromCache()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { loadedCountries in
                XCTAssertEqual(loadedCountries, countries)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }

    // ✅ Test loading selected countries
    func testLoadSelectedCountries() {
        let expectation = self.expectation(description: "Load selected countries")
        let countries = [Country.sample]
        mockRepository.mockSelectedCountries = countries
        
        useCase.loadSelectedCountries()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { loadedCountries in
                XCTAssertEqual(loadedCountries, countries)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }

    // ✅ Test saving selected countries
    func testSaveSelectedCountries() {
        let countries = [Country.sample]
        useCase.saveSelectedCountries(countries)
        XCTAssertEqual(mockRepository.mockSelectedCountries, countries)
    }

    // ✅ Test clearing cache
    func testClearCache() {
        let expectation = self.expectation(description: "Cache cleared")
        let countries = [Country.sample]
        mockRepository.mockCountries = countries
        mockRepository.mockSelectedCountries = countries

        useCase.clearCache()
            .collect()
            .sink(receiveValue: { _ in
                XCTAssertTrue(self.mockRepository.mockCountries.isEmpty)
                XCTAssertTrue(self.mockRepository.mockSelectedCountries.isEmpty)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }
}
