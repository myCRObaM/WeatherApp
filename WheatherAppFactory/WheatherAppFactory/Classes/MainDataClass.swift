//
//  DataClass.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 10/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
class MainDataClass: Decodable {
    let currently: Currently
    let daily: Daily
    let timezone: String
}

struct Currently: Decodable {
    let humidity: Double
    let icon: String
    let pressure: Double
    let temperature: Double
    let time: Int
    let windSpeed: Double
    let summary: String
}

struct Daily: Decodable {
    let data: [WeatherData]
}

struct WeatherData: Decodable {
    let time: Int
    let temperatureMin: Double
    let temperatureMax: Double
}
