

import Foundation

struct HourlyTimePeriod {
    let time: String
    let instantData: InstantData
    let next1HoursForecast: Next1HoursForecast

    init?(model: Weather, index: Int) {
        guard let timePeriodSet = model.timePeriod,
              let timePeriodArray = Array(timePeriodSet.prefix(24)) as? [TimePeriod],
              index < timePeriodArray.count,
              let currentData = timePeriodArray[index].timePeriodData?.instantData,
              let next1Hoursforecast = timePeriodArray[index].timePeriodData?.next1HoursForecast,
              let time = timePeriodArray[index].time,
              let savedTime = ISO8601DateFormatter().date(from: time) else {
            return nil
        }

        self.time = CustomDateFormatter().formattedStringDate(date: savedTime, dateFormat: "HH:mm")
        self.instantData = currentData
        self.next1HoursForecast = next1Hoursforecast
    }
}
