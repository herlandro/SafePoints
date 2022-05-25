import Foundation
import CoreLocation

protocol WeatherServiceProtocol {
    func getCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherData
}

struct WeatherData: Codable {
    let main: MainData
    let weather: [Weather]
    let aqi: Int
    
    struct MainData: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let main: String
        let description: String
    }
}

class WeatherService: WeatherServiceProtocol {
    // TODO: Move to secure configuration
    private let apiKey: String = "c011f3b4d04ba9f25f8664e3b957b2d6"
    
    func getCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "WeatherService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "WeatherService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        }
        
        let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
        return weatherData
    }
} 
