//
//  MainViewModel.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 10/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift

class MainViewModel {
    
    var mainWeatherData: MainDataClass!
    let getDataSubject = ReplaySubject<String>.create(bufferSize: 1)
    let dataIsDoneLoading = PublishSubject<Bool>()
    let scheduler: SchedulerType
    let repository: WeatherRepository
    var locationToUse: String = "45.83194,17.38389"
    var unitMode: String = "si"
    
    func getData(subject: ReplaySubject<String>) -> Disposable{
        return subject
            .flatMap{(bool) -> Observable<MainDataClass> in
                self.dataIsDoneLoading.onNext(false)
                return self.repository.alamofireRequest(self.unitMode, bool)
        }
            .observeOn(MainScheduler.instance)
            .subscribeOn(scheduler)
            .subscribe(onNext: {[unowned self] weather in
                self.mainWeatherData = weather
                self.dataIsDoneLoading.onNext(true)
            })
    }
    
    init(scheduler: SchedulerType, repository: WeatherRepository) {
        self.scheduler = scheduler
        self.repository = repository
    }
}
