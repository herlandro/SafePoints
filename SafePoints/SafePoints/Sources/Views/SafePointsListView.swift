//
//  SafePointsListView.swift
//  SafePoints
//
//  Created by Herlandro Hermogenes on 31/05/2022.
//

import SwiftUI

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
