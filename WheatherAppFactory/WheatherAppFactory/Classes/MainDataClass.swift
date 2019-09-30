//
//  MainDataClass.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 30/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
class MainDataClass {
    let currently: Currently
    let daily: Daily
    let timezone: String
    
    init(currently: Currently, daily: Daily, timezone: String) {
        self.currently = currently
        self.daily = daily
        self.timezone = timezone
    }
}

struct Currently {
    let humidity: Double
    let icon: String
    let pressure: Double
    let temperature: Double
    let time: Int
    let windSpeed: Double
    let summary: String
}

struct Daily {
    let data: [WeatherData]
}

struct WeatherData {
    let time: Int
    let temperatureMin: Double
    let temperatureMax: Double
}
