//
//  CityListSingleton.swift
//  Clima
//
//  Created by Никита Макаревич on 14.03.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import UIKit

class CityListSingleton {
    
    static let cityList : [CityModel] = initCitylist()
    
    static func initCitylist() -> [CityModel]{
        let data = readLocalFile(forName: "JSONList")
        return parse(jsonData: data!)
    }
    
    private static func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private static func parse(jsonData: Data) -> [CityModel] {
        do {
            let decodedData = try JSONDecoder().decode([CityModel].self,
                                                       from: jsonData)
            return decodedData
        } catch {
            print("decode error")
        }
        return []
    }
    
    
}
