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
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if viewModel.shouldShowClusters {
                    // Show clusters
                    Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.getClusters()) { cluster in
                        MapAnnotation(coordinate: cluster.coordinate) {
                            ClusterMarkerView(count: cluster.count, title: cluster.freguesia)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.selectedPoint = nil
                                        viewModel.region.center = cluster.coordinate
                                        viewModel.region.span = MKCoordinateSpan(
                                            latitudeDelta: viewModel.clusterThreshold / 2,
                                            longitudeDelta: viewModel.clusterThreshold / 2
                                        )
                                    }
                                }
                        }
                    }
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded { _ in
                                withAnimation {
                                    viewModel.selectedPoint = nil
                                }
                            }
                    )
                } else {
                    // Show individual points
                    Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.safePoints) { point in
                        MapAnnotation(coordinate: point.geometry.location) {
                            Image("safe-point")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .onTapGesture {
                                    withAnimation {
                                        if viewModel.selectedPoint?.id == point.id {
                                            viewModel.selectedPoint = nil
                                        } else {
                                            viewModel.selectedPoint = point
                                            viewModel.centerMapOnPoint(point)
                                        }
                                    }
                                }
                        }
                    }
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded { _ in
                                withAnimation {
                                    viewModel.selectedPoint = nil
                                }
                            }
                    )
                }
//                .ignoresSafeArea()
                
                if let selectedPoint = viewModel.selectedPoint {
                    SafePointDetailView(safePoint: selectedPoint, height: geometry.size.height * 0.3)
                        .transition(.move(edge: .bottom))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation.width
                                }
                                .onEnded { value in
                                    let threshold: CGFloat = 50
                                    if value.translation.width > threshold {
                                        withAnimation {
                                            viewModel.selectPreviousPoint()
                                        }
                                    } else if value.translation.width < -threshold {
                                        withAnimation {
                                            viewModel.selectNextPoint()
                                        }
                                    }
                                    dragOffset = 0
                                }
                        )
                        .offset(x: dragOffset)
                }
            }
        }
        .onAppear {
            viewModel.loadSafePoints()
        }
    }
}

#Preview {
    SafePointsMapView()
} 
