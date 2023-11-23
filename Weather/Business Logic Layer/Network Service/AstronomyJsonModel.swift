import Foundation

struct AstronomyJsonModel: Codable {
    let data: [AstronomyEntry]
    let meta: AstronomyMeta
}

struct AstronomyEntry: Codable {
    let astronomicalDawn: String?
    let astronomicalDusk: String?
    let civilDawn: String?
    let civilDusk: String?
    let moonFraction: Double?
    let moonPhase: MoonPhase
    let moonrise: String?
    let moonset: String?
    let nauticalDawn: String?
    let nauticalDusk: String?
    let sunrise: String?
    let sunset: String?
    let time: String?
}

struct MoonPhase: Codable {
    let closest: MoonPhaseInfo
    let current: MoonPhaseInfo
}

struct MoonPhaseInfo: Codable {
    let text: String?
    let time: String?
    let value: Double?
}

struct AstronomyMeta: Codable {
    let cost: Int
    let dailyQuota: Int
    let lat: Double
    let lng: Double
    let requestCount: Int
    let start: String
}
