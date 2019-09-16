//
//  SettingsScreenModel.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift

class SettingsScreenModel {
    var settingsObjects: SettingsScreenObject!
    var locationsArray = [LocationsObject]()
    var currentLocation: LocationsObject!
    let getDataSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    let dataIsDoneSubject = PublishSubject<CellControllEnum>()
    let getLocationsDataSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    let removeLocationSubject = PublishSubject<String>()
    
    let scheduler: SchedulerType!
    var doneButtonPressedDelegate: DoneButtonIsPressedDelegate!
    
    init(scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background), settings: SettingsScreenObject, location: LocationsObject) {
        self.scheduler = scheduler
        self.settingsObjects = settings
        self.currentLocation = location
    }
    
    func updateRealmSettingsObject(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
            .flatMap{(bool) -> Observable<String> in
                let realmManager = RealmManager()
                let realmObject = SettingsScreenClass()
                realmObject.humidityIsSelected = self.settingsObjects.humidityIsSelected
                realmObject.metricSelected = self.settingsObjects.metricSelected
                realmObject.PressureIsSelected = self.settingsObjects.pressureIsSelected
                realmObject.windIsSelected = self.settingsObjects.windIsSelected
                realmObject.title = "1"
                realmObject.lastSelectedLocation = self.settingsObjects.lastSelectedLocation
                return realmManager.addObjectToRealm(object: realmObject)
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(scheduler)
            .subscribe(onNext: {objects in
            })
        
    }
    func loadLocationsFromRealm(subject: ReplaySubject<Bool>) -> Disposable{
        return subject
            .flatMap{ (bool) -> Observable<[LocationsObject]> in
                let real = RealmManager()
                return real.loadLocationsFromRealm()
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(scheduler)
            .subscribe(onNext: {[unowned self]  objects in
                self.locationsArray = objects
                for (n, location) in objects.enumerated() {
                     self.dataIsDoneSubject.onNext(.add(n))
                }
            })
        
    
}
    
    func deleteObjectFromRealm(subject: PublishSubject<String>) -> Disposable{
        return subject
            .flatMap{ (bool) -> Observable<String> in
                let locationsIndex = self.locationsArray.firstIndex(where: {$0.placeName == bool})!
                self.locationsArray.remove(at: locationsIndex)
                self.dataIsDoneSubject.onNext(.remove(locationsIndex))
                let real = RealmManager()
                return real.removeObjectFromRealm(object: bool)
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(scheduler)
            .subscribe(onNext: {  objects in
                
            })
    }
}
