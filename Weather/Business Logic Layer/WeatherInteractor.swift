import Foundation
import CoreData

protocol WeatherInteractorProtocol {
    func fetchWeatherFromNetwork(completion: @escaping (Result<Void, Error>) -> Void)
    func getWeatherFromCoreData(completion: @escaping ([Weather]) -> Void)
    func getCitiesWithWeatherData(completion: @escaping ([Weather]) -> Void)
    func checkPermission(completion: @escaping (Bool) -> Void)
    func isDetermind() -> Bool
    func isAuthorizedToUseLocation() -> Bool
    func updateCoordinates(with coordinates: (latitude: Double, longitude: Double))
    func updateWeatherInCoreData(coordinates: (latitude: Double, longitude: Double), locationName: String?, completion: @escaping (Result<Weather, Error>) -> Void)
}

final class WeatherInteractor: WeatherInteractorProtocol {
    
    private let defaultValue: Float = 3.33
    private let fetchDataService = FetchDataService()
    private let coreDataService = CoreDataService.shared
    private let locationService = LocationService()
    private let context = CoreDataService.shared.setContext()
    private var locationName: String?
    var currentCoordinates: (latitude: Double, longitude: Double)?
    
    private var weatherJsonModel: WeatherJsonModel?
    private var astronomyJsonModel: AstronomyJsonModel?
    private var airQualityJsonModel: AirQualityJsonModel?
    
    func updateCoordinates(with coordinates: (latitude: Double, longitude: Double)) {
        locationService.currentCoordinates = coordinates
        locationService.withCurrentLocation = false
    }
    
    func updateWeatherInCoreData(coordinates: (latitude: Double, longitude: Double), locationName: String?, completion: @escaping (Result<Weather, Error>) -> Void) {
        
        let currentDate = CustomDateFormatter().formattedCurrentDate(dateFormat: "yyyy-MM-dd", locale: nil, timeZone: nil)
        
        self.locationName = locationName
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        self.fetchDataService.fetchWeatherData(coordinates: (coordinates.latitude, coordinates.longitude)) { [weak self] result in
            print(locationName)
            guard let self else { return }
            
            switch result {
            case .success(let weatherJsonModel):
                self.weatherJsonModel = weatherJsonModel
            case .failure(let error):
                print("Error fetching weather data: \(error.description)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        if let location = locationName,
           !coreDataService.isAstronomyDataAlreadyExist(start: currentDate, locationName: location) {
            self.fetchDataService.fetchAstronomyData(coordinates: (coordinates.latitude, coordinates.longitude)) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let astronomyJsonModel):
                    self.astronomyJsonModel = astronomyJsonModel
                case .failure(let error):
                    print("Error fetching weather data: \(error.description)")
                }
                dispatchGroup.leave()
            }
        } else {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        
        self.fetchDataService.fetchAirQualityData(coordinates: (coordinates.latitude, coordinates.longitude)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let airQualityJsonModel):
                self.airQualityJsonModel = airQualityJsonModel
            case .failure(let error):
                print("Error fetching weather data: \(error.description)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.saveWeatherToCoreData { result in
                switch result {
                case .success(let weather):
                    completion(.success((weather)))
                case .failure(_ ):
                    completion(.failure(CoreDataError.savingError))
                }
            }
        }
    }
    
