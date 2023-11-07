

import Foundation

enum FetchDataError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case noData
    case decodingError(error: Error)
    case networkError(error: Error)
    case invalidDate
    
    var description: String {
        switch self {
        case .invalidURL:
            return "❌ Error: Invalid URL"
        case .invalidResponse(let statusCode):
            return "❌ Error: Invalid Response - Status Code: \(statusCode)"
        case .noData:
            return "❌ Error: No Data"
        case .decodingError(let error):
            return "❌ Ошибка при декодировании данных: \(error)"
        case .networkError(let error):
            return "❌ Network Error: \(error.localizedDescription)"
        case .invalidDate:
            return "❌ Error: invalid date"
        }
    }
}
