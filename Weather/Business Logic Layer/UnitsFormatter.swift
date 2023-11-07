

import Foundation

enum UnitsFormatter {
    case inches
    case millimeters
    case fahrenheit
    case celsius
    case metersPerSecond
    case milesPerHour
    
    func format(_ value: Float) -> String {
        switch self {
            case .inches:
                return String(format: "%.1f'", value / 25.4)
            case .millimeters:
                return "\(value) мм"
            case .fahrenheit:
                return "\(Int(round(value * 9/5 + 32)))F"
            case .celsius:
                return "\(value)°"
            case .metersPerSecond:
                return "\(value) м/с"
            case .milesPerHour:
                return "\(Int(round(value * 2.23694))) mph"
        }
    }
}
