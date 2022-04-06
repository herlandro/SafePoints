//
//  SafePointsApp.swift
//  SafePoints
//
//  Created by Herlandro Hermogenes on 28/03/2022.
//

import SwiftUI

struct SafePointDetailView: View {
    let safePoint: SafePoint
    let height: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(safePoint.properties.nome)
                .font(.title2)
                .fontWeight(.bold)
            
            if let address = safePoint.properties.address {
                HStack {
                    Image(systemName: "location.fill")
                    Text(address)
                }
                .foregroundColor(.gray)
            }
            
            Text("Freguesia: \(safePoint.properties.freguesia)")
            
            if let fregServida = safePoint.properties.fregServida {
                Text(fregServida)
                    .foregroundColor(.gray)
            }
            
            Text("Ordem: \(safePoint.properties.ordem)")
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: height)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(radius: 5)
        )
    }
}

#Preview {
    let safePoint = SafePoint(
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
    )
    SafePointDetailView(
        safePoint: safePoint,
        height: 200
    )
}
