//
//  GetCountriesUseCaseTests.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//
import XCTest
import Combine
@testable import WorldFinder


class GetCountriesUseCaseTests: XCTestCase {
    
    var mockRepository: MockCountryRepository!
    var getCountriesUseCase: GetCountriesUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockCountryRepository()
        getCountriesUseCase = GetCountriesUseCase(repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        mockRepository = nil
        getCountriesUseCase = nil
        cancellables = nil
        super.tearDown()
    }

    /// ✅ Test successful country fetching
    func testGetCountries_Success() {
        // Given
        let expectedCountries = [
            Country.sample,
            Country.defaultCountry
        ]
        mockRepository.mockCountries = expectedCountries

        let expectation = self.expectation(description: "Fetching countries should return correct data")

        // When
        getCountriesUseCase.execute()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure: \(error)")
                }
            }, receiveValue: { countries in
                // Then
                XCTAssertEqual(countries.count, 2)
                XCTAssertEqual(countries[0].name, "France") // ✅ Uses `sample`
                XCTAssertEqual(countries[1].name, "Egypt") // ✅ Uses `defaultCountry`
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }

    /// ✅ Test error handling when repository fails
    func testGetCountries_Failure() {
        // Given
        mockRepository.mockError = .requestFailed // ✅ Simulate network failure

        let expectation = self.expectation(description: "Fetching countries should fail with network error")

        // When
        getCountriesUseCase.execute()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .requestFailed, "Expected requestFailed but got \(error)")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }
}
