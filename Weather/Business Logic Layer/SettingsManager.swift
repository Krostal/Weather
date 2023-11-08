

import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    let userDefaults = UserDefaults.standard
    
    var settings: Settings {
        didSet {
            userDefaults.set(settings.temperatureUnit.rawValue, forKey: UserDefaultsKeys.temperatureUnit)
            userDefaults.set(settings.windSpeedUnit.rawValue, forKey: UserDefaultsKeys.windSpeedUnit)
            userDefaults.set(settings.timeFormat.rawValue, forKey: UserDefaultsKeys.timeFormat)
            userDefaults.set(settings.precipitationUnit.rawValue, forKey: UserDefaultsKeys.precipitationUnit)
        }
    }
    
    private init() {
        let temperatureUnitRawValue = userDefaults.string(forKey: UserDefaultsKeys.temperatureUnit) ?? TemperatureUnit.celsius.rawValue
        let windSpeedUnitRawValue = userDefaults.string(forKey: UserDefaultsKeys.windSpeedUnit) ?? WindSpeedUnit.metersPerSecond.rawValue
        let timeFormatRawValue = userDefaults.string(forKey: UserDefaultsKeys.timeFormat) ?? TimeFormat.twentyFourHour.rawValue
        let precipitationUnitRawValue = userDefaults.string(forKey: UserDefaultsKeys.precipitationUnit) ?? PrecipitationUnit.millimeters.rawValue
        
        self.settings = Settings(
            temperatureUnit: TemperatureUnit(rawValue: temperatureUnitRawValue) ?? .celsius,
            windSpeedUnit: WindSpeedUnit(rawValue: windSpeedUnitRawValue) ?? .metersPerSecond,
            timeFormat: TimeFormat(rawValue: timeFormatRawValue) ?? .twentyFourHour,
            precipitationUnit: PrecipitationUnit(rawValue: precipitationUnitRawValue) ?? .millimeters
        )
    }
}
