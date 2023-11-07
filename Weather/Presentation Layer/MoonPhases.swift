

import Foundation

public enum MoonPhases: String {
    case newMoon = "Новолуние"
    case waxingCrescent = "Растущий месяц"
    case firstQuarter = "Первая четверть"
    case waxingGibbous = "Растущая луна"
    case fullMoon = "Полнолуние"
    case waningGibbous = "Убывающая луна"
    case thirdQuarter = "Третья четверть"
    case waningCrescent = "Убывающий месяц"
    case unknown = "Неизвестное значение"
    
    
    init(value: Double) {
        if value >= 0.99 || value <= 0.01 {
            self = .newMoon
        } else if value >= 0.24 && value <= 0.26 {
            self = .firstQuarter
        } else if value >= 0.49 && value <= 0.51 {
            self = .fullMoon
        } else if value >= 0.74 && value <= 0.76 {
            self = .thirdQuarter
        } else if value > 0.01 && value < 0.24 {
            self = .waxingCrescent
        } else if value > 0.26 && value < 0.49 {
            self = .waxingGibbous
        } else if value > 0.51 && value < 0.74 {
            self = .waningGibbous
        } else if value > 0.76 && value < 0.99 {
            self = .waningCrescent
        } else {
            self = .unknown
        }
    }
    
    var systemImageName: String{
        switch self {
        case .newMoon:
            return "moonphase.new.moon"
        case .waxingCrescent:
            return "moonphase.waxing.crescent"
        case .firstQuarter:
            return "moonphase.first.quarter"
        case .waxingGibbous:
            return "moonphase.waxing.gibbous"
        case .fullMoon:
            return "moonphase.full.moon"
        case .waningGibbous:
            return "moonphase.waning.gibbous"
        case .thirdQuarter:
            return "moonphase.last.quarter"
        case .waningCrescent:
            return "moonphase.waning.crescent"
        case .unknown:
            return "moon.zzz"
        }
        
    }
}
