

import Foundation

struct WeatherData: Codable {
    let name: String
    let main : Main
    let weather : [Weather]
    let wind : Wind
}


struct Main : Codable{
    let temp : Double
    let humidity : Int
    let pressure : Int
}

struct Weather: Codable {
    let id: Int
    let description : String
}
struct Wind : Codable {
    
    let speed : Double
    let deg : Int
}
