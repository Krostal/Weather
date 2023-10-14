import Foundation
import CoreData

protocol WeatherInteractorProtocol {
    func fetchFromNetwork(completion: @escaping (Result<WeatherJsonModel, Error>) -> Void)
}

class WeatherInteractor: WeatherInteractorProtocol {
    
    private let defaultValue: Float = 3.33
    private let fetchDataService: FetchDataService<WeatherJsonModel>
    private let coreDataService: CoreDataService
    private let context = CoreDataService.shared.setContext()
    
    init(fetchDataService: FetchDataService<WeatherJsonModel>, coreDataService: CoreDataService) {
        self.fetchDataService = fetchDataService
        self.coreDataService = CoreDataService.shared
    }
    
    func fetchFromNetwork(completion: @escaping (Result<WeatherJsonModel, Error>) -> Void) {
        self.fetchDataService.fetchData(coordinates: (longitude: 112, latitude: 63)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let weatherJsonModel):
                print("Data from the network: \(weatherJsonModel.geometry)")
                self.saveToCoreData(weatherJsonModel) { result in
                    switch result {
                    case .success:
                        print("Data saved to Core Data successfully.")
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

    private func saveToCoreData(_ weather: WeatherJsonModel, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Starting saveToCoreData")
        let weatherCoreDataModel = Weather(context: context)
        let location = Location(context: context)
        let unit = Unit(context: context)
        
        weatherCoreDataModel.updatedAt = weather.properties.meta.updatedAt
        // Location
        let coordinates = weather.geometry.coordinates
        location.longitude = coordinates[0]
        location.latitude = coordinates[1]
        location.altitude = coordinates[2]
        //        location.name = "Chernyshevskiy, Russia"
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
            let timePeriod = TimePeriod(context: context)
            timePeriod.time = timeSeries.time
            
            let timePeriodData = TimePeriodData(context: context)
            let instantData = InstantData(context: context)
            let next1HoursForecast = Next1HoursForecast(context: context)
            let next6HoursForecast = Next6HoursForecast(context: context)
            let next12HoursForecast = Next12HoursForecast(context: context)
            
            guard let instantDetails = timeSeries.data.instant.details else {
                print("❌ instantDetails is nil")
                return
            }
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
            
            
            guard let next1Hours = timeSeries.data.next1Hours else {
//                next1HoursForecast.precipitationAmount = defaultValue
//                next1HoursForecast.precipitationAmountMax = defaultValue
//                next1HoursForecast.precipitationAmountMin = defaultValue
//                next1HoursForecast.probabilityOfPrecipitation = defaultValue
//                next1HoursForecast.probabilityOfThunder = defaultValue
//                next1HoursForecast.symbolCode = ""
//                print("❌ next1Hours is nil")
                continue
            }
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
            
            guard let next6Hours = timeSeries.data.next6Hours else {
//                next6HoursForecast.airTemperatureMax = nil
//                next6HoursForecast.airTemperatureMin = defaultValue
//                next6HoursForecast.precipitationAmount = defaultValue
//                next6HoursForecast.precipitationAmountMax = defaultValue
//                next6HoursForecast.precipitationAmountMin = defaultValue
//                next6HoursForecast.probabilityOfPrecipitation = defaultValue
//                next6HoursForecast.symbolCode = ""
//                print("❌ next6Hours is nil")
                continue
            }
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
            
            
            guard let next12Hours = timeSeries.data.next12Hours else {
//                    next12HoursForecast.probabilityOfPrecipitation = defaultValue
//                    next12HoursForecast.symbolCode = ""
//                    print("❌ next12Hours is nil")
                    continue
                }

            if let details = next12Hours.details {
                next12HoursForecast.probabilityOfPrecipitation = details.probabilityOfPrecipitation ?? defaultValue
            }
            if let summary = next12Hours.summary {
                next12HoursForecast.symbolCode = summary.symbolCode
            }
            
            timePeriodData.instantData = instantData
            timePeriodData.next1HoursForecast = next1HoursForecast
            timePeriodData.next6HoursForecast = next6HoursForecast
            timePeriodData.next12HoursForecast = next12HoursForecast
            
            timePeriod.timePeriodData = timePeriodData
            
            weatherCoreDataModel.addToTimePeriod(timePeriod)
        }
        
        do {
            try context.save()
            print("✅ context saved successfully")
            
            let weatherIDURI = weatherCoreDataModel.objectID.uriRepresentation().absoluteString
            print("✅ Weather saved with ID: \(weatherIDURI)")
       
            completion(.success(()))
        } catch {
            print("Ошибка при сохранении данных в CoreData: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }

}