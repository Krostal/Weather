

import Foundation

final class FetchDataService: Decodable {
    
    func fetchWeatherData(coordinates: (latitude: Double, longitude: Double), completion: @escaping (Result<WeatherJsonModel,FetchDataError>) -> Void) {
        
        let urlString = API.weatherURL(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
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
            
            do {
            
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
        
                let result = try decoder.decode(WeatherJsonModel.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError(error: error)))
            }
        }
        
        task.resume()
        
    }
    
    func fetchAirQualityData(coordinates: (latitude: Double, longitude: Double), completion: @escaping (Result<AirQualityJsonModel,FetchDataError>) -> Void) {
        
        let urlString = API.airQualityURL(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
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
            
            do {
            
                let decoder = JSONDecoder()
                
                let result = try decoder.decode(AirQualityJsonModel.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError(error: error)))
            }
        }
        
        task.resume()
        
    }
    
    func fetchAstronomyData(coordinates: (latitude: Double, longitude: Double), completion: @escaping (Result<AstronomyJsonModel,FetchDataError>) -> Void) {
        
        let header = "b868769c-7b15-11ee-a14f-0242ac130002-b868775a-7b15-11ee-a14f-0242ac130002"
        
        let maxDay = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        guard let maxDay = maxDay else {
            completion(.failure(.invalidDate))
            return
        }
        
        let endDate = CustomDateFormatter().formattedDateToString(date: maxDay, dateFormat: "yyyy-MM-dd", locale: nil)
        
        let urlString = API.sunAndMoonURL(latitude: coordinates.latitude, longitude: coordinates.longitude, endDate: endDate)
        
        guard let url = URL(string: urlString)  else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(header, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
            
            do {
            
                let decoder = JSONDecoder()
                
                let result = try decoder.decode(AstronomyJsonModel.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError(error: error)))
            }
        }
        
        task.resume()
        
    }
    
}

