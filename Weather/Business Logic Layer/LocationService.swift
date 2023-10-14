

import CoreLocation

class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var currentLocation: CLLocation?
    var currentCoordinates: (latitude: Double, longitude: Double)?
    var locationName: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func getLocationName(completion: @escaping (String?) -> Void) {
        if let location = currentLocation {
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let self else { return }
                if let error = error {
                    print("Ошибка при обратном геокодировании: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let city = placemarks?.first?.locality {
                    self.locationName = city
                }
                
                if let country = placemarks?.first?.country {
                    if let name = self.locationName {
                        self.locationName = name + ", \(country)"
                    }
                }
                completion(self.locationName)
            }
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            
            if let currentPlace = currentLocation {
                self.currentCoordinates = (currentPlace.coordinate.latitude, currentPlace.coordinate.longitude)
            }
            
//            для проверки
//            let currentLattitude = 63.0160100
//            let currentLongittude = 112.4690100
//            currentLocation = CLLocation(latitude: currentLattitude, longitude: currentLongittude)
//            self.currentCoordinates = (currentLattitude, currentLongittude)
            
            getLocationName { name in
                self.locationName = name
            }
            
            
        }
    }
}
