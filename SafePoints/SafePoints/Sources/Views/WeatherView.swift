import SwiftUI

struct WeatherView: View {
    let temperature: Int
    let condition: String
    let aqi: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "sun.max.fill")
                .foregroundColor(.yellow)
            
            Text("\(temperature)°")
                .font(.system(size: 16, weight: .medium))
            
            Text("AQI \(aqi)")
                .font(.system(size: 14))
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(Color.green.opacity(0.2))
                .cornerRadius(4)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
}

#Preview {
    WeatherView(temperature: 20, condition: "Sunny", aqi: 2)
} 