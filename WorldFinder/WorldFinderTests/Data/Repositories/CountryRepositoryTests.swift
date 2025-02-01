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
    
    var mockService: MockCountryService!
    var mockUserDefaults: UserDefaults!
    var repository: CountryRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockCountryService()
        mockUserDefaults = UserDefaults(suiteName: "TestDefaults")! // ✅ Use test-specific UserDefaults
        repository = CountryRepository(service: mockService, userDefaults: mockUserDefaults)
        cancellables = []
    }

    override func tearDown() {
        mockUserDefaults.removePersistentDomain(forName: "TestDefaults") // ✅ Clear test UserDefaults
        mockService = nil
        repository = nil
        cancellables = nil
        super.tearDown()
    }

    /// ✅ Test fetching countries from API (No Cache)
    func testGetCountries_FetchFromAPI() {
        // Given
        let expectedCountries = [
            Country.sample,
            Country.defaultCountry
        ]
        mockService.mockCountries = expectedCountries

        let expectation = self.expectation(description: "Fetching countries from API should return correct data")

        // When
        repository.getCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure: \(error)")
                }
            }, receiveValue: { countries in
                // Then
                XCTAssertEqual(countries.count, 2)
                XCTAssertEqual(countries[0].name, "France") // ✅ Now uses `sample`
                XCTAssertEqual(countries[1].name, "Egypt") // ✅ Now uses `defaultCountry`
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }

    /// ✅ Test loading countries from cache
    func testGetCountries_LoadFromCache() {
        // Given
        let cachedCountries = [
            Country.sample
        ]
        repository.saveCountriesToCache(cachedCountries) // ✅ Save to cache

        let expectation = self.expectation(description: "Fetching countries from cache should return correct data")

        // When
        repository.getCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure: \(error)")
                }
            }, receiveValue: { countries in
                // Then
                XCTAssertEqual(countries.count, 1)
                XCTAssertEqual(countries[0].name, "France")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }

    /// ✅ Test failure when cache is empty
    func testGetCountries_CacheNotFound() {
        // Given
        mockUserDefaults.removeObject(forKey: "savedCountries") // ✅ Ensure cache is empty

        let expectation = self.expectation(description: "Fetching from cache should fail when cache is empty")

        // When
        repository.loadCountriesFromCache()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .cacheNotFound, "Expected cacheNotFound but got \(error)")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }

    /// ✅ Test saving and loading selected countries
    func testSaveAndLoadSelectedCountries() {
        // Given
        let selectedCountries = [
            Country.defaultCountry
        ]
        repository.saveSelectedCountries(selectedCountries)

        let expectation = self.expectation(description: "Selected countries should be saved and loaded correctly")

        // When
        repository.loadSelectedCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure: \(error)")
                }
            }, receiveValue: { countries in
                // Then
                XCTAssertEqual(countries.count, 1)
                XCTAssertEqual(countries[0].name, "Egypt")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }

    /// ✅ Test clearing cached countries
    func testClearCachedCountries() {
        // Given
        repository.saveCountriesToCache([Country.sample]) // ✅ Save to cache

        let expectation = self.expectation(description: "Cache should be cleared")

        // When
        repository.clearCachedCountries()
            .sink(receiveValue: {
                // ✅ Explicitly define type `[Country]?`
                let cachedCountries: [Country]? = self.mockUserDefaults.codable(forKey: "savedCountries")

                // ✅ Assert cache is cleared
                XCTAssertNil(cachedCountries, "Expected cache to be cleared, but found: \(String(describing: cachedCountries))")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }
}
