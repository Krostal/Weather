

import Foundation

struct CurrentTimePeriod {
    let instantData: InstantData
    let next1HoursForecast: Next1HoursForecast
    let next6HoursForecast: Next6HoursForecast

    init?(model: Weather) {
        guard let timePeriodSet = model.timePeriod,
              let timePeriodArray = Array(timePeriodSet) as? [TimePeriod],
              let currentTimePeriod = timePeriodArray.first(where: { timePeriod in
                  if let currentTime = timePeriod.time?.prefix(13) {
                      return currentTime == CustomDateFormatter().formattedCurrentDate(dateFormat: "yyyy-MM-dd'T'HH", locale: nil, timeZone: TimeZone(identifier: "UTC"))
                  }
                  return false
              }),
              let instantData = currentTimePeriod.timePeriodData?.instantData,
              let next1Hoursforecast = currentTimePeriod.timePeriodData?.next1HoursForecast,
              let next6Hoursforecast = currentTimePeriod.timePeriodData?.next6HoursForecast else {
            return nil
        }

        self.instantData = instantData
        self.next1HoursForecast = next1Hoursforecast
        self.next6HoursForecast = next6Hoursforecast
    }
}
