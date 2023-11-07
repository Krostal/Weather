

import Foundation

enum LocationServiceError: Error {
    case locationServiceOff
    
    var description: String {
        switch self {
        case .locationServiceOff:
            return "Location services are disabled"
        }
    }
}
