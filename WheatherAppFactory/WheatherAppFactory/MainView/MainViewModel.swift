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
    var locationsData: LocationsObject!
    var settingsObjects: SettingsScreenObject!
    let getDataSubject = ReplaySubject<String>.create(bufferSize: 1)
    let loadSettingSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    let dataIsDoneLoading = PublishSubject<DataDoneEnum>()
    let firstLoadOfRealm = PublishSubject<Bool>()
    let setupCurrentLocationSubject = PublishSubject<Bool>()
    let addLocationToRealmSubject = PublishSubject<Bool>()
    let getLocationSubject = PublishSubject<Bool>()
    
   
    let scheduler: SchedulerType
    let repository: WeatherRepository
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
                    self.getLocationSubject.onNext(true)
                }
                if self.settingsObjects != nil && objects.count != 0{
                    self.setupCurrentLocationSubject.onNext(true)
                }
                if self.settingsObjects == nil && objects.count != 0{
                     self.settingsObjects = objects[0]
                    if self.settingsObjects.metricSelected {
                        self.unitMode = "si"
                    }
                    else {
                        self.unitMode = "us"
                    }
                    self.setupCurrentLocationSubject.onNext(true)
                }
            })
        
    }

    func addLocationToRealm(subject: PublishSubject<Bool>) -> Disposable {
        return subject
            .flatMap{ (bool) -> Observable<String> in
                let realmManager = RealmManager()
                let locationsObject = Locations()
                locationsObject.countryCode = self.locationsData.countryCode
                locationsObject.isSelected = true
                locationsObject.lat = self.locationsData.lat
                locationsObject.lng = self.locationsData.lng
                locationsObject.placeName = self.locationsData.placeName
                return realmManager.addLocationToRealm(object: locationsObject)
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(scheduler)
            .subscribe(onNext: { objects in
            })
    }
    
    func addObjectToRealm(subject: PublishSubject<Bool>) -> Disposable {
        return subject
            .flatMap{ (bool) -> Observable<String> in
                let realmManager = RealmManager()
                self.settingsObjects = SettingsScreenObject(metricSelected: true, humidityIsSelected: true, windIsSelected: true, pressureIsSelected: true, lastSelectedLocation: self.locationsData.placeName)
                let realmObject = SettingsScreenClass()
                realmObject.humidityIsSelected = true
                realmObject.metricSelected = true
                realmObject.PressureIsSelected = true
                realmObject.windIsSelected = true
                realmObject.title = "1"
                realmObject.lastSelectedLocation = self.locationsData.placeName
                return realmManager.addObjectToRealm(object: realmObject)
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(scheduler)
            .subscribe(onNext: { objects in
            })
        
    }
    
    func loadLocationsFromRealm(subject: PublishSubject<Bool>) -> Disposable{
        return subject
            .flatMap{ (bool) -> Observable<[LocationsObject]> in
                let real = RealmManager()
                return real.loadLocationsFromRealm()
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(scheduler)
            .map({ [unowned self] object in
                if object.count == 0 {
                    self.getLocationSubject.onNext(true)
                }
                for location in object {
                    if location.placeName == self.settingsObjects.lastSelectedLocation {
                        self.locationsData = location
                    }
                }
            })
            .subscribe(onNext: {objects in
                self.locationToUse = String(String(self.locationsData.lat) + "," + String(String(self.locationsData.lng)))
                self.getDataSubject.onNext(self.locationToUse)
            })
        
        
    }
    
    
    init(scheduler: SchedulerType, repository: WeatherRepository) {
        self.scheduler = scheduler
        self.repository = repository
    }
}
