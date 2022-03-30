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
    
    init(service: SafePointsServiceProtocol = SafePointsService()) {
        self.service = service
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
