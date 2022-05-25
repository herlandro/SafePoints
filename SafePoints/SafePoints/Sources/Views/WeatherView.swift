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
            return "Boa"
        case 3...4:
            return "Moderada"
        case 5...6:
            return "Sensível"
        case 7...8:
            return "Insalubre"
        case 9...10:
            return "Muito Insalubre"
        default:
            return "Perigosa"
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            // Temperatura e ícone
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
            
            // Separador vertical
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 20)
            
            // Indicador de qualidade do ar
            HStack(spacing: 4) {
                Circle()
                    .fill(aqiColor(viewModel.aqi))
                    .frame(width: 12, height: 12)
                
                Text("AQI \(viewModel.aqi)")
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
            // Lisbon coordinates
            viewModel.fetchWeather(latitude: 38.7223, longitude: -9.1393)
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
    
    func fetchWeather(latitude: Double, longitude: Double) {
        Task {
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
}

#Preview {
    WeatherView()
} 