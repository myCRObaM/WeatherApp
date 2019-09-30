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
    //MARK: Struct definition
    struct Input {
        let getDataSubject: ReplaySubject<Bool>
        let getLocationsDataSubject: ReplaySubject<Bool>
        let removeLocationSubject: PublishSubject<String>
    }
    
    struct Output {
        let dataIsDoneSubject: PublishSubject<CellControllEnum>
        let popUpSubject: PublishSubject<Bool>
        let disposables: [Disposable]
    }
    
    struct Dependencies {
        let scheduler: SchedulerType
    }
    
    
    //MARK: Variables
    var settingsObjects: SettingsScreenObject!
    var locationsArray = [LocationsObject]()
    var currentLocation: LocationsObject!
    
    var input: Input?
    var output: Output?
    let dependencies: Dependencies
    weak var doneButtonPressedDelegate: DoneButtonIsPressedDelegate?
    
    
    
    //MARK: INIT
    init(dependencies: SettingsScreenModel.Dependencies, settings: SettingsScreenObject, location: LocationsObject) {
        self.dependencies = dependencies
        self.settingsObjects = settings
        self.currentLocation = location
    }
    
    //MARK: Transform
    
    func transform(input: SettingsScreenModel.Input) -> SettingsScreenModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(updateRealmSettingsObject(subject: input.getDataSubject))
        disposables.append(loadLocationsFromRealm(subject: input.getLocationsDataSubject))
        disposables.append(deleteObjectFromRealm(subject: input.removeLocationSubject))
        
        self.output = Output(dataIsDoneSubject: PublishSubject<CellControllEnum>(), popUpSubject: PublishSubject<Bool>(), disposables: disposables)
        return output!
    }
    
    //MARK: Update realm settings
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
        .subscribeOn(dependencies.scheduler)
            .subscribe(onNext: {objects in
            },  onError: {[unowned self] (error) in
                self.output!.popUpSubject.onNext(true)
                    print(error)
            })
        
    }
    
    //MARK: Load locations from realm
    func loadLocationsFromRealm(subject: ReplaySubject<Bool>) -> Disposable{
        return subject
            .flatMap{ (bool) -> Observable<[LocationsObject]> in
                let real = RealmManager()
                return real.loadLocationsFromRealm()
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.scheduler)
            .subscribe(onNext: {[unowned self]  objects in
                self.locationsArray = objects
                self.output!.dataIsDoneSubject.onNext(.add(1))
            },  onError: {[unowned self] (error) in
                self.output!.popUpSubject.onNext(true)
                    print(error)
            })
        
    
}
    //MARK: Delete object from realm
    func deleteObjectFromRealm(subject: PublishSubject<String>) -> Disposable{
        return subject
            .flatMap{ (bool) -> Observable<String> in
                let locationsIndex = self.locationsArray.firstIndex(where: {$0.placeName == bool})!
                self.locationsArray.remove(at: locationsIndex)
                self.output!.dataIsDoneSubject.onNext(.remove(locationsIndex))
                let real = RealmManager()
                return real.removeObjectFromRealm(object: bool)
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.scheduler)
            .subscribe(onNext: {  objects in
                
            },  onError: {[unowned self] (error) in
                self.output!.popUpSubject.onNext(true)
                    print(error)
            })
    }
}
