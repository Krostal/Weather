

import Foundation

struct DailyTimePeriod {
    
    let dailyForecast: [String: [TimePeriod]]
    
    init?(model: Weather) {
        guard let timePeriodSet = model.timePeriod,
              let timePeriod = Array(timePeriodSet) as? [TimePeriod] else {
            return nil
        }
        
        // Конвертируем в местный часовой пояс и отсеиваем текущий день
        let timePeriodForNextDays = timePeriod.filter {
            if let time = $0.time {
                if let savedTime = ISO8601DateFormatter().date(from: time) {
                    let formattedTime = CustomDateFormatter().formattedStringDate(date: savedTime, dateFormat: "yyyy-MM-dd")
                    return CustomDateFormatter().formattedStringDate(date: Date(), dateFormat: "yyyy-MM-dd") != formattedTime
                }
            }
            return true
        }
        
        // Конвертируем в формат времени UTC, так как из JSON мы получаем именно такой формат
        let forecast = timePeriodForNextDays.filter {
            if let time = $0.time,
               let _ = CustomDateFormatter().fromStringInCurrentTimeZoneToStringInUTC(date: time) {
                return true
            }
            return true
        }
        
        // оставляем 4 временных периода
        let timesToKeep = ["00:00:00Z", "06:00:00Z", "12:00:00Z", "18:00:00Z"]
        
        let filteredTimePeriods = forecast.filter { timePeriod in
            if let time = timePeriod.time,
               let timeComponents = time.components(separatedBy: "T").last {
                return timesToKeep.contains(timeComponents)
            }
            return false
        }
        
        //  dailyForecast содержит отформатированную дату прогнозного дня с массивом данных на утро, день, вечер, ночь.
        
        var dailyForecast: [String: [TimePeriod]] = [:]
        var currentDayIndex: Int = 1
        var partsOfDay: [TimePeriod] = []
        
        for (index, timePeriod) in filteredTimePeriods.dropFirst().enumerated() {
            partsOfDay.append(timePeriod)
            
            if partsOfDay.count == 4 || index == filteredTimePeriods.count - 2 {
                let dateForDayKey = CustomDateFormatter().formattedStringDate(date: Date().addingTimeInterval(TimeInterval(currentDayIndex) * 24 * 60 * 60), dateFormat: "dd/MM")
                dailyForecast[dateForDayKey] = partsOfDay
                partsOfDay = []
                currentDayIndex += 1
            }
        }
        
        self.dailyForecast = dailyForecast
    }
    
}
