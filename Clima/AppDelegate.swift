

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WeatherManagerCDDelegate {

    var wm : WeatherManager {
        var weatherM = WeatherManager()
        weatherM.cdDelegate = self
        return weatherM
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel, city: CityNS) {
        let weatherNS: WeatherNS = WeatherNS(context: persistentContainer.viewContext)
        CoreDataUtils.mapToCoreData(weatherCoreData: weatherNS, weatherToSave: weather)
        weatherNS.city = city
        saveContext()
        
        for i in loadSavedData(){
            print(i.weather)
        }
        print("_______________________")
    }
    
    func didFailWithError(error: Error) {
        //
    }
    
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        for city in loadSavedData(){
            wm.fetchWeahterByCity(city: city)
        }
        return true
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    // MARK: - Core Data stack

        lazy var persistentContainer: NSPersistentContainer = {

            let container = NSPersistentContainer(name: "Clima")

            container.loadPersistentStores(completionHandler: { (storeDescription, error) in

                if let error = error as NSError? {

                    fatalError("Unresolved error \(error), \(error.userInfo)")

                }

            })

            return container

        }()

         

        // MARK: - Core Data Saving support

        func saveContext () {

            let context = persistentContainer.viewContext

            if context.hasChanges {

                do {

                    try context.save()

                } catch {

                    let nserror = error as NSError

                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")

                }

            }

        }
    
    public func loadSavedData() -> [CityNS]{
        let request: NSFetchRequest<CityNS> = CityNS.fetchRequest()
             let sort = NSSortDescriptor(key: "name", ascending: false)
             request.sortDescriptors = [sort]
             
             do {
                 // fetch is performed on the NSManagedObjectContext
                 let data = try persistentContainer.viewContext.fetch(request)
                 print(data)
                 print("Got \(data.count) commits")
                 //tableView.reloadData()
                 return data
             } catch {
                 print("Fetch failed")
             }
        return []
    }
}

