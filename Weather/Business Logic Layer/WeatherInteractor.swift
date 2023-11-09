import Foundation
import CoreData

protocol WeatherInteractorProtocol {
    func fetchWeatherFromNetwork(completion: @escaping (Result<Void, Error>) -> Void)
    func getWeatherFromCoreData(withPredicate predicate: NSPredicate?, completion: @escaping ([Weather]) -> Void)
    func checkPermission(completion: @escaping (Bool) -> Void)
    func isDetermined() -> Bool
}

final class WeatherInteractor: WeatherInteractorProtocol {
    
    private let defaultValue: Float = 3.33
    private let fetchDataService: FetchDataService
    private let coreDataService: CoreDataService
    private let locationService: LocationService
    private let context = CoreDataService.shared.setContext()
    private var locationName: String?
    
    private var weatherJsonModel: WeatherJsonModel?
    private var astronomyJsonModel: AstronomyJsonModel?
    private var airQualityJsonModel: AirQualityJsonModel?
    
    init(fetchDataService: FetchDataService, coreDataService: CoreDataService, locationService: LocationService) {
        self.fetchDataService = fetchDataService
        self.coreDataService = CoreDataService.shared
        self.locationService = locationService
    }
    
    func fetchWeatherFromNetwork(completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let coordinates = locationService.currentCoordinates else {
            return
        }
        
        locationService.getLocationName { [weak self] name in
            guard let self else { return }
            self.locationName = name
            
            print(coordinates)
            print(locationName)
            
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
            
            dispatchGroup.enter()
            if !coreDataService.isAstronomyDataAlreadyExist(start: currentDate, locationName: location) {
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
            } else {
                dispatchGroup.leave()
            }
            
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
    
    func getWeatherFromCoreData(withPredicate predicate: NSPredicate?, completion: @escaping ([Weather]) -> Void) {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            let results = try self.context.fetch(request)
            completion(results)
        } catch {
            print("Error fetching weather data: \(error.localizedDescription)")
        }
    }
    
    func checkPermission(completion: @escaping (Bool) -> Void) {
        if locationService.isLocationAuthorized {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func isDetermined() -> Bool {
        locationService.isDetermined
    }
    
    private func saveWeatherToCoreData(completion: @escaping (Result<Void, Error>) -> Void) {
        
        if let weather = weatherJsonModel,
           let location = locationName {
            let updatedAt = weather.properties.meta.updatedAt
            if coreDataService.isWeatherAlreadyExist(updatedAt: updatedAt, locationName: location) {
                print("Текущая модель Weather актуальна и не требует обновления")
                completion(.success(()))
                return
            } else {
                
                let weatherCoreDataModel = Weather(context: self.context)
                
                let weatherDataCoreDataModel = WeatherData(context: self.context)
                
                weatherDataCoreDataModel.updatedAt = updatedAt
                
                let coordinates = weather.geometry.coordinates
                
                weatherCoreDataModel.longitude = coordinates[0]
                weatherCoreDataModel.latitude = coordinates[1]
                weatherCoreDataModel.locationName = location
                
                // Time Series
                
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
                
                if let airQuality = airQualityJsonModel {
                    
                    coreDataService.deleteExistingAirQualityModel(locationName: location)
                    
                    let airQualityCoreDataModel = AirQuality(context: self.context)
                    
                    let forecast = airQuality.data.forecast.daily
                    
                    for dailyValue in forecast.pm25 {
                        let airQualityForecast = AirQualityForecast(context: self.context)
                        airQualityForecast.day = dailyValue.day
                        airQualityForecast.index = Int64(dailyValue.avg)
                        airQualityCoreDataModel.addToAirQualityForecast(airQualityForecast)
                    }
                    
                    weatherCoreDataModel.airQuality = airQualityCoreDataModel
                }
                
                if let astronomy = astronomyJsonModel {
                    
                    let start = astronomy.meta.start
                    
                    if !coreDataService.isAstronomyDataAlreadyExist(start: start, locationName: location) {
                        
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
                    }
                }
                
                do {
                    try self.context.save()
                    print("Полученная модель Weather успешно сохранена в Core Data")
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
