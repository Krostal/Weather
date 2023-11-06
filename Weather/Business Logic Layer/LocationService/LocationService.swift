

import CoreLocation

class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var currentLocation: CLLocation?
    var isLocationAuthorized: Bool = false
    var isDetermined: Bool = false
    var currentCoordinates: (latitude: Double, longitude: Double)?    
    
    override init() {
        super.init()
        updateLocation()
    }
    
    func updateLocation() {
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationAuthorized = true
            isDetermined = true
        case .denied, .restricted:
            isLocationAuthorized = false
            isDetermined = true
        case .notDetermined:
            isDetermined = false
        @unknown default:
            fatalError("Неизвестный статус разрешения использования местоположения")
        }
    }
}
