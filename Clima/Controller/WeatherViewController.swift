
import UIKit
import CoreLocation
import CoreData

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var findNewCityButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var windLable: UILabel!
    @IBOutlet weak var humidityLable: UILabel!
    @IBOutlet weak var pressureLable: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var degreeLable: UILabel!
    
    @IBOutlet weak var temperatureMeasuringLable: UILabel!
    
    @IBOutlet weak var descriptionWeatherLable: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var searchVC = SearchViewController()
    
    var temperatureInCelsius = 0.0
    var cityData : CityModel?
    var cityName : [CityModel?] = []
    var isFavorite : Bool = false
    var weatherInCity : WeatherModel? = nil
    
    var persContainer: NSPersistentContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persContainer = NSPersistentContainer(name: "Clima")
        
        // load the database if it exists, if not create it.
        persContainer?.loadPersistentStores { storeDescription, error in
            // resolve conflict by using correct NSMergePolicy
            self.persContainer?.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if (cityData == nil){
            locationManager.startUpdatingLocation()
            favoriteButton.isHidden = true
            container.isHidden = true
        }else {
            // currentLocationButton.isHidden = true
            findNewCityButton.isHidden = true
            currentLocationButton.isHidden = true
            container.alpha = 0
            if(isFavorite){
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.isSelected = true
                
            }
        }
        
        
        weatherManager.delegate = self
        
        
        
        weatherManager.fetchWeahter(latitude : cityData?.coord.lat ?? CLLocationDegrees.greatestFiniteMagnitude, longitude: cityData?.coord.lon ?? CLLocationDegrees.greatestFiniteMagnitude)
        
        
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            //cityName.append(cityData)
            
            //add a city to the favorite list
            let cityCoreDataSave = CityNS(context: self.persContainer!.viewContext)
            cityCoreDataSave.coords = CoordNS(context: self.persContainer!.viewContext)
            CoreDataUtils.mapToCoreData(cityCoreData: cityCoreDataSave ,cityToSave: cityData)
            if (weatherInCity != nil) {
                let weatherCoreDataSave = WeatherNS(context: self.persContainer!.viewContext)
                CoreDataUtils.mapToCoreData(weatherCoreData: weatherCoreDataSave, weatherToSave: weatherInCity!)
                cityCoreDataSave.weather = weatherCoreDataSave
            }
            
            //save to the context
            self.saveContext()
            self.loadSavedData()
            
            print("isSelected true")
        }
        if sender.isSelected == false {
            //searchVC.favorite.removeLast()
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            print("isSelected flase")
            
            //Remove sity from favorite list
            let saveData = self.loadSavedData()
            let cityNsToRemovePosition = saveData.firstIndex(of: saveData.filter{$0.id == Int64(cityData!.id)}.first!)
            print(cityNsToRemovePosition!)
            persContainer?.viewContext.delete(saveData[cityNsToRemovePosition!])
            saveContext()
            loadSavedData()
        }
    }
    
    ///FOR CORE DATA USAGES ONLY
    
    
    //OPER WITH CD
    func saveContext(){
        if persContainer!.viewContext.hasChanges {
            do {
                try persContainer!.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    
    
    public func loadSavedData() -> [CityNS]{
        let request: NSFetchRequest<CityNS> = CityNS.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            let data = try persContainer!.viewContext.fetch(request)
            print(data)
            print("Got \(data.count) commits")
            return data
        } catch {
            print("Fetch failed")
        }
        return []
    }
    
    ///END OF CORE DATA
    
    @IBAction func changeTemeratureMeasuringPressed(_ sender: UISwitch) {
        if sender.isOn {
            let temperatureInFarengate = String(format: "%.1f", temperatureInCelsius * 1.8 + 32)
            temperatureLabel.text = "\(temperatureInFarengate)"
            temperatureMeasuringLable.text = "F"        }
        if sender.isOn == false {
            temperatureLabel.text = "\(temperatureInCelsius)"
            temperatureMeasuringLable.text = "C"
        }
    }
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        if let location = currentLocation {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeahter(latitude : lat, longitude: lon)
        }
    }
    
}


//MARK: - WeatherManagerDelegate

extension WeatherViewController : WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager, weather: WeatherModel) {
        
        weatherInCity = weather
        
        temperatureInCelsius = Double(weather.temperatureString)!
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.descriptionWeatherLable.text = weather.weatherDescription
            self.windLable.text = "Wind \(weather.speed) m/s direction \(weather.windDirection)"
            self.pressureLable.text = "Pressure \(weather.pressureInMM) mm"
            self.humidityLable.text = "Humidity \(weather.humidity)%"
            self.backgroundImage.image = UIImage(named: weather.conditionBackground)
            
            if ((weather.conditionBackground ==  "rainImage") || weather.conditionBackground == "fogImage"){
                self.temperatureLabel.textColor = UIColor(named: "darkGreen")
                self.conditionImageView.tintColor = UIColor(named: "darkGreen")
                self.cityLabel.textColor = UIColor(named: "darkGreen")
                self.pressureLable.textColor = UIColor(named: "darkGreen")
                self.descriptionWeatherLable.textColor = UIColor(named: "darkGreen")
                self.windLable.textColor = UIColor(named: "darkGreen")
                self.humidityLable.textColor = UIColor(named: "darkGreen")
                self.temperatureMeasuringLable.textColor = UIColor(named: "darkGreen")
                self.degreeLable.textColor = UIColor(named: "darkGreen")
            }
            
        }
        
        if(cityData != nil){
            if(isFavorite){
                let saveData = self.loadSavedData()
                let cityNsForCurrentCityPosition = saveData.firstIndex(of: saveData.filter{$0.id == Int64(cityData!.id)}.first!)!
                if saveData[cityNsForCurrentCityPosition] != nil {
                   let cityNs = saveData[cityNsForCurrentCityPosition]
                    let weatherNS = WeatherNS(context: self.persContainer!.viewContext)
                    CoreDataUtils.mapToCoreData(weatherCoreData: weatherNS, weatherToSave: weather)
                    cityNs.weather = weatherNS
                    saveContext()
                }

            }
        }
    }
    func didFailWithError(error: Error) {
        print(error)
        if error.localizedDescription.debugDescription.contains("No value associated with key CodingKeys(stringValue"){
            
        }else{
            if isFavorite{
                
                var saveData = self.loadSavedData()
                let cityIndex = saveData.firstIndex(of: saveData.filter{$0.id == Int64(cityData!.id)}.first!)
                let weather : WeatherModel = CoreDataUtils.mapFromCoreData(weatherCoreData: saveData[cityIndex!].weather!)
                self.didUpdateWeather( WeatherManager(), weather: weather)
                
            }
        }
        
        
    }
}


//MARK: - CLLocationManagerDelegate
extension WeatherViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeahter(latitude : lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
