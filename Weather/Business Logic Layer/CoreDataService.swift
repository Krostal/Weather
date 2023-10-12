

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
    
    func fetchWeatherData() -> [Location] {
        let request = Location.fetchRequest()
        
        do {
            let weatherData = try setContext().fetch(request)
            print(weatherData)
            return weatherData
        } catch {
            print("Error fetching favorite posts: \(error.localizedDescription)")
            return []
        }
    }
    
}

