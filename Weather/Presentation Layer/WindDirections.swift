

import Foundation

public enum WindDirection: String, CaseIterable {
    case north = "С"
    case northNortheast = "ССВ"
    case northeast = "СВ"
    case eastNortheast = "ВВС"
    case east = "В"
    case eastSoutheast = "ВЮВ"
    case southeast = "ЮВ"
    case southSoutheast = "ЮЮВ"
    case south = "Ю"
    case southSouthwest = "ЮЮЗ"
    case southwest = "ЮЗ"
    case westSouthwest = "ЗЮЗ"
    case west = "З"
    case westNorthwest = "ЗСЗ"
    case northwest = "СЗ"
    case northNorthwest = "ССЗ"
    
    init(degrees: Float) {
        let index = Int(((degrees + 11.25) / 22.5).truncatingRemainder(dividingBy: 16))
        self = WindDirection.allCases[index]
    }
}
