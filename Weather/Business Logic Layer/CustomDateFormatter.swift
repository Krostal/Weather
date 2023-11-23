
import Foundation

struct CustomDateFormatter {
    
    func formattedCurrentDate(dateFormat: String, locale: Locale?, timeZone: TimeZone?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    func formattedDateToString(date: Date, dateFormat: String, locale: Locale?, timeZone: TimeZone?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }
    
    func fromStringInCurrentTimeZoneToStringInUTC(date: String, timeZone: TimeZone?) -> String? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone =  timeZone
        
        if let localDate = dateFormatter.date(from: date) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            return dateFormatter.string(from: localDate)
        }
        return nil
    }
    
    func formattedStringToString(date: String, dateFormat: String, locale: Locale?, timeZone: TimeZone?) -> String? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone =  TimeZone.current
        
        if let utcDate = dateFormatter.date(from: date) {
            let secondDateFormatter = DateFormatter()
            secondDateFormatter.dateFormat = dateFormat
            secondDateFormatter.locale = locale
            secondDateFormatter.timeZone = timeZone
            let localDate = secondDateFormatter.string(from: utcDate)
            return localDate
        }
        return nil
    }
    
    func formattedStringToDate(date: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: date)
    }
}
