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
    let turl = "http://api.geonames.org/searchJSON?q="
    let url = "http://api.geonames.org/postalCodeLookupJSON?placename="
    let username = "&maxRows=10&username=myCRObaM"
    
    func alamofireRequest(_ location: String) -> Observable<LocationDataModel> {
        let alamofireManager = AlamofireManager()
        let currentURL = turl + location + username
        return alamofireManager.requestLocation(url: currentURL)
    }
}
