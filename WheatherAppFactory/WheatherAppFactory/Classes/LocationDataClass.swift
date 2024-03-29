//
//  LocationDataClass.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 30/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
class LocationDataClass {
    let geonames: [PostalCodes]
    init(geonames: [PostalCodes]) {
        self.geonames = geonames
    }
}

struct PostalCodes {
    let name: String
    let countryCode: String
    let lng: String
    let lat: String
}
