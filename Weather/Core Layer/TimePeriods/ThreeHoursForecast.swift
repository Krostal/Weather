

import Foundation

struct ThreeHoursForecast {
    
    let index: Int
    let time: String
    let instantData: InstantData
    let next1HoursForecast: Next1HoursForecast
    let timeZone: String?
        
    init(index: Int, time: String, timeZone: String?, instantData: InstantData, next1HoursForecast: Next1HoursForecast, timeStringFullInUTC: String) {
        self.index = index
        self.time = time
        self.instantData = instantData
        self.next1HoursForecast = next1HoursForecast
        self.timeZone = timeZone
    }
}
