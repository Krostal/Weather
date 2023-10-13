import Foundation
import CoreData

protocol WeatherInteractorProtocol {
    func fetchFromNetwork(completion: @escaping (Result<WeatherJsonModel, Error>) -> Void)
    func saveToCoreData(_ weather: WeatherJsonModel, completion: @escaping (Result<Void, Error>) -> Void)
}

class WeatherInteractor: WeatherInteractorProtocol {
    let defaultValue: Float = 3.33
    let fetchDataService: FetchDataService<WeatherJsonModel>
    var coreDataService = CoreDataService.shared
    let context = CoreDataService.shared.setContext()

    init(fetchDataService: FetchDataService<WeatherJsonModel>, coreDataService: CoreDataService) {
        self.fetchDataService = fetchDataService
        self.coreDataService = coreDataService
    }

    func fetchFromNetwork(completion: @escaping (Result<WeatherJsonModel, Error>) -> Void) {
        fetchDataService.fetchData(coordinates: (long: 9.58, lat: 60.10)) { result in
            switch result {
            case .success(let weatherModel):
                self.saveToCoreData(weatherModel) { result in
                    switch result {
                    case .success:
                        completion(.success(weatherModel))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func saveToCoreData(_ weather: WeatherJsonModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let weatherCoreDataModel = Weather(context: self.context)
        let location = Location(context: self.context)
        
        weatherCoreDataModel.updatedAt = weather.properties.meta.updatedAt
        
        // Units
        
        let unit = Unit(context: self.context)
        weatherCoreDataModel.unit = unit
        
        // Location
        
        location.longitude = weather.geometry.coordinates[0]
        location.latitude = weather.geometry.coordinates[1]
        location.altitude = weather.geometry.coordinates[2]
        location.name = "Здесь будет название локации"
        
        weatherCoreDataModel.location = location
        
        // Time Series
        
        for timeSeries in weather.properties.timeseries {
            
            let timePeriod = TimePeriod(context: self.context)
            timePeriod.time = timeSeries.time
            
            let timePeriodData = TimePeriodData(context: self.context)
            
            guard let instantData = timePeriodData.instantData else { return }
            guard let instantDetails = timeSeries.data.instant.details else { return }
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
            
            guard let next1HoursForecast = timePeriodData.next1Hours else { return }
            guard let next1Hours = timeSeries.data.next1Hours else { return }
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
            
            guard let next6HoursForecast = timePeriodData.next6Hours else { return }
            guard let next6Hours = timeSeries.data.next6Hours else { return }
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
            
            guard let next12HoursForecast = timePeriodData.next12Hours else { return }
            guard let next12Hours = timeSeries.data.next12Hours else { return }
            if let details = next12Hours.details {
                next12HoursForecast.probabilityOfPrecipitation = details.probabilityOfPrecipitation ?? defaultValue
            }
            if let summary = next12Hours.summary {
                next12HoursForecast.symbolCode = summary.symbolCode
                next12HoursForecast.symbolConfidence = summary.symbolConfidence
            }
            
            timePeriodData.instantData = instantData
            timePeriodData.next1Hours = next1HoursForecast
            timePeriodData.next6Hours = next6HoursForecast
            timePeriodData.next12Hours = next12HoursForecast
            
            timePeriod.timePeriodData = timePeriodData
            
            weatherCoreDataModel.addToTimePeriod(timePeriod)
        }
        
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print("Ошибка при сохранении данных в CoreData: \(error)")
            completion(.failure(error))
        }
    }
    
}
