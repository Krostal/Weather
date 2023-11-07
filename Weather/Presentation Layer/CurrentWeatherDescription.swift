

import Foundation

enum CurrentWeatherDescription: String, CaseIterable {
    case clearsky_day = "clearsky_day"
    case clearsky_night = "clearsky_night"
    case clearsky_polartwilight = "clearsky_polartwilight"
    case fair_day = "fair_day"
    case fair_night = "fair_night"
    case fair_polartwilight = "fair_polartwilight"
    case partlycloudy_day = "partlycloudy_day"
    case partlycloudy_night = "partlycloudy_night"
    case partlycloudy_polartwilight = "partlycloudy_polartwilight"
    case cloudy = "cloudy"
    case rainshowers_day = "rainshowers_day"
    case rainshowers_night = "rainshowers_night"
    case rainshowers_polartwilight = "rainshowers_polartwilight"
    case rainshowersandthunder_day = "rainshowersandthunder_day"
    case rainshowersandthunder_night = "rainshowersandthunder_night"
    case rainshowersandthunder_polartwilight = "rainshowersandthunder_polartwilight"
    case sleetshowers_day = "sleetshowers_day"
    case sleetshowers_night = "sleetshowers_night"
    case sleetshowers_polartwilight = "sleetshowers_polartwilight"
    case snowshowers_day = "snowshowers_day"
    case snowshowers_night = "snowshowers_night"
    case snowshowers_polartwilight = "snowshowers_polartwilight"
    case rain = "rain"
    case heavyrain = "heavyrain"
    case heavyrainandthunder = "heavyrainandthunder"
    case sleet = "sleet"
    case snow = "snow"
    case snowandthunder = "snowandthunder"
    case fog = "fog"
    case sleetshowersandthunder_day = "sleetshowersandthunder_day"
    case sleetshowersandthunder_night = "sleetshowersandthunder_night"
    case sleetshowersandthunder_polartwilight = "sleetshowersandthunder_polartwilight"
    case snowshowersandthunder_day = "snowshowersandthunder_day"
    case snowshowersandthunder_night = "snowshowersandthunder_night"
    case snowshowersandthunder_polartwilight = "snowshowersandthunder_polartwilight"
    case rainandthunder = "rainandthunder"
    case sleetandthunder = "sleetandthunder"
    case lightrainshowersandthunder_day = "lightrainshowersandthunder_day"
    case lightrainshowersandthunder_night = "lightrainshowersandthunder_night"
    case lightrainshowersandthunder_polartwilight = "lightrainshowersandthunder_polartwilight"
    case heavyrainshowersandthunder_day = "heavyrainshowersandthunder_day"
    case heavyrainshowersandthunder_night = "heavyrainshowersandthunder_night"
    case heavyrainshowersandthunder_polartwilight = "heavyrainshowersandthunder_polartwilight"
    case lightssleetshowersandthunder_day = "lightssleetshowersandthunder_day"
    case lightssleetshowersandthunder_night = "lightssleetshowersandthunder_night"
    case lightssleetshowersandthunder_polartwilight = "lightssleetshowersandthunder_polartwilight"
    case heavysleetshowersandthunder_day = "heavysleetshowersandthunder_day"
    case heavysleetshowersandthunder_night = "heavysleetshowersandthunder_night"
    case heavysleetshowersandthunder_polartwilight = "heavysleetshowersandthunder_polartwilight"
    case lightssnowshowersandthunder_day = "lightssnowshowersandthunder_day"
    case lightssnowshowersandthunder_night = "lightssnowshowersandthunder_night"
    case lightssnowshowersandthunder_polartwilight = "lightssnowshowersandthunder_polartwilight"
    case heavysnowshowersandthunder_day = "heavysnowshowersandthunder_day"
    case heavysnowshowersandthunder_night = "heavysnowshowersandthunder_night"
    case heavysnowshowersandthunder_polartwilight = "heavysnowshowersandthunder_polartwilight"
    case lightrainandthunder = "lightrainandthunder"
    case lightsleetandthunder = "lightsleetandthunder"
    case heavysleetandthunder = "heavysleetandthunder"
    case lightsnowandthunder = "lightsnowandthunder"
    case heavysnowandthunder = "heavysnowandthunder"
    case lightrainshowers_day = "lightrainshowers_day"
    case lightrainshowers_night = "lightrainshowers_night"
    case lightrainshowers_polartwilight = "lightrainshowers_polartwilight"
    case heavyrainshowers_day = "heavyrainshowers_day"
    case heavyrainshowers_night = "heavyrainshowers_night"
    case heavyrainshowers_polartwilight = "heavyrainshowers_polartwilight"
    case lightsleetshowers_day = "lightsleetshowers_day"
    case lightsleetshowers_night = "lightsleetshowers_night"
    case lightsleetshowers_polartwilight = "lightsleetshowers_polartwilight"
    case heavysleetshowers_day = "heavysleetshowers_day"
    case heavysleetshowers_night = "heavysleetshowers_night"
    case heavysleetshowers_polartwilight = "heavysleetshowers_polartwilight"
    case lightsnowshowers_day = "lightsnowshowers_day"
    case lightsnowshowers_night = "lightsnowshowers_night"
    case lightsnowshowers_polartwilight = "lightsnowshowers_polartwilight"
    case heavysnowshowers_day = "heavysnowshowers_day"
    case heavysnowshowers_night = "heavysnowshowers_night"
    case heavysnowshowers_polartwilight = "heavysnowshowers_polartwilight"
    case lightrain = "lightrain"
    case lightsleet = "lightsleet"
    case heavysleet = "heavysleet"
    case lightsnow = "lightsnow"
    case heavysnow = "heavysnow"

