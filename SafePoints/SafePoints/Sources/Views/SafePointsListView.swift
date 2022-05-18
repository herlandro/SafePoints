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
    let onPointSelected: (SafePoint) -> Void
    
    @State private var searchText = ""
    @State private var selectedFreguesia: String?
    
    private var freguesias: [String] {
        Array(Set(safePoints.map { $0.properties.freguesia })).sorted()
    }
    
    private var filteredPoints: [SafePoint] {
        var filtered = safePoints
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.properties.nome.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let freguesia = selectedFreguesia {
            filtered = filtered.filter { $0.properties.freguesia == freguesia }
        }
        
        return filtered
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Search bar
            SearchBar(searchText: $searchText, placeholder: "Search Safe Points")
                .padding(.horizontal)
            
            // Freguesia filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(freguesias, id: \.self) { freguesia in
                        Button(action: {
                            if selectedFreguesia == freguesia {
                                selectedFreguesia = nil
                            } else {
                                selectedFreguesia = freguesia
                            }
                        }) {
                            Text(freguesia)
                                .font(.system(size: 14))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(selectedFreguesia == freguesia ? Color.blue : Color(.systemGray6))
                                )
                                .foregroundColor(selectedFreguesia == freguesia ? .white : .primary)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Points list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredPoints) { point in
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
            }
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    SafePointsMapView()
}
