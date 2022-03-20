//
//  CoreData.swift
//  Clima
//
//  Created by Никита Макаревич on 17.03.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class CoreDataUtils{
    
    //MAP TO CD
    public static func mapToCoreData(cityCoreData:  CityNS, cityToSave: CityModel?){
        cityCoreData.id = Int64(cityToSave!.id)
        cityCoreData.name = cityToSave?.name
        cityCoreData.country = cityToSave?.country
        cityCoreData.state = cityToSave?.state
        mapToCoreData(coordsCoreData: cityCoreData.coords!, coordsToSave: cityToSave!.coord)
    }
    
    public static func mapToCoreData(coordsCoreData: CoordNS, coordsToSave: Coord){
        coordsCoreData.lat = Double(coordsToSave.lat)
        coordsCoreData.lon = Double(coordsToSave.lon)
    }
    public static func mapToCoreData(weatherCoreData: WeatherNS, weatherToSave : WeatherModel) {
        weatherCoreData.pressure = Int64(weatherToSave.pressure)
        weatherCoreData.humidity = Int64(weatherToSave.humidity)
        weatherCoreData.deg = Int64(weatherToSave.deg)
        weatherCoreData.speed = weatherToSave.speed
        weatherCoreData.temperature = weatherToSave.temperature
        weatherCoreData.cityName = weatherToSave.cityName
        weatherCoreData.condition = Int64(weatherToSave.conditionId)
        weatherCoreData.weatherDescription = weatherToSave.weatherDescription
    }
    
    //MAP FROM CD
    public static func mapFromCoreData(coordsCoreData: CoordNS) -> Coord{
        return Coord(lon: CLLocationDegrees(coordsCoreData.lon), lat: CLLocationDegrees(coordsCoreData.lat))
    }
    
    public static func mapFromCoreData(cityCoreData:  CityNS) -> CityModel {
        let fakeCoord = mapFromCoreData(coordsCoreData: cityCoreData.coords! )
        return CityModel(name: cityCoreData.name!, state: cityCoreData.state!, country: cityCoreData.country!, coord: fakeCoord, id: Int(cityCoreData.id))
    }
    public static func mapFromCoreData(weatherCoreData: WeatherNS) -> WeatherModel {
        return WeatherModel(conditionId: Int(weatherCoreData.condition), cityName: weatherCoreData.cityName!, temperature: weatherCoreData.temperature, weatherDescription: weatherCoreData.weatherDescription!, speed: weatherCoreData.speed, deg: Int(weatherCoreData.deg), humidity: Int(weatherCoreData.humidity), pressure: Int(weatherCoreData.pressure))
    }
    
}
