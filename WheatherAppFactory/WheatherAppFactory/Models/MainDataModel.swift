//
//  DataClass.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 10/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
class MainDataModel: Decodable {
    let currently: CurrentlyModel
    let daily: DailyModel
    let timezone: String
}

struct CurrentlyModel: Decodable {
    let humidity: Double
    let icon: String
    let pressure: Double
    let temperature: Double
    let time: Int
    let windSpeed: Double
    let summary: String
}

struct DailyModel: Decodable {
    let data: [WeatherDataModel]
}

struct WeatherDataModel: Decodable {
    let time: Int
    let temperatureMin: Double
    let temperatureMax: Double
}
