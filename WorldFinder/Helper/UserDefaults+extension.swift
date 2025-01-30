//
//  UserDefaults+extension.swift
//  WorldFinder
//
//  Created by Haitham Gado on 29/01/2025.
//

import Foundation

extension UserDefaults: UserDefaultsProtocol {
    
    /// Saves a `Codable` object to UserDefaults
    func setCodable<T: Codable>(_ object: T?, forKey key: String) {
        guard let object = object else {
            removeObject(forKey: key) // If nil, remove the key
            return
        }
        
        do {
            let encoded = try JSONEncoder().encode(object)
            set(encoded, forKey: key)
        } catch {
            assertionFailure("❌ Encoding failed for key: \(key) - Error: \(error)")
        }
    }

    /// Retrieves a `Codable` object from UserDefaults
    func codable<T: Codable>(forKey key: String) -> T? {
        guard let data = data(forKey: key) else {
            return nil
        }

        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            assertionFailure("❌ Decoding failed for key: \(key) - Error: \(error)")
            return nil
        }
    }
}
