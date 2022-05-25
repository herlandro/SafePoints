import SwiftUI

struct AQIIndicatorView: View {
    let aqi: Int
    
    private var level: AQILevel {
        AQILevel(value: aqi)
    }
    
    var body: some View {
        HStack(spacing: 4) {
            // Círculo colorido
            Circle()
                .fill(level.color)
                .frame(width: 12, height: 12)
            
            // Texto do AQI
            Text("AQI \(aqi)")
                .font(.system(size: 14))
            
            // Descrição
            Text(level.description)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(level.color.opacity(0.15))
        .cornerRadius(8)
    }
}

#Preview {
    HStack {
        AQIIndicatorView(aqi: 1)
        AQIIndicatorView(aqi: 3)
        AQIIndicatorView(aqi: 5)
        AQIIndicatorView(aqi: 7)
    }
} 