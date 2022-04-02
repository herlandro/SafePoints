//
//  SafePointsApp.swift
//  SafePoints
//
//  Created by Herlandro Hermogenes on 28/03/2022.
//

import Foundation
import MapKit
import CoreLocation

@MainActor
class SafePointsViewModel: ObservableObject {
    private let service: SafePointsServiceProtocol
    
    @Published var safePoints: [SafePoint] = []
    @Published var selectedPoint: SafePoint?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 38.7223, longitude: -9.1393), // Lisbon center
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    let clusterThreshold: Double = 0.05 // Freguesia level clustering
    private let cityThreshold: Double = 0.1 // City level clustering
    private let countryThreshold: Double = 0.2 // Country level clustering
    
    init(service: SafePointsServiceProtocol = SafePointsService()) {
        self.service = service
    }
    
    var shouldShowClusters: Bool {
        region.span.latitudeDelta > clusterThreshold
    }
    
    var shouldShowCityCluster: Bool {
        region.span.latitudeDelta > cityThreshold
    }
    
    var shouldShowCountryCluster: Bool {
        region.span.latitudeDelta > countryThreshold
    }
    
    struct Cluster: Identifiable {
        let id = UUID()
        let points: [SafePoint]
        let coordinate: CLLocationCoordinate2D
        let freguesia: String
        
        var count: Int { points.count }
    }
    
    func getClusters() -> [Cluster] {
        if shouldShowCountryCluster {
            // Show single cluster for Portugal
            return [Cluster(
                points: safePoints,
                coordinate: CLLocationCoordinate2D(latitude: 39.5, longitude: -8.0),
                freguesia: "Portugal"
            )]
        }
        
        if shouldShowCityCluster {
            // Show single cluster for Lisbon
            return [Cluster(
                points: safePoints,
                coordinate: CLLocationCoordinate2D(latitude: 38.7223, longitude: -9.1393),
                freguesia: "Lisboa"
            )]
        }
        
        // Group by freguesia
        let groupedByFreguesia = Dictionary(grouping: safePoints) { $0.properties.freguesia }
        
        return groupedByFreguesia.map { freguesia, points in
            // Calculate average coordinate for the freguesia
            let avgLat = points.reduce(0) { $0 + $1.geometry.location.latitude } / Double(points.count)
            let avgLong = points.reduce(0) { $0 + $1.geometry.location.longitude } / Double(points.count)
            
            return Cluster(
                points: points,
                coordinate: CLLocationCoordinate2D(latitude: avgLat, longitude: avgLong),
                freguesia: freguesia
            )
        }
    }
    
    func loadSafePoints() {
        Task {
            do {
                safePoints = try await service.loadSafePoints()
            } catch {
                print("Error loading safe points: \(error)")
            }
        }
    }
    
    func selectNextPoint() {
        guard let currentPoint = selectedPoint,
              let currentIndex = safePoints.firstIndex(where: { $0.id == currentPoint.id }),
              currentIndex + 1 < safePoints.count else {
            return
        }
        
        selectedPoint = safePoints[currentIndex + 1]
        centerMapOnPoint(selectedPoint!)
    }
    
    func selectPreviousPoint() {
        guard let currentPoint = selectedPoint,
              let currentIndex = safePoints.firstIndex(where: { $0.id == currentPoint.id }),
              currentIndex > 0 else {
            return
        }
        
        selectedPoint = safePoints[currentIndex - 1]
        centerMapOnPoint(selectedPoint!)
    }
    
    func centerMapOnPoint(_ point: SafePoint) {
        region = MKCoordinateRegion(
            center: point.geometry.location,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
} 
