//
//  DataUtil.swift
//  WeatherApp
//
//  Created by Vidyaprasad on 31/10/19.
//  Copyright © 2019 Vidyaprasad. All rights reserved.
//

import Foundation

struct CityDetail : Decodable {
    var name: String
    var country: String
    var id: Int
    var coord:Coordinate
}

struct Coordinate: Decodable {
    var lon: Double
    var lat: Double
}
