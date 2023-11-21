

import Foundation
import CoreData

final class CoreDataService {
    
    static let shared = CoreDataService()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("‼️ Can not load persistant stores \(error)")
            }
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }
        return container
    }()
    
    func setContext() -> NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func getWeatherData(locationName: String) -> Weather? {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        let predicate = NSPredicate(format: "locationName == %@", locationName)
        request.predicate = predicate
        
        do {
            let results = try setContext().fetch(request)
            return results.first
        } catch {
            print("Error fetching weather data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getWeather() -> [Weather] {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        
        do {
            let results = try setContext().fetch(request)
            return results
        } catch {
            print("Error fetching weather data: \(error.localizedDescription)")
            return []
        }
    }
    
    func removeCurrentWeather(locationName: String) {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        let predicate = NSPredicate(format: "locationName == %@", locationName)
        request.predicate = predicate
        do {
            let results = try setContext().fetch(request)
            if let existingWeather = results.first {
                setContext().delete(existingWeather)
                print("Существующая модель Weather для локации \(locationName) удалена")
                do {
                    try setContext().save()
                } catch {
                    print("Error saving context after deleting Weather model: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error checking existing weather data: \(error.localizedDescription)")
        }
    }

    
    func isWeatherDataAlreadyExist(updatedAt: String, locationName: String) -> Bool {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        request.predicate = NSPredicate(format: "locationName == %@", locationName)

        do {
            let result = try setContext().fetch(request)

            if let existingWeather = result.first,
               let weatherData = existingWeather.weatherData {
                if weatherData.updatedAt == updatedAt {
                    return true
                } else {
                    setContext().delete(weatherData)
                    print("Существующая модель WeatherData для локации \(locationName) удалена")
                    do {
                        try setContext().save()
                    } catch {
                        print("Error saving context after deleting Weather model: \(error.localizedDescription)")
                    }
                    return false
                }
            }
            return false
        } catch {
            print("Error checking existing weather data: \(error.localizedDescription)")
            return false
        }
    }
    
    func deleteExistingAirQualityModel(locationName: String) {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        request.predicate = NSPredicate(format: "locationName == %@", locationName)

        do {
            let result = try setContext().fetch(request)

            if let existingWeather = result.first,
               let airQuality = existingWeather.airQuality {
                setContext().delete(airQuality)
                print("Существующая модель AirQuality для данной локации \(locationName) удалена")
                do {
                    try setContext().save()
                } catch {
                    print("Error saving context after deleting AirQuality model: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error checking existing AirQuality data: \(error.localizedDescription)")
        }
    }
    
    func isAstronomyDataAlreadyExist(start: String, locationName: String) -> Bool {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        request.predicate = NSPredicate(format: "locationName == %@", locationName)

        do {
            let result = try setContext().fetch(request)
            
            if let existingWeather = result.first,
               let astronomy = existingWeather.astronomy,
               let startDate = astronomy.start {
                if startDate.prefix(10) == start {
                    return true
                } else {
                    setContext().delete(astronomy)
                    print("Существующая модель Astronomy для данной локации \(locationName) удалена")
                    do {
                        try setContext().save()
                    } catch {
                        print("Error saving context after deleting Astronomy model: \(error.localizedDescription)")
                    }
                    return false
                }
            }
            return false
        } catch {
            print("Error checking existing Astronomy data: \(error.localizedDescription)")
            return false
        }
    }
}

