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
}


