//
//  SafePointsApp.swift
//  SafePoints
//
//  Created by Herlandro Hermogenes on 28/03/2022.
//

import SwiftUI
import MapKit
import UIKit

struct SafePointsMapView: View {
    @StateObject private var viewModel = SafePointsViewModel()
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.safePoints) { point in
                    MapAnnotation(coordinate: point.geometry.location) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                            .onTapGesture {
                                viewModel.selectedPoint = point
                                viewModel.centerMapOnPoint(point)
                            }
                    }
                }
                .ignoresSafeArea()
                
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
