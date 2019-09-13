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
    var settingsObjects: SettingsScreenObject!
    let getDataSubject = ReplaySubject<String>.create(bufferSize: 1)
    let loadSettingSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    let dataIsDoneLoading = PublishSubject<DataDoneEnum>()
    let firstLoadOfRealm = PublishSubject<Bool>()
    
    let scheduler: SchedulerType
    let repository: WeatherRepository
    let lat = 45.83194
    let lng = 17.38389
    var locationToUse: String = "45.83194,17.38389"
    var isDownloadingFromSearch: Bool = false
    var unitMode: String = "si"
    
    func getData(subject: ReplaySubject<String>) -> Disposable{
        return subject
            .flatMap{(bool) -> Observable<MainDataClass> in
                self.dataIsDoneLoading.onNext(.dataNotReady)
                return self.repository.alamofireRequest(self.unitMode, bool)
        }
            .observeOn(MainScheduler.instance)
            .subscribeOn(scheduler)
            .subscribe(onNext: {[unowned self] weather in
                self.mainWeatherData = weather
                if self.isDownloadingFromSearch {
                    self.dataIsDoneLoading.onNext(.dataFromSearchDone)
                }
                else {
                    self.dataIsDoneLoading.onNext(.dataForMainDone)
                }
                
            })
    }
    
    func loadDataForScreen(subject: ReplaySubject<Bool>) -> Disposable{
        return subject
            .flatMap{ (bool) -> Observable<[SettingsScreenObject]> in
                let real = RealmManager()
                return real.loadObjectsFromRealm()
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(scheduler)
            .subscribe(onNext: {[unowned self]  objects in
                if objects.count == 0 {
                    self.firstLoadOfRealm.onNext(true)
                }
                if self.settingsObjects == nil && objects.count != 0{
                     self.settingsObjects = objects[0]
                    if self.settingsObjects.metricSelected {
                        self.unitMode = "si"
                    }
                    else {
                        self.unitMode = "us"
                    }
                }               
                self.getDataSubject.onNext(self.locationToUse)
            })
        
    }
    
    func addObjectToRealm(subject: PublishSubject<Bool>) -> Disposable {
        return subject
            .flatMap{ (bool) -> Observable<String> in
                let realmManager = RealmManager()
                self.settingsObjects = SettingsScreenObject(metricSelected: true, humidityIsSelected: true, windIsSelected: true, pressureIsSelected: true)
                let realmObject = SettingsScreenClass()
                realmObject.humidityIsSelected = true
                realmObject.metricSelected = true
                realmObject.PressureIsSelected = true
                realmObject.windIsSelected = true
                realmObject.title = "1"
                return realmManager.addObjectToRealm(object: realmObject)
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(scheduler)
            .subscribe(onNext: { objects in
            })
        
    }
    
    
    init(scheduler: SchedulerType, repository: WeatherRepository) {
        self.scheduler = scheduler
        self.repository = repository
    }
}
