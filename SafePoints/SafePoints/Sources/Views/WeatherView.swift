import SwiftUI
import CoreLocation

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
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
            
            Text("AQI \(viewModel.aqi)")
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