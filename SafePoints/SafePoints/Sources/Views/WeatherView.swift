import SwiftUI
import CoreLocation

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    private func aqiColor(_ value: Int) -> Color {
        switch value {
        case 1...2:
            return .green
        case 3...4:
            return .yellow
        case 5...6:
            return .orange
        case 7...8:
            return .red
        case 9...10:
            return .purple
        default:
            return .brown
        }
    }
    
    private func aqiDescription(_ value: Int) -> String {
        switch value {
        case 1...2:
            return NSLocalizedString("aqi.good", comment: "Good air quality")
        case 3...4:
            return NSLocalizedString("aqi.moderate", comment: "Moderate air quality")
        case 5...6:
            return NSLocalizedString("aqi.sensitive", comment: "Unhealthy for sensitive groups")
        case 7...8:
            return NSLocalizedString("aqi.unhealthy", comment: "Unhealthy air quality")
        case 9...10:
            return NSLocalizedString("aqi.very_unhealthy", comment: "Very unhealthy air quality")
        default:
            return NSLocalizedString("aqi.hazardous", comment: "Hazardous air quality")
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            // Temperature and icon
            HStack(spacing: 4) {
                Image(systemName: viewModel.weatherIcon)
                    .foregroundColor(.yellow)
                
                if let temperature = viewModel.temperature {
                    Text("\(Int(round(temperature)))°")
                        .font(.system(size: 16, weight: .medium))
                } else {
                    Text("--°")
                        .font(.system(size: 16, weight: .medium))
                }
            }
            
            // Vertical separator
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 20)
            
            // Air quality indicator
            HStack(spacing: 4) {
                Circle()
                    .fill(aqiColor(viewModel.aqi))
                    .frame(width: 12, height: 12)
                
                Text("\(NSLocalizedString("weather.aqi", comment: "Air Quality Index")) \(viewModel.aqi)")
                    .font(.system(size: 14))
                
                Text(aqiDescription(viewModel.aqi))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .onAppear {
            Task {
                // Lisbon coordinates
                await viewModel.fetchWeather(latitude: 38.7223, longitude: -9.1393)
            }
        }
    }
}

@MainActor
class WeatherViewModel: ObservableObject {
    private let weatherService: WeatherServiceProtocol
    
    @Published var temperature: Double?
    @Published var condition: String = ""
    @Published var aqi: Int = 2
    
    var weatherIcon: String {
        switch condition.lowercased() {
        case _ where condition.contains("clear"):
            return "sun.max.fill"
        case _ where condition.contains("cloud"):
            return "cloud.fill"
        case _ where condition.contains("rain"):
            return "cloud.rain.fill"
        case _ where condition.contains("snow"):
            return "snow"
        case _ where condition.contains("thunder"):
            return "cloud.bolt.fill"
        default:
            return "sun.max.fill"
        }
    }
    
    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }
    
    func fetchWeather(latitude: Double, longitude: Double) async {
        do {
            let weatherData = try await weatherService.getCurrentWeather(latitude: latitude, longitude: longitude)
            temperature = weatherData.main.temp
            condition = weatherData.weather.first?.main ?? ""
            aqi = weatherData.aqi
        } catch {
            print("Error fetching weather: \(error)")
        }
    }
}

#Preview {
    WeatherView()
}
