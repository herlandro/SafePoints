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
                    // Show individual points
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
                
                SafePointsListView(
                    safePoints: viewModel.safePoints,
                    selectedPoint: $viewModel.selectedPoint,
                    height: geometry.size.height * 0.5,
                    onPointSelected: { point in
                        withAnimation {
                            viewModel.centerMapOnPoint(point, topOffset: 0.25)
                        }
                    }
                )
                .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            viewModel.loadSafePoints()
        }
    }
}

struct SafePointsListView: View {
    let safePoints: [SafePoint]
    @Binding var selectedPoint: SafePoint?
    let height: CGFloat
    let onPointSelected: (SafePoint) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.vertical, 8)
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(safePoints) { point in
                            SafePointListItemView(point: point, isSelected: point.id == selectedPoint?.id)
                                .id(point.id)
                                .onTapGesture {
                                    selectedPoint = point
                                    onPointSelected(point)
                                }
                        }
                    }
                    .padding(.horizontal)
                }
//                .onChange(of: selectedPoint) { newPoint in
//                    if let point = newPoint {
//                        withAnimation {
//                            proxy.scrollTo(point.id, anchor: .center)
//                        }
//                    }
//                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(radius: 5)
        )
    }
}

struct SafePointListItemView: View {
    let point: SafePoint
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(isSelected ? Color.blue : Color.red)
                .frame(width: 48, height: 48)
                .overlay(
                    Image("safe-point")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(point.properties.nome)
                    .font(.headline)
                
                if let address = point.properties.address {
                    Text(address)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Text(point.properties.freguesia)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
}

#Preview {
    SafePointsMapView()
} 
