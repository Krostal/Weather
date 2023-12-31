

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
    
    func isWeatherAlreadyExist(updatedAt: String, locationName: String) -> Bool {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        request.predicate = NSPredicate(format: "location.name == %@", locationName)

        do {
            let result = try setContext().fetch(request)

            if let existingWeather = result.first {
                if existingWeather.updatedAt == updatedAt {
                    return true
                } else {
                    setContext().delete(existingWeather)
                    print("Существующая модель Weather для данной локации \(locationName) удалена")
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
        let request: NSFetchRequest<AirQuality> = AirQuality.fetchRequest()
        request.predicate = NSPredicate(format: "coordinates.city == %@", locationName)

        do {
            let result = try setContext().fetch(request)

            if let existingAirQualityModel = result.first {
                setContext().delete(existingAirQualityModel)
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
        let request: NSFetchRequest<Astronomy> = Astronomy.fetchRequest()
        request.predicate = NSPredicate(format: "locationName == %@", locationName)

        do {
            let result = try setContext().fetch(request)
            
            if result.count <= 1 {
                 return false
            }

            if let existingAstronomy = result.first,
               let startDate = existingAstronomy.start {
                if startDate.prefix(10) == start {
                    return true
                } else {
                    setContext().delete(existingAstronomy)
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

