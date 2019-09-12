//
//  LocationDataClass.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
class LocationDataClass: Decodable {
    let postalcodes: [PostalCodes]
}

struct PostalCodes: Decodable {
    let placeName: String
    let countryCode: String
    let lng: Double
    let lat: Double
}
