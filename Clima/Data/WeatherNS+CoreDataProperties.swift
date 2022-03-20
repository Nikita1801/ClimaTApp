//
//  WeatherNS+CoreDataProperties.swift
//  Clima
//
//  Created by Никита Макаревич on 17.03.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherNS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherNS> {
        return NSFetchRequest<WeatherNS>(entityName: "WeatherNS")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var condition: Int64
    @NSManaged public var deg: Int64
    @NSManaged public var humidity: Int64
    @NSManaged public var pressure: Int64
    @NSManaged public var speed: Double
    @NSManaged public var temperature: Double
    @NSManaged public var weatherDescription: String?
    @NSManaged public var city: CityNS?

}

extension WeatherNS : Identifiable {

}
