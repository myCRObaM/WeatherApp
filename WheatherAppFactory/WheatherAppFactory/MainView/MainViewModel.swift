//
//  MainViewModel.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 10/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class MainViewModel: NSObject, CLLocationManagerDelegate {
    //MARK: Defining structs
    struct Input {
        let getDataSubject: ReplaySubject<String>
        let loadSettingSubject: ReplaySubject<Bool>
        let firstLoadOfRealm: PublishSubject<Bool>
        let getLocationSubject: PublishSubject<Bool>
        let addLocationToRealmSubject: PublishSubject<Bool>
        let setupCurrentLocationSubject: PublishSubject<Bool>
    }
    
    struct Output {
        let dataIsDoneLoading: PublishSubject<DataDoneEnum>
        let popUpSubject: PublishSubject<Bool>
        let disposables: [Disposable]
    }
    
    struct Dependencies {
        let scheduler: SchedulerType
        let repository: WeatherRepository
    }
    
    //MARK: Transform
    func transform(input: MainViewModel.Input) -> MainViewModel.Output {
        self.input = input
        var disposables = [Disposable]()
        disposables.append(getData(subject: input.getDataSubject))
        disposables.append(loadDataForScreen(subject: input.loadSettingSubject))
        disposables.append(addObjectToRealm(subject: input.firstLoadOfRealm))
        disposables.append(loadLocationsFromRealm(subject: input.setupCurrentLocationSubject))
        disposables.append(addLocationToRealm(subject: input.addLocationToRealmSubject))
        disposables.append(setupLocation(subject: input.getLocationSubject))
        self.output = Output(dataIsDoneLoading: PublishSubject<DataDoneEnum>(), popUpSubject: PublishSubject<Bool>(), disposables: disposables)
        return output!
    }
    //MARK: Variables
    var input: Input?
    var output: Output?
    let dependencies: Dependencies
    
    let locationManager = CLLocationManager()
    
    
    var mainWeatherData: MainDataClass!
    var locationsData: LocationsObject!
    var settingsObjects: SettingsScreenObject!
   
    var isDownloadingFromSearch: Bool = false
    //MARK: getData
    func getData(subject: ReplaySubject<String>) -> Disposable{
        return subject
            .flatMap{[unowned self] (bool) -> Observable<MainDataModel> in
                self.output!.dataIsDoneLoading.onNext(.dataNotReady)
                var locationToUse: String = "si"
                if !self.settingsObjects.metricSelected {
                    locationToUse = "us"
                }
                return self.dependencies.repository.alamofireRequest(locationToUse, bool)
        }
            .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
            .map({weatherData -> MainDataClass in
                var localDailyArray = [WeatherData]()
                for data in weatherData.daily.data {
                    localDailyArray.append(WeatherData(time: data.time, temperatureMin: data.temperatureMin, temperatureMax: data.temperatureMax))
                }
                return MainDataClass(currently: Currently(humidity: weatherData.currently.humidity, icon: weatherData.currently.icon, pressure: weatherData.currently.pressure, temperature: weatherData.currently.temperature, time: weatherData.currently.time, windSpeed: weatherData.currently.windSpeed, summary: weatherData.currently.summary), daily: Daily(data: localDailyArray), timezone: weatherData.timezone)
                
            })
            .subscribe(onNext: {[unowned self] weather in
                self.mainWeatherData = weather
                if self.isDownloadingFromSearch {
                    self.output!.dataIsDoneLoading.onNext(.dataFromSearchDone)
                }
                else {
                    self.output!.dataIsDoneLoading.onNext(.dataForMainDone)
                }
                
            },  onError: {[unowned self] (error) in
                    self.output!.popUpSubject.onNext(true)
                    print(error)
            })
    }
    //MARK: Load data for screen
    func loadDataForScreen(subject: ReplaySubject<Bool>) -> Disposable{
        return subject
            .flatMap{ (bool) -> Observable<[SettingsScreenObject]> in
                let real = RealmManager()
                return real.loadObjectsFromRealm()
            }
            .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
            .subscribe(onNext: {[unowned self]  objects in
                if objects.count == 0 {
                    self.input!.setupCurrentLocationSubject.onNext(true)
                }
                if self.settingsObjects != nil && objects.count != 0{
                    self.input!.setupCurrentLocationSubject.onNext(true)
                }
                if self.settingsObjects == nil && objects.count != 0{
                     self.settingsObjects = objects[0]
                    self.input!.setupCurrentLocationSubject.onNext(true)
                }
            },  onError: {[unowned self] (error) in
                    self.output!.popUpSubject.onNext(true)
                    print(error)
            })
        
    }
    //MARK: Add lcoation to realm
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
        .subscribeOn(dependencies.scheduler)
            .subscribe(onNext: { objects in
            },  onError: {[unowned self] (error) in
                    self.output!.popUpSubject.onNext(true)
                    print(error)
            })
    }
    //MARK: Add objets to realm
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
        .subscribeOn(dependencies.scheduler)
            .subscribe(onNext: { objects in
            },  onError: {[unowned self] (error) in
                    self.output!.popUpSubject.onNext(true)
                    print(error)
            })
        
    }
    //MARK: Location loading from realm
    func loadLocationsFromRealm(subject: PublishSubject<Bool>) -> Disposable{
        return subject
            .flatMap{ (bool) -> Observable<[LocationsObject]> in
                let real = RealmManager()
                return real.loadLocationsFromRealm()
            }
            .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
            .map({ [unowned self] object in
                if object.count == 0 {
                    self.input!.getLocationSubject.onNext(true)
                }
                else {
                    for location in object {
                        if location.placeName == self.settingsObjects.lastSelectedLocation {
                            self.locationsData = location
                        }
                    }
                    let locatinToUse: String = String(self.locationsData.lat) + "," + String(self.locationsData.lng)
                    self.input!.getDataSubject.onNext(locatinToUse)
                }
                
            })
            .subscribe(onNext: {objects in
            },  onError: {[unowned self] (error) in
                    self.output!.popUpSubject.onNext(true)
                    print(error)
            })
        
        
    }
    //MARK: Get currentLocation
    func setupLocation(subject: PublishSubject<Bool>) -> Disposable{
           return subject
               .observeOn(MainScheduler.instance)
               .subscribeOn(dependencies.scheduler)
               .subscribe(onNext: {[unowned self] bool in
                   switch bool{
                   case true:
                       if CLLocationManager.locationServicesEnabled() {
                           self.locationManager.delegate = self
                           self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                           self.locationManager.startUpdatingLocation()
                       }
                   case false:
                           self.locationManager.stopUpdatingLocation()
                       }
                   
               },  onError: {[unowned self] (error) in
                       self.output!.popUpSubject.onNext(true)
                       print(error)
               })}
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let locationToUse = String(locValue.latitude) + "," + String(locValue.longitude)
        input!.getLocationSubject.onNext(false)
        fetchCityAndCountry(from: location) {[unowned self] city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            self.locationsData = LocationsObject(placeName: city, countryCode: Locale.current.regionCode ?? country, lng: locValue.longitude, lat: locValue.latitude, isSelected: true)
            self.input!.firstLoadOfRealm.onNext(true)
            self.input!.getDataSubject.onNext(locationToUse)
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    
    //MARK: High and low Temps
    func setupLowAndHighTemperatures(_ data: MainDataClass) -> (lowTemp: String, highTemp: String, speed: String){
          let calendar = Calendar.current
        var currentDayTempsAndSpeed = ("", "", "")
          let currentDay = calendar.component(.day, from: NSDate(timeIntervalSince1970: Double(data.currently.time)) as Date)
          
          for day in data.daily.data {
              let searchDay = calendar.component(.day, from: NSDate(timeIntervalSince1970: Double(day.time)) as Date)
              if currentDay == searchDay {
                if settingsObjects.metricSelected {
                    currentDayTempsAndSpeed = (String((day.temperatureMin * 10).rounded() / 10) + "°C", String((day.temperatureMax * 10).rounded() / 10) + "°C", String((data.currently.windSpeed * 10).rounded() / 10) + "km/h")
                    
                }else
                {
                    currentDayTempsAndSpeed = (String((day.temperatureMin * 10).rounded() / 10) + "°F", String((day.temperatureMax * 10).rounded() / 10) + "°F", String((data.currently.windSpeed * 10).rounded() / 10) + "mph")
                }
                  
              }
          }
        return currentDayTempsAndSpeed
      }
    
    
    //MARK: GradientSetup
    func setupGradient(_ data: Currently) -> CAGradientLayer    {
        var firstColor = UIColor(hex: "#15587B")
        var secondColor = UIColor(hex: "#4A75A2")
        if data.icon == "clear-day" || data.icon == "wind"  {
            firstColor = UIColor(hex: "#59B7E0")
            secondColor = UIColor(hex: "#D8D8D8")
        }
        else if data.icon == "clear-night" || data.icon == "partly-cloudy-night"{
            firstColor = UIColor(hex: "#044663")
            secondColor = UIColor(hex: "#234880")
        }
        else if data.icon == "rain" || data.icon == "cloudy" || data.icon == "thunderstorm" || data.icon == "tornado" || data.icon == "hail"{
            firstColor = UIColor(hex: "#15587B")
            secondColor = UIColor(hex: "#4A75A2")
        }
        else if data.icon == "snow" || data.icon == "sleet" {
            firstColor = UIColor(hex: "#0B3A4E")
            secondColor = UIColor(hex: "#80D5F3")
        }
        else if data.icon == "fog" || data.icon == "cloudy" || data.icon == "partly-cloudy-day" {
            firstColor = UIColor(hex: "#ABD6E9")
            secondColor = UIColor(hex: "#D8D8D8")
        }
        
        
        let gradientLocal: CAGradientLayer = {
            let gradientLocal: CAGradientLayer = [
                firstColor,
                secondColor
                ].gradient()
            gradientLocal.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLocal.endPoint = CGPoint(x: 0.5, y: 0.98)
            return gradientLocal
        }()
        
        return gradientLocal
    }
    //MARK: Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
