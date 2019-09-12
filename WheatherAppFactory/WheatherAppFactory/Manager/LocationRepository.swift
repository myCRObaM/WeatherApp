//
//  LocationRepository.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift

class LocationRepository {
    let url = "http://api.geonames.org/postalCodeLookupJSON?placename="
    let username = "&username=myCRObaM"
    
    func alamofireRequest(_ location: String) -> Observable<LocationDataClass> {
        let alamofireManager = AlamofireManager()
        let currentURL = url + location + username
        return alamofireManager.requestLocation(url: currentURL)
    }
}
