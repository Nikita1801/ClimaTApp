//
//  CoordNS+CoreDataProperties.swift
//  Clima
//
//  Created by Никита Макаревич on 17.03.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//
//

import Foundation
import CoreData


extension CoordNS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoordNS> {
        return NSFetchRequest<CoordNS>(entityName: "CoordNS")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var city: CityNS?

}

extension CoordNS : Identifiable {

}
