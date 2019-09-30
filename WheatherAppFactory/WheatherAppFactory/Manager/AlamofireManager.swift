//
//  AlamofireManager.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 11/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxSwift
import RxCocoa


class AlamofireManager {
    func requestData(url: String) -> Observable<MainDataModel> {
        let requestUrl = URL(string: url)!
        
        return Observable.create{   observable -> Disposable in
        
            Alamofire.request(requestUrl)
                    .responseJSON   { response in
                do {
                    guard let data = response.data else {return}
                    let article = try JSONDecoder().decode(MainDataModel.self, from: data)
                    observable.onNext(article)
                }   catch let jsonErr {
                    observable.onError(jsonErr)
                }
            }
            return Disposables.create()
        
        }
    }
    
    func requestLocation(url: String) -> Observable<LocationDataModel> {
      
        return Observable.create{   observable -> Disposable in
            let escapedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let requestUrl = URL(string: escapedString)!
            
            Alamofire.request(requestUrl)
                .responseJSON   { response in
                    do {
                        guard let data = response.data else {return}
                        let article = try JSONDecoder().decode(LocationDataModel.self, from: data)
                        observable.onNext(article)
                    }   catch let jsonErr {
                        observable.onError(jsonErr)
                    }
            }
            return Disposables.create()
            
        }
    }
}
