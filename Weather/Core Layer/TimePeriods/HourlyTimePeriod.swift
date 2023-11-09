

import Foundation

struct HourlyTimePeriod {
    
    let time24Format: String
    let time12Format: String
    let instantData: InstantData
    let next1HoursForecast: Next1HoursForecast
    let timeStringFullInUTC: String
    
    init() {
        self.time24Format = ""
        self.time12Format = ""
        self.instantData = InstantData()
        self.next1HoursForecast = Next1HoursForecast()
        self.timeStringFullInUTC = ""
    }

    init?(weather: Weather, index: Int) {
        guard let weatherData = weather.weatherData,
              let timePeriodSet = weatherData.timePeriod,
              let timePeriodArray = Array(timePeriodSet.prefix(24)) as? [TimePeriod],
              index < timePeriodArray.count,
              let currentData = timePeriodArray[index].timePeriodData?.instantData,
              let next1Hoursforecast = timePeriodArray[index].timePeriodData?.next1HoursForecast,
              let time = timePeriodArray[index].time,
              let savedTime = ISO8601DateFormatter().date(from: time) else {
            return nil
        }

        self.time24Format = CustomDateFormatter().formattedDateToString(date: savedTime, dateFormat: "HH:mm", locale: nil)
        self.time12Format = CustomDateFormatter().formattedDateToString(date: savedTime, dateFormat: "hha", locale: nil)
        self.instantData = currentData
        self.next1HoursForecast = next1Hoursforecast
        self.timeStringFullInUTC = time
    }
}

extension HourlyTimePeriod {
    
    static func createForEveryThirdIndex(weather: Weather) -> [ThreeHoursForecast] {
        guard let weatherData = weather.weatherData,
              let timePeriodSet = weatherData.timePeriod,
              let timePeriodArray = Array(timePeriodSet.prefix(24)) as? [TimePeriod] else {
            return []
        }
        
        var threeHoursForecasts: [ThreeHoursForecast] = []
        
        for (index, timePeriod) in timePeriodArray.enumerated() where index % 3 == 0 {
            if let currentData = timePeriod.timePeriodData?.instantData,
               let next1Hoursforecast = timePeriod.timePeriodData?.next1HoursForecast,
               let time = timePeriod.time,
               let savedTime = ISO8601DateFormatter().date(from: time) {
                
                let formattedTime = CustomDateFormatter().formattedDateToString(date: savedTime, dateFormat: "HH", locale: nil)
                let timeStringFullInUTC = time
                
                let threeHoursForecast = ThreeHoursForecast(
                    index: index,
                    time: formattedTime,
                    instantData: currentData,
                    next1HoursForecast: next1Hoursforecast,
                    timeStringFullInUTC: timeStringFullInUTC
                )
                
                threeHoursForecasts.append(threeHoursForecast)
            }
        }
        
        return threeHoursForecasts
    }
}
