//
//  MockUserDefaults.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//
import Foundation
import Combine
@testable import WorldFinder

class MockUserDefaults: UserDefaultsProtocol {
    var storage: [String: Data] = [:]

    func setCodable<T: Codable>(_ object: T?, forKey key: String) {
        if let object = object {
            let encoded = try? JSONEncoder().encode(object)
            storage[key] = encoded
        } else {
            storage.removeValue(forKey: key)
        }
    }

    func codable<T: Codable>(forKey key: String) -> T? {
        guard let data = storage[key] else {
            return nil
        }
        let decoded = try? JSONDecoder().decode(T.self, from: data)
        return decoded
    }

    func removeObject(forKey key: String) {
        storage.removeValue(forKey: key)
    }
}
