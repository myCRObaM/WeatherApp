//
//  LocationDataClass.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
class LocationDataClass: Decodable {
    let geonames: [PostalCodes]
}

struct PostalCodes: Decodable {
    let name: String
    let countryCode: String
    let lng: String
    let lat: String
}
