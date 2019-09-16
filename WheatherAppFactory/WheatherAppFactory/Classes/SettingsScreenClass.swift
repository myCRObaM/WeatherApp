//
//  SettingsScreenClass.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 13/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RealmSwift

class SettingsScreenClass: Object {
    @objc dynamic var metricSelected: Bool = false
    @objc dynamic var humidityIsSelected: Bool = false
    @objc dynamic var windIsSelected: Bool = false
    @objc dynamic var PressureIsSelected: Bool = false
    @objc dynamic var title: String = ""
    @objc dynamic var lastSelectedLocation: String = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
}
class Locations: Object {
    @objc dynamic var placeName: String = ""
    @objc dynamic var countryCode: String = ""
    @objc dynamic var lng: Double = 0
    @objc dynamic var lat: Double = 0
    @objc dynamic var isSelected: Bool = false
    
    override static func primaryKey() -> String? {
        return "placeName"
    }
}
struct SettingsScreenObject: Decodable {
    var metricSelected: Bool
    var humidityIsSelected: Bool
    var windIsSelected: Bool
    var pressureIsSelected: Bool
    var lastSelectedLocation: String
}

struct LocationsObject: Decodable {
    var placeName: String
    var countryCode: String
    var lng: Double
    var lat: Double
    var isSelected: Bool
}
