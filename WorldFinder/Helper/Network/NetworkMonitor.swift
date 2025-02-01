//
//  NetworkMonitor.swift
//  WorldFinder
//
//  Created by Haitham Gado on 01/02/2025.
//

import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var isConnected: Bool = true

    private init() {
        startMonitoring() // ✅ Start monitoring in the background
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue) // ✅ Runs in the background
    }

    func isInternetAvailable() -> Bool {
        return isConnected
    }
}
