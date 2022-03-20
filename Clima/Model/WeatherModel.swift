

import Foundation

struct WeatherModel {
    let conditionId : Int
    let cityName : String
    let temperature : Double
    let weatherDescription : String
    let speed : Double
    let deg : Int
    let humidity : Int
    let pressure : Int
    
    var temperatureString : String {
        return String(format: "%.1f", temperature)
    }
    var pressureInMM : String {
        let pressureMM = Double(pressure) / 1.333
        return String(format: "%.0f", pressureMM)
    }
        
    
    var windDirection : String {
        switch true {
        case ((deg > 335) && (deg <= 22)):
            return "N"
        case deg > 22 && deg <= 70:
            return "NE"
        case deg > 70 && deg <= 115:
            return "E"
        case deg > 115 && deg <= 155:
            return "SE"
        case deg > 155 && deg <= 205:
            return "S"
        case deg > 205 && deg <= 245:
            return "SW"
        case deg > 245 && deg <= 295:
            return "W"
        case deg > 295 && deg <= 335:
            return "NW"
        default:
            return " "
        }
    
    }
    
    var conditionName : String{
        switch conditionId {
        case 200..<299:
            return "cloud.bolt"
        case 300..<399:
            return "cloud.drizzle"
        case 500..<599:
            return "cloud.rain"
        case 600..<699:
            return "cloud.snow"
        case 700..<799:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801..<899:
            return "cloud"
        default:
            return "cloud"

    }
    
        
            
        }
    
    var conditionBackground : String {
        switch conditionName {
        case "cloud.bolt":
            return "rainImage"
            
        case "cloud.drizzle":
            return "rainImage"
            
        case "cloud.rain":
            return "rainImage"
            
        case "cloud.snow":
            return "snowImage"
            
        case "cloud.fog":
            return "fogImage"
            
        case "sun.max":
            return "sunImage"
            
        case "cloud":
            return "cloudImage"
        
        default:
            return "cloudImage"
        }
        
        
    }
}
