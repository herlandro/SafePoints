//
//  SafePointsApp.swift
//  SafePoints
//
//  Created by Herlandro Hermogenes on 28/03/2022.
//

import SwiftUI
import MapKit

struct SafePointsMapView: View {
    @StateObject private var viewModel = SafePointsViewModel()
    @State private var sheetPosition: SheetPosition = .mid
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Map view
            if viewModel.shouldShowClusters {
                Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.getClusters()) { cluster in
                    MapAnnotation(coordinate: cluster.coordinate) {
                        ClusterMarkerView(count: cluster.count, title: cluster.freguesia)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.region.center = cluster.coordinate
                                    viewModel.region.span = MKCoordinateSpan(
                                        latitudeDelta: viewModel.clusterThreshold / 2,
                                        longitudeDelta: viewModel.clusterThreshold / 2
                                    )
                                }
                            }
                    }
                }
            } else {
                Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.safePoints) { point in
                    MapAnnotation(coordinate: point.geometry.location) {
                        Image("safe-point")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectedPoint = point
                                    viewModel.centerMapOnPoint(point, topOffset: 0.25)
                                }
                            }
                    }
                }
            }
            
            // Weather view
            WeatherView()
                .padding()
                .offset(y: -100) // Center it vertically with some offset from the exact center
                .opacity(sheetPosition == .expanded ? 0 : 1) // Hide when sheet is expanded
                .animation(.easeInOut(duration: 0.3), value: sheetPosition) // Smooth animation
            
            // Bottom sheet
            BottomSheetView(position: $sheetPosition) {
                SafePointsListView(
                    safePoints: viewModel.safePoints,
                    selectedPoint: $viewModel.selectedPoint,
                    onPointSelected: { point in
                        withAnimation {
                            viewModel.centerMapOnPoint(point, topOffset: 0.25)
                        }
                    }
                )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.loadSafePoints()
        }
    }
}

#Preview {
    SafePointsMapView()
}
