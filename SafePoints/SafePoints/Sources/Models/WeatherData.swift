import Foundation

struct OpenWeather: Codable {
    let main: Main
    let weather: [Weather]
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let main: String
        let description: String
    }
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
