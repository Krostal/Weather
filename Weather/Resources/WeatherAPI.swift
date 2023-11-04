import Foundation

struct API {
    static func weatherURL(latitude: Double, longitude: Double) -> String {
        return "https://api.met.no/weatherapi/locationforecast/2.0/complete?lat=\(latitude)&lon=\(longitude)"
    }
    static func airQualityURL(latitude: Double, longitude: Double) -> String {
        return "https://api.waqi.info/feed/geo:\(latitude);\(longitude)/?token=702a49c3e38a71a089a0c3d483bdb4874ba925c5"
    }
    static func sunAndMoonURL(latitude: Double, longitude: Double, endDate: String, api: String = "b868769c-7b15-11ee-a14f-0242ac130002-b868775a-7b15-11ee-a14f-0242ac130002") -> String {
        return "https://api.stormglass.io/v2/astronomy/point?lat=\(latitude)&lng=\(longitude)&end=\(endDate)"
    }
    
    
}
