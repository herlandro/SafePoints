import SwiftUI

enum AQILevel {
    case good
    case moderate
    case unhealthySensitive
    case unhealthy
    case veryUnhealthy
    case hazardous
    
    init(value: Int) {
        switch value {
        case 1...2:
            self = .good
        case 3...4:
            self = .moderate
        case 5...6:
            self = .unhealthySensitive
        case 7...8:
            self = .unhealthy
        case 9...10:
            self = .veryUnhealthy
        default:
            self = .hazardous
        }
    }
    
    var color: Color {
        switch self {
        case .good:
            return .green
        case .moderate:
            return .yellow
        case .unhealthySensitive:
            return .orange
        case .unhealthy:
            return .red
        case .veryUnhealthy:
            return .purple
        case .hazardous:
            return .brown
        }
    }
    
    var description: String {
        switch self {
        case .good:
            return NSLocalizedString("aqi.good", comment: "Good air quality")
        case .moderate:
            return NSLocalizedString("aqi.moderate", comment: "Moderate air quality")
        case .unhealthySensitive:
            return NSLocalizedString("aqi.sensitive", comment: "Unhealthy for sensitive groups")
        case .unhealthy:
            return NSLocalizedString("aqi.unhealthy", comment: "Unhealthy air quality")
        case .veryUnhealthy:
            return NSLocalizedString("aqi.very_unhealthy", comment: "Very unhealthy air quality")
        case .hazardous:
            return NSLocalizedString("aqi.hazardous", comment: "Hazardous air quality")
        }
    }
} 