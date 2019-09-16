//
//  RealmManager.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 13/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class RealmManager  {
    
    let realm = try? Realm()
    
    func addObjectToRealm(object: SettingsScreenClass) -> Observable<String>{
        do {
            try realm?.write {
                realm?.add(object, update: .all)
            }
        }catch {
            print("error adding object")
        }
        return Observable.just("Success")
    }
    
    func addLocationToRealm(object: Locations) -> Observable<String>{
        do {
            try realm?.write {
                realm?.add(object, update: .all)
            }
        }catch {
            print("error adding object")
        }
        return Observable.just("Success")
    }
    
    
    
    func removeObjectFromRealm(object: String) -> Observable<String>{
        do {
            try realm?.write {
                guard let saKeyem = realm?.object(ofType: Locations.self, forPrimaryKey: object) else {return}
                realm?.delete(saKeyem)
            }
        }catch {
            print("error deleting object")
        }
        return Observable.just("Success")
    }
    
    
    func loadObjectsFromRealm() -> Observable<[SettingsScreenObject]>{
        var transformedArray = [SettingsScreenObject]()
        guard let realmObject = realm?.objects(SettingsScreenClass.self) else {return Observable.just(transformedArray)}
        for object in realmObject{
            transformedArray.append(SettingsScreenObject(metricSelected: object.metricSelected, humidityIsSelected: object.humidityIsSelected, windIsSelected: object.windIsSelected, pressureIsSelected: object.PressureIsSelected, lastSelectedLocation: object.lastSelectedLocation))
        }
        
        return Observable.just(transformedArray)
        
    }
    
    func loadLocationsFromRealm() -> Observable<[LocationsObject]>{
        var transformedArray = [LocationsObject]()
        guard let realmObject = realm?.objects(Locations.self) else {return Observable.just(transformedArray)}
        for object in realmObject{
            transformedArray.append(LocationsObject(placeName: object.placeName, countryCode: object.countryCode, lng: object.lng, lat: object.lat, isSelected: object.isSelected))
        }
        
        return Observable.just(transformedArray)
        
    }
    
}
