import Foundation
import CoreData

protocol WeatherInteractorProtocol {
    func fetchWeatherFromNetwork(completion: @escaping (Result<WeatherJsonModel, Error>) -> Void)
    func getWeatherFromCoreData(withPredicate predicate: NSPredicate?, completion: @escaping ([Weather]) -> Void)
    func fetchAirQualityFromNetwork(completion: @escaping (Result<AirQualityJsonModel, Error>) -> Void)
    func getAirQualityFromCoreData(completion: @escaping ([AirQuality]) -> Void)
    func fetchAstronomyFromNetwork(completion: @escaping (Result<AstronomyJsonModel, Error>) -> Void)
    func getAstronomyFromCoreData(withPredicate predicate: NSPredicate?, completion: @escaping ([Astronomy]) -> Void)
    func checkPermission(completion: @escaping (Bool) -> Void)
    func isDetermined() -> Bool
}

final class WeatherInteractor: WeatherInteractorProtocol {

    private let defaultValue: Float = 3.33
    private let fetchDataService: FetchDataService
    private let coreDataService: CoreDataService
    private var locationService: LocationService
    private let context = CoreDataService.shared.setContext()
    private var locationName: String?
    
    init(fetchDataService: FetchDataService, coreDataService: CoreDataService, locationService: LocationService) {
        self.fetchDataService = fetchDataService
        self.coreDataService = CoreDataService.shared
        self.locationService = locationService
    }
    
