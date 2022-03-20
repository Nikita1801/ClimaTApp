//
//  cityListModel.swift
//  Clima
//
//  Created by Никита Макаревич on 14.03.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation


struct CityModel: Codable {
    let name : String
    let state, country: String
    let coord: Coord
    let id: Int

}


// MARK: - Coord
struct Coord: Codable {
    let lon, lat: CLLocationDegrees
    

}

