

import Foundation

struct DailyTimePeriod {
    
    private let dateFormatter = CustomDateFormatter()
        
    var dailyForecast: [Date: [TimePeriod]]
    
    init() {
        self.dailyForecast = [:]
    }
        
    init?(model: Weather) {
        self.dailyForecast = [:]
        guard let timePeriodSet = model.timePeriod,
              let timePeriod = Array(timePeriodSet) as? [TimePeriod]
        else {
            return nil
        }
        
        let filteredTimePeriod = filterAndFormatTimePeriods(timePeriod)
        self.dailyForecast = groupTimePeriodsByDay(filteredTimePeriod)
    }
        
    private func filterAndFormatTimePeriods(_ timePeriod: [TimePeriod]) -> [TimePeriod] {
        
        let timePeriodForNextDays = timePeriod.filter {
            if let time = $0.time {
                if let savedTime = ISO8601DateFormatter().date(from: time) {
                    let formattedTime = dateFormatter.formattedStringDate(date: savedTime, dateFormat: "yyyy-MM-dd")
                    return dateFormatter.formattedStringDate(date: Date(), dateFormat: "yyyy-MM-dd") != formattedTime
                }
            }
            return true
        }
        
        let forecast = timePeriodForNextDays.filter {
            if let time = $0.time,
               let _ = dateFormatter.fromStringInCurrentTimeZoneToStringInUTC(date: time) {
                return true
            }
            return true
        }
        
        let timesToKeep = ["00:00:00Z", "06:00:00Z", "12:00:00Z", "18:00:00Z"]
        
        let filteredTimePeriods = forecast.filter { timePeriod in
            if let time = timePeriod.time,
               let timeComponents = time.components(separatedBy: "T").last {
                return timesToKeep.contains(timeComponents)
            }
            return false
        }
        
        return filteredTimePeriods
    }
        
    private func groupTimePeriodsByDay(_ timePeriod: [TimePeriod]) -> [Date: [TimePeriod]] {
        
        var dailyForecast: [Date: [TimePeriod]] = [:]
        var currentDayIndex = 1
        var partsOfDay: [TimePeriod] = []
        let currentDate = Date()
        
        for (index, time) in timePeriod.dropFirst().enumerated() {
            partsOfDay.append(time)
            
            if partsOfDay.count == 4 || index == timePeriod.count - 2 {
                if let dateForDayKey = Calendar.current.date(byAdding: .day, value: currentDayIndex, to: currentDate),
                   partsOfDay.count > 1 {
                    dailyForecast[dateForDayKey] = partsOfDay
                }
                partsOfDay = []
                currentDayIndex += 1
            }
        }
        
        return dailyForecast
    }
}
