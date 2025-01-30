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
    
    var cancellables: Set<AnyCancellable> = []
    
    func testFetchAllCountries_Success() {
        // Given
        guard let jsonData = loadJSONFile(named: "countries") else {
            XCTFail("Failed to load JSON file.")
            return
        }
        
        let mockSession = MockURLSession(data: jsonData, response: HTTPURLResponse(url: URL(string: "https://mockurl.com")!,
                                                                                   statusCode: 200,
                                                                                   httpVersion: nil,
                                                                                   headerFields: nil),
                                         error: nil)
        
        let service = CountryService(session: mockSession)
        let expectation = self.expectation(description: "Fetching countries should return correct data")
        
        // When
        service.fetchAllCountries()
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
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchAllCountries_InvalidData() {
        // Given
        let invalidJsonData = "invalid json".data(using: .utf8)!
        
        let mockSession = MockURLSession(data: invalidJsonData, response: HTTPURLResponse(url: URL(string: "https://mockurl.com")!,
                                                                                           statusCode: 200,
                                                                                           httpVersion: nil,
                                                                                           headerFields: nil),
                                         error: nil)
        
        let service = CountryService(session: mockSession)
        let expectation = self.expectation(description: "Fetching countries should fail due to decoding error")

        // When
        service.fetchAllCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error, "Expected decoding failure")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchAllCountries_NetworkError() {
        // Given
        let mockSession = MockURLSession(data: nil, response: nil, error: URLError(.notConnectedToInternet))
        
        let service = CountryService(session: mockSession)
        let expectation = self.expectation(description: "Fetching countries should fail due to network error")

        // When
        service.fetchAllCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error, "Expected network error")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // Helper function to load JSON from a file in the test bundle
    func loadJSONFile(named filename: String) -> Data? {
        guard let url = Bundle(for: type(of: self)).url(forResource: filename, withExtension: "json") else {
            print("Could not find \(filename).json in test bundle")
            return nil
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Error loading JSON: \(error)")
            return nil
        }
    }
}
