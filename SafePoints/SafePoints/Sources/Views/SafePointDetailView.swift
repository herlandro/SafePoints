//
//  SafePointsApp.swift
//  SafePoints
//
//  Created by Herlandro Hermogenes on 28/03/2022.
//

import SwiftUI
import UIKit

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
