import Foundation

struct API {
    static func weatherURL(for latitude: Double, longitude: Double) -> String {
        return "https://api.met.no/weatherapi/locationforecast/2.0/complete?lat=\(latitude)&lon=\(longitude)"
    }
}
