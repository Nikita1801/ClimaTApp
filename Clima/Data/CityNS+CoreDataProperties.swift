//
//  CityNS+CoreDataProperties.swift
//  Clima
//
//  Created by Никита Макаревич on 17.03.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//
//

import Foundation
import CoreData


extension CityNS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityNS> {
        return NSFetchRequest<CityNS>(entityName: "CityNS")
    }

    @NSManaged public var country: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var state: String?
    @NSManaged public var coords: CoordNS?
    @NSManaged public var weather: WeatherNS?

}

extension CityNS : Identifiable {

}
