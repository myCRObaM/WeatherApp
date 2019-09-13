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
    let getDataSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    let scheduler: SchedulerType!
    var doneButtonPressedDelegate: DoneButtonIsPressedDelegate!
    
    init(scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background), settings: SettingsScreenObject) {
        self.scheduler = scheduler
        self.settingsObjects = settings
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
                return realmManager.addObjectToRealm(object: realmObject)
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(scheduler)
            .subscribe(onNext: {objects in
            })
        
    }
    
}
