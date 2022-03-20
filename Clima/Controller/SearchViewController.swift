//
//  SearchViewController.swift
//  Clima
//
//  Created by Никита Макаревич on 12.03.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var searching = false
    var weatherManager = WeatherManager()
    
    
    var city: [CityModel] = CityListSingleton.cityList
    var filteredCity = [CityModel] ()
    
    var selectedCity:CityModel?
    
    var favorite : [CityModel?] = []
    
    
    /// CORE DATA ZONE
    
    var persContainer: NSPersistentContainer?
    
    
    public func loadSavedData() -> [CityNS]{
        let request: NSFetchRequest<CityNS> = CityNS.fetchRequest()
             let sort = NSSortDescriptor(key: "name", ascending: false)
             request.sortDescriptors = [sort]
             
             do {
                 // fetch is performed on the NSManagedObjectContext
                 let data = try persContainer!.viewContext.fetch(request)
                 print(data)
                 print("Got \(data.count) commits")
                 //tableView.reloadData()
                 return data
             } catch {
                 print("Fetch failed")
             }
        return []
    }
    

    
    ///END OF CORE DATA ZONE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "showWeather") {
                let destinationVC = segue.destination as! WeatherViewController
            
                destinationVC.cityData = selectedCity
                destinationVC.isFavorite =  favorite.filter{$0?.id == selectedCity?.id}.count > 0
            }
        }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        cityReal.prefix(upTo: 10).map { x in x.name}
        searchTextField.addTarget(self, action: #selector(searchRecord), for: .editingChanged)
        filteredCity = city
       // favorite = weatherViewController.cityName
        favorite.append(contentsOf: Array(city.prefix(upTo: 10)))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        ///Core DATA INIT
        persContainer = NSPersistentContainer(name: "Clima")
                
                // load the database if it exists, if not create it.
                persContainer?.loadPersistentStores { storeDescription, error in
                    // resolve conflict by using correct NSMergePolicy
                    self.persContainer?.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    
                    if let error = error {
                        print("Unresolved error \(error)")
                    }
                }
        
        //Load data frome core data and map
        favorite = loadSavedData().map{ CoreDataUtils.mapFromCoreData(cityCoreData: $0)}

    }
    
    
    @objc func searchRecord(sender : UITextField ) {
        self.filteredCity.removeAll()
        let searchData : Int = searchTextField.text!.count
        if (searchData != 0) {
            searching = true
            for city in city {
                if let cityToSearch = searchTextField.text {
                    let range = city.name.lowercased().range(of: cityToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil {
                        self.filteredCity.append(city)
                    }
                }
                
            }
        }
        else {
            filteredCity = city
            searching = false
        }
        tableView.reloadData()
    }
    
    
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if (searchTextField.text != "") {
            if searching {
                return filteredCity.count
            }
            else {
                return city.count
            }
        }
        return favorite.count

        
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        favorite = loadSavedData().map{ CoreDataUtils.mapFromCoreData(cityCoreData: $0)}
        if (searchTextField.text != "") {
            if searching {
                cell.textLabel?.text = filteredCity[indexPath.row].name
            }
            else {
               
                cell.textLabel?.text = city[indexPath.row].name
            }
        }
        else {
            cell.textLabel?.text = favorite[indexPath.row]?.name
        }
        
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tableView.resignFirstResponder()
        searchTextField.endEditing(true)
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (searchTextField.text != "") {
            
            selectedCity = filteredCity[indexPath.row]
        }
        else {
            
            selectedCity = favorite[indexPath.row]
        }
        self.performSegue(withIdentifier: "showWeather", sender: self)
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text != "") {
            return true
        }
        else {
            textField.placeholder = "Enter the city"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        favorite = loadSavedData().map{ CoreDataUtils.mapFromCoreData(cityCoreData: $0)}
        tableView.reloadData()
    }
    
}
