//
//  SafePointListItemView.swift
//  SafePoints
//
//  Created by Herlandro Hermogenes on 31/05/2022.
//

import SwiftUI

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
