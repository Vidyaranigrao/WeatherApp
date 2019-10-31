//
//  WeatherGetter.swift
//  WeatherApp
//
//  Created by Vidyaprasad on 31/10/19.
//  Copyright © 2019 Vidyaprasad. All rights reserved.
//

import Foundation

class WeatherGetter {
    
    private let baseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let groupBaseURL = "http://api.openweathermap.org/data/2.5/group"
    private let apiKey = "344f7d79825fc992a780b6e4ec22386f"

    
    func getWeather(cityId: String, onCompletion: @escaping (Bool,
        WeatherModel?) -> ()) {
        
        let session = URLSession.shared
        
        let weatherRequestURL = URL(string: "\(baseURL)?APPID=\(apiKey)&units=metric&id=\(cityId)")!
        let request = URLRequest(url: weatherRequestURL)
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(WeatherModel.self, from: data)
                    onCompletion(true, jsonData as WeatherModel?)
                } catch {
                     onCompletion(false, nil)
                }
            } else {
                onCompletion(false, nil)
            }
        })
        dataTask.resume()
    }
    
    func getWeather(cities cityId: [String], onCompletion: @escaping (Bool,
        WeatherList?) -> ()) {
        
        let cityIds = cityId.joined(separator:",")
        let session = URLSession.shared
        
        let weatherRequestURL = URL(string: "\(groupBaseURL)?APPID=\(apiKey)&units=metric&id=\(cityIds)")!
        let request = URLRequest(url: weatherRequestURL)
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(WeatherList.self, from: data)
                    onCompletion(true, jsonData as WeatherList?)
                } catch {
                    onCompletion(false, nil)
                }
            } else {
                onCompletion(false, nil)
            }
        })
        dataTask.resume()
    }
    
}
