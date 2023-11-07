

import UIKit

public enum AirQualityDescription: String {
    case good = "Хорошо"
    case moderate = "Умеренно"
    case unhealthyForSensitiveGroups = "Опасно для чувствительных групп"
    case unhealthy = "Опасно"
    case veryUnhealthy = "Очень опасно"
    case hazardous = "Экстремально опасно"
    
    init(pm25Index: Int64) {
        if pm25Index >= 0 && pm25Index <= 50 {
            self = .good
        } else if pm25Index >= 51 && pm25Index <= 100 {
            self = .moderate
        } else if pm25Index >= 101 && pm25Index <= 150 {
            self = .unhealthyForSensitiveGroups
        } else if pm25Index >= 151 && pm25Index <= 200 {
            self = .unhealthy
        } else if pm25Index >= 201 && pm25Index <= 300 {
            self = .veryUnhealthy
        } else {
            self = .hazardous
        }
    }
    
    var description: String {
        switch self {
        case .good:
            return "Качество воздуха считается удовлетворительным, и загрязнение воздуха представляется незначительным в пределах нормы"
        case .moderate:
            return "Качество воздуха является приемлемым; однако некоторые загрязнители могут представлять опасность для людей, являющихся особо чувствительным к загрязнению воздуха"
        case .unhealthyForSensitiveGroups:
            return "Может оказывать эффект на особо чувствительную группу лиц. На среднего представителя не оказывает видимого воздействия."
        case .unhealthy:
            return "Каждый может начать испытывать последствия для своего здоровья; особо чувствительные люди могут испытывать более серьезные последствия"
        case .veryUnhealthy:
            return "Опасность для здоровья от чрезвычайных условий. Это отразится, вероятно, на всем населении"
        case .hazardous:
            return "Опасность для здоровья: каждый человек может испытывать более серьезные последствия для здоровья"
        }
    }
    
    var color: UIColor {
        switch self {
        case .good:
            return .systemMint
        case .moderate:
            return .systemYellow
        case .unhealthyForSensitiveGroups:
            return .systemOrange
        case .unhealthy:
            return .systemRed
        case .veryUnhealthy:
            return .systemPurple
        case .hazardous:
            return .systemBrown
        }
    }
}
