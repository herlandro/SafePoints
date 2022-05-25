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
            ZStack {
                Circle()
                    .fill(isSelected ? Color.green : Color(red: 0, green: 0.6, blue: 0))
                    .frame(width: 48, height: 48)
                
                Image("pin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48) // Slightly smaller to fit nicely inside circle
            }
            .frame(width: 48, height: 48) // Ensure consistent size
            
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
        .padding(.horizontal)
        .background(isSelected ? Color.green.opacity(0.1) : Color.clear)
        .cornerRadius(4.0)
        .contentShape(Rectangle()) // Makes the entire row tappable
    }
}

struct SafePointListItemView_Previews: PreviewProvider {
    static var previews: some View {
        SafePointListItemView(
            point: SafePoint(
                type: "Feature",
                geometry: Geometry(
                    type: "Point",
                    coordinates: [-9.14414385630547, 38.7302461032567]
                ),
                properties: Properties(
                    ordem: 16,
                    nome: "Praça José Fontana",
                    designacao: "16 - Praça José Fontana",
                    freguesia: "Arroios",
                    fregServida: "Também serve Avenidas Novas",
                    address: "Praça José Fontana"
                )
            ),
            isSelected: false
        )
    }
} 
