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
    //MARK: Define structs
    struct Input {
        let getLocationSubject: PublishSubject<String>
    }
    
    struct Output {
        let dataDoneSubject: PublishSubject<Bool>
        let popUpSubject: PublishSubject<Bool>
        let disposables: [Disposable]
    }
    
    struct Dependencies {
        let repository: LocationRepository
        let scheduler: SchedulerType
    }
    
    
    
    //MARK: Variables
    var locationData = [LocationDataClass]()
    
    var input: Input!
    var output: Output!
    let dependencies: Dependencies
    
    //MARK: Init
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: Transform
    func transform(input: SearchViewModel.Input) -> SearchViewModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(getData(subject: input.getLocationSubject))
        
        self.output = Output(dataDoneSubject: PublishSubject<Bool>(), popUpSubject: PublishSubject<Bool>(), disposables: disposables)
        return output
    }
    
    
    
    //MARK: getData
    func getData(subject: PublishSubject<String>) -> Disposable{
        return subject
            .flatMap{[unowned self](bool) -> Observable<LocationDataModel> in
                
                return self.dependencies.repository.alamofireRequest(bool)
            }
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.scheduler)
            .map({modelData -> LocationDataClass in
                var geonamesLocalArray = [PostalCodes]()
                for geoName in modelData.geonames {
                    geonamesLocalArray.append(PostalCodes(name: geoName.name, countryCode: geoName.countryCode, lng: geoName.lng, lat: geoName.lat))
                }
            return LocationDataClass(geonames: geonamesLocalArray)
            })
            .subscribe(onNext: {[unowned self] weather in
                self.locationData = [weather]
                self.output.dataDoneSubject.onNext(true)
            },  onError: {[unowned self] (error) in
                self.output!.popUpSubject.onNext(true)
                    print(error)
            })
    }
}
