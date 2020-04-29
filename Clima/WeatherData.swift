//
//  WeatherData.swift
//  Clima
//
//  Created by Abhishek Marriala on 15/04/20.
//  Copyright © 2020 Abhishek. All rights reserved.
//

import Foundation

struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Codable {
    let temp : Double
}

struct Weather : Codable {
    let id : Int
    let description : String
}


