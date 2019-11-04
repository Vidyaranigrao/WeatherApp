//
//  DataManager.swift
//  WeatherApp
//
//  Created by Vidyaprasad on 31/10/19.
//  Copyright © 2019 Vidyaprasad. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    init(){}
    
    func loadJson(filename fileName: String) -> [CityDetail]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([CityDetail].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func loadInitialCities() -> [CityDetail] {
        var cities = [CityDetail]()
        let coord1 = Coordinate(lon: 151.207321, lat: -33.867851)
        let city1 = CityDetail(name: "Sydney", country: "AU", id: 2147714, coord: coord1)
        cities.append(city1)
        let coord2 = Coordinate(lon: 144.944214, lat: -37.813061)
        let city2 = CityDetail(name: "Melbourne", country: "AU", id: 7839805, coord: coord2)
        cities.append(city2)
        let coord3 = Coordinate(lon: 153.028091, lat: -27.467939)
        let city3 = CityDetail(name: "Brisbane", country: "AU", id: 2174003, coord: coord3)
        cities.append(city3)
        return cities
    }
}


