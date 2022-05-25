import Foundation
import CoreLocation

protocol WeatherServiceProtocol {
    func getCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherData
}

class WeatherService: WeatherServiceProtocol {

    private let apiKey: String = APIConfig.openWeatherMapKey
    
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
        
        // For debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("API Response: \(jsonString)")
        }
        
        let decoder = JSONDecoder()
        let weatherResponse = try decoder.decode(OpenWeather.self, from: data)
        
        return WeatherData(
            main: WeatherData.MainData(temp: weatherResponse.main.temp),
            weather: [WeatherData.Weather(main: weatherResponse.weather.first?.main ?? "", description: weatherResponse.weather.first?.description ?? "")],
            aqi: 2 // Default value since we're not fetching AQI in this endpoint
        )
    }
}