    var description: String {
        switch self {
        case .clearsky_day, .clearsky_night, .clearsky_polartwilight:
            return "Ясно"
        case .fair_day, .fair_night, .fair_polartwilight:
            return "Малооблачно"
        case .partlycloudy_day, .partlycloudy_night, .partlycloudy_polartwilight:
            return "Переменная облачность"
        case .cloudy:
            return "Облачно"
        case .rainshowers_day, .rainshowers_night, .rainshowers_polartwilight:
            return "Ливень"
        case .rainshowersandthunder_day, .rainshowersandthunder_night, .rainshowersandthunder_polartwilight:
            return "Ливень с грозой"
        case .sleetshowers_day, .sleetshowers_night, .sleetshowers_polartwilight:
            return "Снег с дождем"
        case .snowshowers_day, .snowshowers_night, .snowshowers_polartwilight:
            return "Снегопад"
        case .rain:
            return "Дождь"
        case .heavyrain:
            return "Сильный дождь"
        case .heavyrainandthunder:
            return "Сильный дождь с грозой"
        case .sleet:
            return "Мокрый снег"
        case .snow:
            return "Снег"
        case .snowandthunder:
            return "Снег с грозой"
        case .fog:
            return "Туман"
        case .sleetshowersandthunder_day, .sleetshowersandthunder_night, .sleetshowersandthunder_polartwilight:
            return "Снег с дождем и с грозой"
        case .snowshowersandthunder_day, .snowshowersandthunder_night, .snowshowersandthunder_polartwilight:
            return "Снегопад с грозой"
        case .rainandthunder:
            return "Дождь с грозой"
        case .sleetandthunder:
            return "Мокрый снег с грозой"
        case .lightrainshowersandthunder_day, .lightrainshowersandthunder_night, .lightrainshowersandthunder_polartwilight:
            return "Небольшой ливень с грозой"
        case .heavyrainshowersandthunder_day, .heavyrainshowersandthunder_night, .heavyrainshowersandthunder_polartwilight:
            return "Сильный ливень с грозой"
        case .lightssleetshowersandthunder_day, .lightssleetshowersandthunder_night, .lightssleetshowersandthunder_polartwilight:
            return "Легкий мокрый снег с грозой"
        case .heavysleetshowersandthunder_day, .heavysleetshowersandthunder_night, .heavysleetshowersandthunder_polartwilight:
            return "Сильный мокрый снег с грозой"
        case .lightssnowshowersandthunder_day, .lightssnowshowersandthunder_night, .lightssnowshowersandthunder_polartwilight:
            return "Легкий снегопад с грозой"
        case .heavysnowshowersandthunder_day, .heavysnowshowersandthunder_night, .heavysnowshowersandthunder_polartwilight:
            return "Сильный снегопад с грозой"
        case .lightrainandthunder:
            return "Легкий дождь с грозой"
        case .lightsleetandthunder:
            return "Небольшой снег с дождем и с грозой"
        case .heavysleetandthunder:
            return "Сильный снег с дождем и с грозой"
        case .lightsnowandthunder:
            return "Легкий снег с грозой"
        case .heavysnowandthunder:
            return "Сильный снег с грозой"
        case .lightrainshowers_day, .lightrainshowers_night, .lightrainshowers_polartwilight:
            return "Слабый ливень"
        case .heavyrainshowers_day, .heavyrainshowers_night, .heavyrainshowers_polartwilight:
            return "Сильный ливень"
        case .lightsleetshowers_day, .lightsleetshowers_night, .lightsleetshowers_polartwilight:
            return "Легкий снег с дождем"
        case .heavysleetshowers_day, .heavysleetshowers_night, .heavysleetshowers_polartwilight:
            return "Сильный снег с дождем"
        case .lightsnowshowers_day, .lightsnowshowers_night, .lightsnowshowers_polartwilight:
            return "Легкий снегопад"
        case .heavysnowshowers_day, .heavysnowshowers_night, .heavysnowshowers_polartwilight:
            return "Сильный снегопад"
        case .lightrain:
            return "Небольшой дождь"
        case .lightsleet:
            return "Небольшой снег с дождем"
        case .heavysleet:
            return "Сильный мокрый снег"
        case .lightsnow:
            return "Легкий снег"
        case .heavysnow:
            return "Сильный снег"
        }
    }

    init?(symbolCode: String) {
        self.init(rawValue: symbolCode)
    }
}

