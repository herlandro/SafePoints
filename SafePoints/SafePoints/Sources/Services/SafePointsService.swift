//
//  SafePointsApp.swift
//  SafePoints
//
//  Created by Herlandro Hermogenes on 28/03/2022.
//

import Foundation
import CoreLocation

protocol SafePointsServiceProtocol {
    func loadSafePoints() async throws -> [SafePoint]
}

class SafePointsService: SafePointsServiceProtocol {
    func loadSafePoints() async throws -> [SafePoint] {
        guard let url = Bundle.main.url(forResource: "safe-points-portugal-lisbon", withExtension: "json") else {
            throw NSError(domain: "SafePointsService", code: 404, userInfo: [NSLocalizedDescriptionKey: "JSON file not found"])
        }
        
        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(SafePointsResponse.self, from: data)
        return response.lisbon
    }
} 
