

import Foundation

enum TemperatureUnit: String {
    case celsius = "°"
    case fahrenheit = "F"
}

enum WindSpeedUnit: String {
    case metersPerSecond = "м/с"
    case milesPerHour = "mph"
}

enum TimeFormat: String {
    case twelveHour = "12"
    case twentyFourHour = "24"
}

enum PrecipitationUnit: String {
    case millimeters = "мм"
    case inches = "'"
}

struct Settings {
    var temperatureUnit: TemperatureUnit
    var windSpeedUnit: WindSpeedUnit
    var timeFormat: TimeFormat
    var precipitationUnit: PrecipitationUnit
}


