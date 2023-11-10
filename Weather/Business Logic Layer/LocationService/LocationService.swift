

import CoreLocation
import MapKit

final class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    private var locationUpdateCallback: (() -> Void)?
    
    private let geocoder = CLGeocoder()
    //    private var currentLocation: CLLocation?
    var isLocationAuthorized: Bool = false
    var isDetermined: Bool = false
    var withCurrentLocation: Bool = true
    var currentCoordinates: (latitude: Double, longitude: Double)?
    var placeName: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        if withCurrentLocation {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func startUpdatingLocation(callback: @escaping () -> Void) {
        self.locationUpdateCallback = callback
    }
    
    func getLocationName(completion: @escaping (String?) -> Void) {
        guard let coordinates = currentCoordinates else { return }
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
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
            self.placeName = placeName
            completion(placeName)
        }
    }
}
    
//    func getCoordinates(addressString : String, completion: @escaping(CLLocationCoordinate2D?) -> Void ) {
//        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
//            if let error = error {
//                print("Ошибка геокодирования: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//            
//            if let placemark = placemarks?.first,
//               let location = placemark.location {
//                let coordinates = location.coordinate
//                self.currentCoordinates = (latitude: coordinates.latitude, longitude: coordinates.longitude)
//                self.placeName = "\(placemark.locality ?? ""), \(placemark.country ?? "")"
//                completion(coordinates)
//            } else {
//                completion(nil)
//            }
//        }
//    }

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            locationManager.stopUpdatingLocation()
            
            if let currentLocation = locations.first {
                self.currentCoordinates = (currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            }
            
            locationUpdateCallback?()
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
