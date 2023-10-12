

import Foundation

final class NetworkService<T: Decodable> {
    func fetchData(coordinates: (lattitude: Double?, longittude: Double?), completion: @escaping (Result<T,FetchDataError>) -> Void) {
        
        let urlString = API.weatherURL(for: coordinates.lattitude ?? 11.59, longitude: coordinates.longittude ?? 60.5)
        
        guard let url = URL(string: urlString)  else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error: error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse(statusCode: 0)))
                return
            }
            
            guard (200..<300).contains(response.statusCode) else {
                completion(.failure(.invalidResponse(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
            
            do {
            
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
        
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
        
    }
    
}

