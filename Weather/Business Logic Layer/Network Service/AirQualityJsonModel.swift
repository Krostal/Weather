

import Foundation

struct AirQualityJsonModel: Codable {
    let data: AirQualityData
}

struct AirQualityData: Codable {
    let aqi: Int
    let idx: Int
    let city: City
    let forecast: Forecast
}

struct City: Codable {
    let geo: [Double]
    let name: String
    let url: String
    let location: String
}

struct Forecast: Codable {
    let daily: DailyForecast
}

struct DailyForecast: Codable {
    let o3: [DailyValue]
    let pm10: [DailyValue]
    let pm25: [DailyValue]
}

struct DailyValue: Codable {
    let avg: Int
    let day: String
    let max: Int
    let min: Int
}
