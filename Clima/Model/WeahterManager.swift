

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager, weather: WeatherModel)
    func didFailWithError(error : Error)
}

protocol WeatherManagerCDDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager, weather: WeatherModel, city: CityNS)
    func didFailWithError(error : Error)
}


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=55cd0a2d06779ea8b8b447c008f01830&units=metric"
    
    var delegate : WeatherManagerDelegate?
    var cdDelegate: WeatherManagerCDDelegate?
    
    func fetchWeather(cityName : String) {
        let city = cityName.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(weatherURL)&q=\(city)"
        performRequest(with: urlString)
    }
    
    func fetchWeahter(latitude : CLLocationDegrees , longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String) {
        print(urlString)
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    
    func fetchWeahterByCity(city: CityNS) {
        let urlString = "\(weatherURL)&lat=\(CLLocationDegrees( city.coords!.lat))&lon=\(CLLocationDegrees(city.coords!.lon))"
        performRequest(with: urlString, city: city)
    }
    
    func performRequest(with urlString : String, city: CityNS) {
        print(urlString)
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    cdDelegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        cdDelegate?.didUpdateWeather(self, weather: weather, city: city)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    
    
    func parseJSON(_ weatherData : Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let description = decodedData.weather[0].description
            let speed = decodedData.wind.speed
            let deg = decodedData.wind.deg
            let humidity = decodedData.main.humidity
            let pressure = decodedData.main.pressure
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, weatherDescription : description, speed: speed, deg : deg, humidity: humidity, pressure: pressure)
            
            return weather
        }
        catch {
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
