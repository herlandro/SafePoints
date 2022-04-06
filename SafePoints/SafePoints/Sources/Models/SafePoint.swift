//
//  SafePointsApp.swift
//  SafePoints
//
//  Created by Herlandro Hermogenes on 28/03/2022.
//

import Foundation
import CoreLocation

struct SafePointsResponse: Codable {
    let lisbon: [SafePoint]
}

struct SafePoint: Codable, Identifiable {
    let id = UUID()
    let type: String
    let geometry: Geometry
    let properties: Properties
}

struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
    }
}

struct Properties: Codable {
    let ordem: Int
    let nome: String
    let designacao: String
    let freguesia: String
    let fregServida: String?
    let address: String?
    
    enum CodingKeys: String, CodingKey {
        case ordem, nome, designacao, freguesia
        case fregServida = "freg-servida"
        case address
    }
}
