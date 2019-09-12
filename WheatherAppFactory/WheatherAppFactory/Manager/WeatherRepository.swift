//
//  WeatherRepository.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 10/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift

class WeatherRepository {
    let url = "https://api.darksky.net/forecast/eed19b0a0b89a80e38d4ae15b1f24130/"
    
    func alamofireRequest(_ unit: String, _ location: String) -> Observable<MainDataClass> {
        let alamofireManager = AlamofireManager()
        let currentURL = url + location + "?units=" + unit
        print(currentURL)
        return alamofireManager.requestData(url: currentURL)
    }
}
