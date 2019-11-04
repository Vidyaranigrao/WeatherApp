//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Vidyaprasad on 31/10/19.
//  Copyright © 2019 Vidyaprasad. All rights reserved.
//

import Foundation

struct WeatherList: Decodable {
    var list: [WeatherModel]
}

struct WeatherModel : Decodable {
    var main: Temperature
    var name: String
    var weather: [Weather]
}

struct Temperature: Decodable {
    var temp: Double
    var temp_min: Double
    var temp_max: Double
    var humidity: Double
}

struct Weather: Decodable {
    var description: String
}
