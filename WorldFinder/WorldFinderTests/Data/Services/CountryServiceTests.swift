//
//  CountryServiceTests.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

import XCTest
import Combine
@testable import WorldFinder

class CountryServiceTests: XCTestCase {
    
    var mockNetworkManager: MockNetworkManager!
    var countryService: CountryService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        countryService = CountryService(networkManager: mockNetworkManager)
        cancellables = []
    }
    
    override func tearDown() {
        mockNetworkManager = nil
        countryService = nil
        cancellables = nil
        super.tearDown()
    }

    /// ✅ Test successful API response
    func testFetchAllCountries_Success() {
        // Given
        guard let jsonData = JSONTestHelper.loadJSONFile(named: "countries") else {
            XCTFail("Failed to load JSON file.")
            return
        }
        
        mockNetworkManager.mockData = jsonData

        let expectation = self.expectation(description: "Fetching countries should return correct data")

        // When
        countryService.fetchAllCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure: \(error)")
                }
            }, receiveValue: { countries in
                // Then
                XCTAssertEqual(countries.count, 2)
                XCTAssertEqual(countries[0].name, "United States")
                XCTAssertEqual(countries[1].name, "Canada")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }

    /// ✅ Test decoding failure
    func testFetchAllCountries_DecodingFailure() {
        // Given
        let invalidJsonData = "invalid json".data(using: .utf8)!
        mockNetworkManager.mockData = invalidJsonData
        
        let expectation = self.expectation(description: "Fetching countries should fail due to decoding error")

        // When
        countryService.fetchAllCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .decodingFailed, "Expected decoding failure but got \(error)")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }

    /// ✅ Test network failure
    func testFetchAllCountries_NetworkError() {
        // Given
        mockNetworkManager.mockError = .requestFailed

        let expectation = self.expectation(description: "Fetching countries should fail due to network error")

        // When
        countryService.fetchAllCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .requestFailed, "Expected network error but got \(error)")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }
}