    func fetchWeatherFromNetwork(completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let coordinates = locationService.currentCoordinates else { return }
        
        locationService.getLocationName { [weak self] name in
            guard let self else { return }
            self.locationName = name
            
            let currentDate = CustomDateFormatter().formattedCurrentDate(dateFormat: "yyyy-MM-dd", locale: nil, timeZone: nil)
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            self.fetchDataService.fetchWeatherData(coordinates: (coordinates.latitude, coordinates.longitude)) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let weatherJsonModel):
                    self.weatherJsonModel = weatherJsonModel
                case .failure(let error):
                    print("Error fetching weather data: \(error.description)")
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            guard let location = locationName else { return }
            
            if !coreDataService.isAstronomyDataAlreadyExist(start: currentDate, locationName: location) {
                self.fetchDataService.fetchAstronomyData(coordinates: (coordinates.latitude, coordinates.longitude)) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let astronomyJsonModel):
                        self.astronomyJsonModel = astronomyJsonModel
                    case .failure(let error):
                        print("Error fetching weather data: \(error.description)")
                    }
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            
            self.fetchDataService.fetchAirQualityData(coordinates: (coordinates.latitude, coordinates.longitude)) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let airQualityJsonModel):
                    self.airQualityJsonModel = airQualityJsonModel
                case .failure(let error):
                    print("Error fetching weather data: \(error.description)")
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                self.saveWeatherToCoreData() { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        print("Error saving Weather to Core Data: \(error)")
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func getWeatherFromCoreData(completion: @escaping ([Weather]) -> Void) {
        guard let location = locationName else { return }
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        let predicate = NSPredicate(format: "locationName == %@", location)
        request.predicate = predicate
        
        do {
            let results = try self.context.fetch(request)
            completion(results)
        } catch {
            print("Error fetching weather data: \(error.localizedDescription)")
        }
    }
    
    func getCitiesWithWeatherData(completion: @escaping ([Weather]) -> Void) {
        let weatherArray = coreDataService.getWeather()
        completion(weatherArray)
    }
    
    func checkPermission(completion: @escaping (Bool) -> Void) {
        if locationService.isLocationAuthorized {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func isDetermind() -> Bool {
        return locationService.isDetermined
    }
    
    func isAuthorizedToUseLocation() -> Bool {
        return locationService.isLocationAuthorized
    }
    
    private func saveWeatherToCoreData(completion: @escaping (Result<Weather, Error>) -> Void) {
        
        guard let locationName,
              let weather = weatherJsonModel
        else {
            return
        }
        if let existingWeatherModel = coreDataService.getWeatherData(locationName: locationName) {
            print(locationName)
            let updatedAt = weather.properties.meta.updatedAt
            print(updatedAt)
            if coreDataService.isWeatherDataAlreadyExist(updatedAt: updatedAt, locationName: locationName) {
                print(coreDataService.isWeatherDataAlreadyExist(updatedAt: updatedAt, locationName: locationName))
                print("Текущая модель Weather для \(locationName) актуальна и не требует обновления")
                completion(.success((existingWeatherModel)))
                return
            } else {
                if let existingWeatherData = existingWeatherModel.weatherData {
                    self.context.delete(existingWeatherData)
                }
                
                let weatherDataCoreDataModel = WeatherData(context: self.context)
                
                weatherDataCoreDataModel.updatedAt = updatedAt

                for timeSeries in weather.properties.timeseries {
                    let timePeriod = TimePeriod(context: self.context)
                    
                    timePeriod.time = timeSeries.time
                    
                    let timePeriodData = TimePeriodData(context: self.context)
                    let instantData = InstantData(context: self.context)
                    let next1HoursForecast = Next1HoursForecast(context: self.context)
                    let next6HoursForecast = Next6HoursForecast(context: self.context)
                    let next12HoursForecast = Next12HoursForecast(context: self.context)
                    
                    if let instantDetails = timeSeries.data.instant.details {
                        instantData.airPressureAtSeaLevel = instantDetails.airPressureAtSeaLevel ?? defaultValue
                        instantData.airTemperature = instantDetails.airTemperature ?? defaultValue
                        instantData.airTemperaturePercentile10 = instantDetails.airTemperaturePercentile10 ?? defaultValue
                        instantData.airTemperaturePercentile90 = instantDetails.airTemperaturePercentile90 ?? defaultValue
                        instantData.cloudAreaFraction = instantDetails.cloudAreaFraction ?? defaultValue
                        instantData.cloudAreaFractionHigh = instantDetails.cloudAreaFractionHigh ?? defaultValue
                        instantData.cloudAreaFractionLow = instantDetails.cloudAreaFractionLow ?? defaultValue
                        instantData.cloudAreaFractionMedium = instantDetails.cloudAreaFractionMedium ?? defaultValue
                        instantData.dewPointTemperature = instantDetails.dewPointTemperature ?? defaultValue
                        instantData.fogAreaFraction = instantDetails.fogAreaFraction ?? defaultValue
                        instantData.relativeHumidity = instantDetails.relativeHumidity ?? defaultValue
                        instantData.ultravioletIndexClearSky = instantDetails.ultravioletIndexClearSky ?? defaultValue
                        instantData.windFromDirection = instantDetails.windFromDirection ?? defaultValue
                        instantData.windSpeed = instantDetails.windSpeed ?? defaultValue
                        instantData.windSpeedOfGust = instantDetails.windSpeedOfGust ?? defaultValue
                        instantData.windSpeedPercentile10 = instantDetails.windSpeedPercentile10 ?? defaultValue
                        instantData.windSpeedPercentile90 = instantDetails.windSpeedPercentile90 ?? defaultValue
                    }
                    
                    if let next1Hours = timeSeries.data.next1Hours {
                        if let details = next1Hours.details {
                            next1HoursForecast.precipitationAmount = details.precipitationAmount ?? defaultValue
                            next1HoursForecast.precipitationAmountMax = details.precipitationAmountMax ?? defaultValue
                            next1HoursForecast.precipitationAmountMin = details.precipitationAmountMin ?? defaultValue
                            next1HoursForecast.probabilityOfPrecipitation = details.probabilityOfPrecipitation ?? defaultValue
                            next1HoursForecast.probabilityOfThunder = details.probabilityOfThunder ?? defaultValue
                        }
                        if let summary = next1Hours.summary {
                            next1HoursForecast.symbolCode = summary.symbolCode
                        }
                    }
                    
                    if let next6Hours = timeSeries.data.next6Hours {
                        if let details = next6Hours.details {
                            next6HoursForecast.airTemperatureMax = details.airTemperatureMax ?? defaultValue
                            next6HoursForecast.airTemperatureMin = details.airTemperatureMin ?? defaultValue
                            next6HoursForecast.precipitationAmount = details.precipitationAmount ?? defaultValue
                            next6HoursForecast.precipitationAmountMax = details.precipitationAmountMax ?? defaultValue
                            next6HoursForecast.precipitationAmountMin = details.precipitationAmountMin ?? defaultValue
                            next6HoursForecast.probabilityOfPrecipitation = details.probabilityOfPrecipitation ?? defaultValue
                        }
                        if let summary = next6Hours.summary {
                            next6HoursForecast.symbolCode = summary.symbolCode
                        }
                    }
                    
                    if let next12Hours = timeSeries.data.next12Hours {
                        
                        if let details = next12Hours.details {
                            next12HoursForecast.probabilityOfPrecipitation = details.probabilityOfPrecipitation ?? defaultValue
                        }
                        if let summary = next12Hours.summary {
                            next12HoursForecast.symbolCode = summary.symbolCode
                        }
                    }
                    
                    timePeriodData.instantData = instantData
                    timePeriodData.next1HoursForecast = next1HoursForecast
                    timePeriodData.next6HoursForecast = next6HoursForecast
                    timePeriodData.next12HoursForecast = next12HoursForecast
                    
                    timePeriod.timePeriodData = timePeriodData
                    
                    weatherDataCoreDataModel.addToTimePeriod(timePeriod)
                }
                
                existingWeatherModel.weatherData = weatherDataCoreDataModel
                print("Модель WeatherData для локации \(locationName) обновлена")
                
                if let airQuality = airQualityJsonModel {
                    
                    coreDataService.deleteExistingAirQualityModel(locationName: locationName)
                    
                    let airQualityCoreDataModel = AirQuality(context: self.context)
                    
                    let forecast = airQuality.data.forecast.daily
                    
                    for dailyValue in forecast.pm25 {
                        let airQualityForecast = AirQualityForecast(context: self.context)
                        airQualityForecast.day = dailyValue.day
                        airQualityForecast.index = Int64(dailyValue.avg)
                        airQualityCoreDataModel.addToAirQualityForecast(airQualityForecast)
                    }
                    
                    existingWeatherModel.airQuality = airQualityCoreDataModel
                    print("Модель AirQuality для локации \(locationName) обновлена")
                }
                
                if let astronomy = astronomyJsonModel {
                    
                    let start = astronomy.meta.start
                    
                    if !coreDataService.isAstronomyDataAlreadyExist(start: start, locationName: locationName) {
                        
                        let astronomyCoreDataModel = Astronomy(context: self.context)
                        astronomyCoreDataModel.start = astronomy.meta.start
                        
                        let forecast = astronomy.data
                        for dailyData in forecast {
                            let astronomyForecast = AstronomyForecast(context: self.context)
                            astronomyForecast.time = dailyData.time
                            astronomyForecast.moonPhase = dailyData.moonPhase.current.value
                            astronomyForecast.moonrise = dailyData.moonrise
                            astronomyForecast.moonset = dailyData.moonset
                            astronomyForecast.sunrise = dailyData.sunrise
                            astronomyForecast.sunset = dailyData.sunset
                            astronomyCoreDataModel.addToAstronomyForecast(astronomyForecast)
                        }
                        existingWeatherModel.astronomy = astronomyCoreDataModel
                        print("Модель Astronomy для локации \(locationName) обновлена")
                    }
                }
                
                do {
                    try self.context.save()
                    print("Модель Weather для локации \(locationName) обновлена и успешно сохранена в Core Data")
                    completion(.success((existingWeatherModel)))
                } catch {
                    completion(.failure(error))
                }
            }
        } else {
            // 2) Модель не сущестует - создаем новую
            let weatherCoreDataModel = Weather(context: self.context)
            
            let weatherDataCoreDataModel = WeatherData(context: self.context)
            
            weatherDataCoreDataModel.updatedAt = weather.properties.meta.updatedAt
            
            let coordinates = weather.geometry.coordinates
            
            weatherCoreDataModel.longitude = coordinates[0]
            weatherCoreDataModel.latitude = coordinates[1]
            weatherCoreDataModel.locationName = locationName
            
            for timeSeries in weather.properties.timeseries {
                let timePeriod = TimePeriod(context: self.context)
                
                timePeriod.time = timeSeries.time
                
                let timePeriodData = TimePeriodData(context: self.context)
                let instantData = InstantData(context: self.context)
                let next1HoursForecast = Next1HoursForecast(context: self.context)
                let next6HoursForecast = Next6HoursForecast(context: self.context)
                let next12HoursForecast = Next12HoursForecast(context: self.context)
                
                if let instantDetails = timeSeries.data.instant.details {
                    instantData.airPressureAtSeaLevel = instantDetails.airPressureAtSeaLevel ?? defaultValue
                    instantData.airTemperature = instantDetails.airTemperature ?? defaultValue
                    instantData.airTemperaturePercentile10 = instantDetails.airTemperaturePercentile10 ?? defaultValue
                    instantData.airTemperaturePercentile90 = instantDetails.airTemperaturePercentile90 ?? defaultValue
                    instantData.cloudAreaFraction = instantDetails.cloudAreaFraction ?? defaultValue
                    instantData.cloudAreaFractionHigh = instantDetails.cloudAreaFractionHigh ?? defaultValue
                    instantData.cloudAreaFractionLow = instantDetails.cloudAreaFractionLow ?? defaultValue
                    instantData.cloudAreaFractionMedium = instantDetails.cloudAreaFractionMedium ?? defaultValue
                    instantData.dewPointTemperature = instantDetails.dewPointTemperature ?? defaultValue
                    instantData.fogAreaFraction = instantDetails.fogAreaFraction ?? defaultValue
                    instantData.relativeHumidity = instantDetails.relativeHumidity ?? defaultValue
                    instantData.ultravioletIndexClearSky = instantDetails.ultravioletIndexClearSky ?? defaultValue
                    instantData.windFromDirection = instantDetails.windFromDirection ?? defaultValue
                    instantData.windSpeed = instantDetails.windSpeed ?? defaultValue
                    instantData.windSpeedOfGust = instantDetails.windSpeedOfGust ?? defaultValue
                    instantData.windSpeedPercentile10 = instantDetails.windSpeedPercentile10 ?? defaultValue
                    instantData.windSpeedPercentile90 = instantDetails.windSpeedPercentile90 ?? defaultValue
                }
                
                if let next1Hours = timeSeries.data.next1Hours {
                    if let details = next1Hours.details {
                        next1HoursForecast.precipitationAmount = details.precipitationAmount ?? defaultValue
                        next1HoursForecast.precipitationAmountMax = details.precipitationAmountMax ?? defaultValue
                        next1HoursForecast.precipitationAmountMin = details.precipitationAmountMin ?? defaultValue
                        next1HoursForecast.probabilityOfPrecipitation = details.probabilityOfPrecipitation ?? defaultValue
                        next1HoursForecast.probabilityOfThunder = details.probabilityOfThunder ?? defaultValue
                    }
                    if let summary = next1Hours.summary {
                        next1HoursForecast.symbolCode = summary.symbolCode
                    }
                }
                
                if let next6Hours = timeSeries.data.next6Hours {
                    if let details = next6Hours.details {
                        next6HoursForecast.airTemperatureMax = details.airTemperatureMax ?? defaultValue
                        next6HoursForecast.airTemperatureMin = details.airTemperatureMin ?? defaultValue
                        next6HoursForecast.precipitationAmount = details.precipitationAmount ?? defaultValue
                        next6HoursForecast.precipitationAmountMax = details.precipitationAmountMax ?? defaultValue
                        next6HoursForecast.precipitationAmountMin = details.precipitationAmountMin ?? defaultValue
                        next6HoursForecast.probabilityOfPrecipitation = details.probabilityOfPrecipitation ?? defaultValue
                    }
                    if let summary = next6Hours.summary {
                        next6HoursForecast.symbolCode = summary.symbolCode
                    }
                }
                
                if let next12Hours = timeSeries.data.next12Hours {
                    
                    if let details = next12Hours.details {
                        next12HoursForecast.probabilityOfPrecipitation = details.probabilityOfPrecipitation ?? defaultValue
                    }
                    if let summary = next12Hours.summary {
                        next12HoursForecast.symbolCode = summary.symbolCode
                    }
                }
                
                timePeriodData.instantData = instantData
                timePeriodData.next1HoursForecast = next1HoursForecast
                timePeriodData.next6HoursForecast = next6HoursForecast
                timePeriodData.next12HoursForecast = next12HoursForecast
                
                timePeriod.timePeriodData = timePeriodData
                
                weatherDataCoreDataModel.addToTimePeriod(timePeriod)
            }
            
            weatherCoreDataModel.weatherData = weatherDataCoreDataModel
            print("Модель WeatherData для локации \(locationName) создана и успешно сохранена")
            
            if let airQuality = airQualityJsonModel {
                
                let airQualityCoreDataModel = AirQuality(context: self.context)
                
                let forecast = airQuality.data.forecast.daily
                
                for dailyValue in forecast.pm25 {
                    let airQualityForecast = AirQualityForecast(context: self.context)
                    airQualityForecast.day = dailyValue.day
                    airQualityForecast.index = Int64(dailyValue.avg)
                    airQualityCoreDataModel.addToAirQualityForecast(airQualityForecast)
                }
                
                weatherCoreDataModel.airQuality = airQualityCoreDataModel
                print("Модель AirQuality для локации \(locationName) создана и успешно сохранена")
            }
            
            if let astronomy = astronomyJsonModel {
                
                let astronomyCoreDataModel = Astronomy(context: self.context)
                astronomyCoreDataModel.start = astronomy.meta.start
                
                let forecast = astronomy.data
                for dailyData in forecast {
                    let astronomyForecast = AstronomyForecast(context: self.context)
                    astronomyForecast.time = dailyData.time
                    astronomyForecast.moonPhase = dailyData.moonPhase.current.value
                    astronomyForecast.moonrise = dailyData.moonrise
                    astronomyForecast.moonset = dailyData.moonset
                    astronomyForecast.sunrise = dailyData.sunrise
                    astronomyForecast.sunset = dailyData.sunset
                    astronomyCoreDataModel.addToAstronomyForecast(astronomyForecast)
                }
                weatherCoreDataModel.astronomy = astronomyCoreDataModel
                print("Модель Astronomy для локации \(locationName) создана и успешно сохранена")
            }
            
            do {
                try self.context.save()
                print("Полученная модель Weather для \(locationName) успешно сохранена в Core Data")
                completion(.success((weatherCoreDataModel)))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
