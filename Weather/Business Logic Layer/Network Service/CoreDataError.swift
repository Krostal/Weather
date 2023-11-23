

import Foundation

enum CoreDataError: Error {
    case noDataAvailable
    case savingError
    case cityAlreadyProcessed
    
    var description: String {
        switch self {
        case .noDataAvailable:
            return "❌ There is no data available in Core Data"
        case .savingError:
            return "❌ Error saving data to Core Data"
        case .cityAlreadyProcessed:
            return "❌ City already processed"

            
        }
    }
}
