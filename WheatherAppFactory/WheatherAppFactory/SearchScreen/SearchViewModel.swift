//
//  SearchViewModel.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift

class SearchViewModel {
    let repository: LocationRepository!
    let scheduler: SchedulerType!
    let getLocationSubject = PublishSubject<String>()
    let dataDoneSubject = PublishSubject<Bool>()
    var locationData = [LocationDataClass]()
    
    init(repository: LocationRepository, scheduler: SchedulerType) {
        self.repository = repository
        self.scheduler = scheduler
    }
    func getData(subject: PublishSubject<String>) -> Disposable{
        return subject
            .flatMap{(bool) -> Observable<LocationDataClass> in
                
                return self.repository.alamofireRequest(bool)
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(scheduler)
            .subscribe(onNext: {[unowned self] weather in
                self.locationData = [weather]
                self.dataDoneSubject.onNext(true)
            })
    }
}
