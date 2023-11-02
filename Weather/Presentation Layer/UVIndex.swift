

import Foundation

public enum UVIndex: String {
    case low = "Низкий"
    case moderate = "Умеренный"
    case high = "Высокий"
    case veryHigh = "Очень высокий"
    case extreme = "Экстремальный"
    
    init(ultraVioletIndex: Float) {
        if ultraVioletIndex >= 0.0 && ultraVioletIndex <= 2.0 {
            self = .low
        } else if ultraVioletIndex >= 3.0 && ultraVioletIndex <= 5.0 {
            self = .moderate
        } else if ultraVioletIndex >= 6.0 && ultraVioletIndex <= 7.0 {
            self = .high
        } else if ultraVioletIndex >= 8.0 && ultraVioletIndex <= 10.0 {
            self = .veryHigh
        } else {
            self = .extreme
        }
    }
}
