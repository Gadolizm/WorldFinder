//
//  NetworkManagerTests.swift
//  WorldFinder
//
//  Created by Haitham Gado on 01/02/2025.
//

import XCTest
import Combine
@testable import WorldFinder

class NetworkManagerTests: XCTestCase {
    
    var mockSession: MockURLSession!
    var networkManager: NetworkManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkManager = NetworkManager(session: mockSession)
        cancellables = []
    }
    
    override func tearDown() {
        mockSession = nil
        networkManager = nil
        cancellables = nil
        super.tearDown()
    }

    /// ✅ Test successful API response
    func testFetchData_Success() {
        // Given
        guard let jsonData = JSONTestHelper.loadJSONFile(named: "countries") else {
            XCTFail("Failed to load JSON file.")
            return
        }
        mockSession.mockData = jsonData
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "https://mockapi.com")!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)

        let expectation = self.expectation(description: "Fetching data should return correct response")

        // When
        networkManager.fetchData(from: "/countries", responseType: [Country].self)
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

    /// ✅ Test decoding failure when API returns invalid JSON
    func testFetchData_DecodingFailure() {
        // Given
        let invalidJsonData = "invalid json".data(using: .utf8)!
        mockSession.mockData = invalidJsonData
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "https://mockapi.com")!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)

        let expectation = self.expectation(description: "Fetching data should fail due to decoding error")

        // When
        networkManager.fetchData(from: "/countries", responseType: [Country].self)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .decodingFailed, "Expected decoding error but got \(error)")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }

    /// ✅ Test network failure (e.g., no internet)
    func testFetchData_NetworkError() {
        // Given
        mockSession.mockError = URLError(.notConnectedToInternet)

        let expectation = self.expectation(description: "Fetching data should fail due to network error")

        // When
        networkManager.fetchData(from: "/countries", responseType: [Country].self)
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
