
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
    
    func formattedStringDate(date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
    
    func fromStringInCurrentTimeZoneToStringInUTC(date: String) -> String? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone =  TimeZone.current
        
        if let localDate = dateFormatter.date(from: date) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            return dateFormatter.string(from: localDate)
        }
        return nil
    }
}
