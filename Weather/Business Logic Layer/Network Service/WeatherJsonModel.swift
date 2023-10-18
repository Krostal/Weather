

import Foundation

struct WeatherJsonModel: Codable {
    let type: String?
    let geometry: Geometry
    let properties: Properties
}

struct Geometry: Codable {
    let type: String?
    let coordinates: [Double]
}

struct Properties: Codable {
    let meta: Meta
    let timeseries: [TimeSeries]
}

struct Meta: Codable {
    let updatedAt: String
    let units: Units
}

struct Units: Codable {
    let airPressureAtSeaLevel: String?
    let airTemperature: String?
    let airTemperatureMax: String?
    let airTemperatureMin: String?
    let airTemperaturePercentile10: String?
    let airTemperaturePercentile90: String?
    let cloudAreaFraction: String?
    let cloudAreaFractionHigh: String?
    let cloudAreaFractionLow: String?
    let cloudAreaFractionMedium: String?
    let dewPointTemperature: String?
    let fogAreaFraction: String?
    let precipitationAmount: String?
    let precipitationAmountMax: String?
    let precipitationAmountMin: String?
    let probabilityOfPrecipitation: String?
    let probabilityOfThunder: String?
    let relativeHumidity: String?
    let ultravioletIndexClearSky: String?
    let windFromDirection: String?
    let windSpeed: String?
    let windSpeedOfGust: String?
    let windSpeedPercentile10: String?
    let windSpeedPercentile90: String?
}

struct TimeSeries: Codable {
    let time: String
    let data: TimeSeriesData
}

struct TimeSeriesData: Codable {
    let instant: Instant
    let next12Hours: Next12Hours?
    let next1Hours: Next1Hours?
    let next6Hours: Next6Hours?
}

struct Instant: Codable {
    let details: InstantDetails?
}

struct InstantDetails: Codable {
    let airPressureAtSeaLevel: Float?
    let airTemperature: Float?
    let airTemperaturePercentile10: Float?
    let airTemperaturePercentile90: Float?
    let cloudAreaFraction: Float?
    let cloudAreaFractionHigh: Float?
    let cloudAreaFractionLow: Float?
    let cloudAreaFractionMedium: Float?
    let dewPointTemperature: Float?
    let fogAreaFraction: Float?
    let relativeHumidity: Float?
    let ultravioletIndexClearSky: Float?
    let windFromDirection: Float?
    let windSpeed: Float?
    let windSpeedOfGust: Float?
    let windSpeedPercentile10: Float?
    let windSpeedPercentile90: Float?
}

struct Next12Hours: Codable {
    let summary: Next12HoursSummary?
    let details: Next12HoursDetails?
}

struct Next1Hours: Codable {
    let summary: Next1HoursSummary?
    let details: Next1HoursDetails?
}

struct Next6Hours: Codable {
    let summary: Next6HoursSummary?
    let details: Next6HoursDetails?
}

struct Next12HoursSummary: Codable {
    let symbolCode: String?
    let symbolConfidence: String?
}

struct Next1HoursSummary: Codable {
    let symbolCode: String?
}

struct Next6HoursSummary: Codable {
    let symbolCode: String?
}

struct Next12HoursDetails: Codable {
    let probabilityOfPrecipitation: Float?
}

struct Next1HoursDetails: Codable {
    let precipitationAmount: Float?
    let precipitationAmountMax: Float?
    let precipitationAmountMin: Float?
    let probabilityOfPrecipitation: Float?
    let probabilityOfThunder: Float?
}

struct Next6HoursDetails: Codable {
    let airTemperatureMax: Float?
    let airTemperatureMin: Float?
    let precipitationAmount: Float?
    let precipitationAmountMax: Float?
    let precipitationAmountMin: Float?
    let probabilityOfPrecipitation: Float?
}
