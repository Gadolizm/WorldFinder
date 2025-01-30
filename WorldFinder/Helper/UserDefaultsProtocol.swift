//
//  UserDefaultsProtocol.swift
//  WorldFinder
//
//  Created by Haitham Gado on 30/01/2025.
//

protocol UserDefaultsProtocol {
    func setCodable<T: Codable>(_ value: T?, forKey key: String)
    func codable<T: Codable>(forKey key: String) -> T?
}