    func fetchWeatherFromNetwork(completion: @escaping (Result<WeatherJsonModel, Error>) -> Void) {
        
        guard let coordinates = locationService.currentCoordinates else {
            return
        }
        
        locationService.getLocationName { [weak self] name in
            guard let self else { return }
            self.locationName = name
            self.fetchDataService.fetchWeatherData(coordinates: (coordinates.latitude, coordinates.longitude)) { result in
                print(coordinates)
                switch result {
                case .success(let weatherJsonModel):
                    self.saveWeatherToCoreData(weatherJsonModel) { result in
                        switch result {
                        case .success:
                            completion(.success(weatherJsonModel))
                        case .failure(let error):
                            print("Error saving data to Core Data: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    print("Error fetching data from the network: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchAirQualityFromNetwork(completion: @escaping (Result<AirQualityJsonModel, Error>) -> Void) {
        
        guard let coordinates = locationService.currentCoordinates else {
            return
        }
        
        self.fetchDataService.fetchAirQualityData(coordinates: (coordinates.latitude, coordinates.longitude)) { result in
            switch result {
            case .success(let airQualityJsonModel):
                self.saveAirQualityToCoreData(airQualityJsonModel) { result in
                    switch result {
                    case .success:
                        completion(.success(airQualityJsonModel))
                    case .failure(let error):
                        print("Error saving data to Core Data: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("Error fetching data from the network: \(error)")
                completion(.failure(error))
                
            }
        }
    }
    
    func fetchAstronomyFromNetwork(completion: @escaping (Result<AstronomyJsonModel, Error>) -> Void) {
        
        guard let coordinates = locationService.currentCoordinates else {
            return
        }
        let currentDate = CustomDateFormatter().formattedCurrentDate(dateFormat: "yyyy-MM-dd", locale: nil, timeZone: nil)
        
        guard let location = locationName else { return }
        
        if coreDataService.isAstronomyDataAlreadyExist(start: currentDate, locationName: location) {
            print("Astronomy data with matching start date already exists and no new data request required")
            return
        } else {
            self.fetchDataService.fetchAstronomyData(coordinates: (coordinates.latitude, coordinates.longitude)) { result in
                switch result {
                case .success(let astronomyJsonModel):
                    self.saveAstronomyToCoreData(astronomyJsonModel) { result in
                        switch result {
                        case .success:
                            completion(.success(astronomyJsonModel))
                        case .failure(let error):
                            print("Error saving data to Core Data: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    print("Error fetching data from the network: \(error)")
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
    
    func getAirQualityFromCoreData(completion: @escaping ([AirQuality]) -> Void) {
        let request: NSFetchRequest<AirQuality> = AirQuality.fetchRequest()
        
        do {
            let results = try self.context.fetch(request)
            completion(results)
        } catch {
            print("Error fetching weather data: \(error.localizedDescription)")
        }
    }
    
    func getAstronomyFromCoreData(withPredicate predicate: NSPredicate?, completion: @escaping ([Astronomy]) -> Void) {
        let request: NSFetchRequest<Astronomy> = Astronomy.fetchRequest()
        
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
    
    private func saveWeatherToCoreData(_ weather: WeatherJsonModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let updatedAt = weather.properties.meta.updatedAt
        
        if let location = locationName {
            if coreDataService.isWeatherAlreadyExist(updatedAt: updatedAt, locationName: location) {
                print("Weather with matching updatedAt already exists")
                completion(.success(()))
                return
            }
        }
        
        let weatherCoreDataModel = Weather(context: self.context)
        let location = Location(context: self.context)
        let unit = Unit(context: self.context)
        
        weatherCoreDataModel.updatedAt = updatedAt
        
        // Location
        let coordinates = weather.geometry.coordinates
        location.longitude = coordinates[0]
        location.latitude = coordinates[1]
        location.altitude = coordinates[2]
        location.name = locationName
        weatherCoreDataModel.location = location
    
        // Units
        let units = weather.properties.meta.units
        unit.airPressureAtSeaLevel = units.airPressureAtSeaLevel
        unit.airTemperature = units.airTemperature
        unit.airTemperatureMax = units.airTemperatureMax
        unit.airTemperatureMin = units.airTemperatureMin
        unit.airTemperaturePercentile10 = units.airTemperaturePercentile10
        unit.airTemperaturePercentile90 = units.airTemperaturePercentile90
        unit.cloudAreaFraction = units.cloudAreaFraction
        unit.cloudAreaFractionHigh = units.cloudAreaFractionHigh
        unit.cloudAreaFractionLow = units.cloudAreaFractionLow
        unit.cloudAreaFractionMedium = units.cloudAreaFractionMedium
        unit.dewPointTemperature = units.dewPointTemperature
        unit.fogAreaFraction = units.fogAreaFraction
        unit.precipitationAmount = units.precipitationAmount
        unit.precipitationAmountMax = units.precipitationAmountMax
        unit.precipitationAmountMin = units.precipitationAmountMin
        unit.probabilityOfPrecipitation = units.probabilityOfPrecipitation
        unit.probabilityOfThunder = units.probabilityOfThunder
        unit.relativeHumidity = units.relativeHumidity
        unit.ultravioletIndexClearSky = units.ultravioletIndexClearSky
        unit.windFromDirection = units.windFromDirection
        unit.windSpeed = units.windSpeed
        unit.windSpeedOfGust = units.windSpeedOfGust
        unit.windSpeedPercentile10 = units.windSpeedPercentile10
        unit.windSpeedPercentile90 = units.windSpeedPercentile90
        weatherCoreDataModel.unit = unit
        
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
            
            weatherCoreDataModel.addToTimePeriod(timePeriod)
        }
        
        do {
            try self.context.save()
            print("Weather data saved to Core Data successfully.")
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func saveAirQualityToCoreData(_ airQuality: AirQualityJsonModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        if let location = locationName {
            coreDataService.deleteExistingAirQualityModel(locationName: location)
        }
        
        let airQualityCoreDataModel = AirQuality(context: self.context)
        let coordinates = AirQualityCoordinates(context: self.context)
        
        let city = airQuality.data.city
        coordinates.lat = city.geo[0]
        coordinates.long = city.geo[1]
        coordinates.city = locationName
        airQualityCoreDataModel.coordinates = coordinates
     
        let forecast = airQuality.data.forecast.daily
        for dailyValue in forecast.pm25 {
            let airQualityForecast = AirQualityForecast(context: self.context)
            airQualityForecast.day = dailyValue.day
            airQualityForecast.index = Int64(dailyValue.avg)
            airQualityCoreDataModel.addToAirQualityForecast(airQualityForecast)
        }
        
        do {
            try self.context.save()
            print("Air quality data saved to Core Data successfully.")
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func saveAstronomyToCoreData(_ astronomy: AstronomyJsonModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let start = astronomy.meta.start
        
        if let location = locationName {
            if coreDataService.isAstronomyDataAlreadyExist(start: start, locationName: location) {
                print("Astronomy data with matching start date already exists")
                completion(.success(()))
                return
            }
        }
        
        let astronomyCoreDataModel = Astronomy(context: self.context)
        astronomyCoreDataModel.start = astronomy.meta.start
        astronomyCoreDataModel.locationName = locationName
        
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
        
        do {
            try self.context.save()
            print("Astronomy data saved to Core Data successfully.")
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
}
