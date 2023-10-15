

import CoreLocation

class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var currentLocation: CLLocation?
    var currentCoordinates: (latitude: Double, longitude: Double)?
    
    
    override init() {
        super.init()
        updateLocation()
    }
    
    private func updateLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getLocationName(completion: @escaping (String?) -> Void) {
        if let location = currentLocation {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                guard let placemark = placemarks?.first
                else {
                    return
                }
                if let error = error {
                    print("Geocoding error \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                let placeName = "\(placemark.locality ?? ""), \(placemark.country ?? "")"
                completion(placeName)
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
        }
    }
}
            
//                        для проверки
//                        let currentLattitude = 63.0160100
//                        let currentLongittude = 112.4690100
//                        currentLocation = CLLocation(latitude: currentLattitude, longitude: currentLongittude)
//                        self.currentCoordinates = (currentLattitude, currentLongittude)
            
