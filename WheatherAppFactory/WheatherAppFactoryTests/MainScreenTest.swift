//
//  MainScreenTest.swift
//  WheatherAppFactoryTests
//
//  Created by Matej Hetzel on 11/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import Nimble
import Quick
import Cuckoo
@testable import WheatherAppFactory


class MainScreenTest: QuickSpec {
    override func spec() {
        describe("load local test json"){
            var weatherData: MainDataClass!
            let mockedWeatherRepository = MockWeatherRepository()
            var testScheduler: TestScheduler!
            var mainViewModel: MainViewModel!
            let disposeBag = DisposeBag()
            beforeSuite {
                Cuckoo.stub(mockedWeatherRepository){ mock in
                    let testBundle = Bundle(for: MainScreenTest.self)
                    guard let path = testBundle.url(forResource: "RequestJSON", withExtension: "json") else {return}
                    let dataFromLocation = try! Data(contentsOf: path)
                    let weather = try! JSONDecoder().decode(MainDataModel.self, from: dataFromLocation)
                    
                    when(mock.alamofireRequest(any(), any())).thenReturn(Observable.just(weather))
                    
                    
                    var localDailyArray = [WeatherData]()
                        for data in weather.daily.data {
                            localDailyArray.append(WeatherData(time: data.time, temperatureMin: data.temperatureMin, temperatureMax: data.temperatureMax))
                        }
                    
                    
                    weatherData = MainDataClass(currently: Currently(humidity: weather.currently.humidity, icon: weather.currently.icon, pressure: weather.currently.pressure, temperature: weather.currently.temperature, time: weather.currently.time, windSpeed: weather.currently.windSpeed, summary: weather.currently.summary), daily: Daily(data: localDailyArray), timezone: weather.timezone)
                }
            }
            context("Initialize viewModel"){
                var dataReadySubject: TestableObserver<DataDoneEnum>!
                beforeEach {
                    testScheduler = TestScheduler(initialClock: 0)
                    mainViewModel = MainViewModel(dependencies: MainViewModel.Dependencies(scheduler: testScheduler, repository: mockedWeatherRepository))
                    
                    let input = MainViewModel.Input(getDataSubject: ReplaySubject<String>.create(bufferSize: 1), loadSettingSubject: ReplaySubject<Bool>.create(bufferSize: 1), firstLoadOfRealm: PublishSubject<Bool>(), getLocationSubject: PublishSubject<Bool>(), addLocationToRealmSubject: PublishSubject<Bool>(), setupCurrentLocationSubject: PublishSubject<Bool>())
                    
                    let output = mainViewModel.transform(input: input)
                    
                    for disposable in output.disposables{
                        disposable.disposed(by: disposeBag)
                    }
                    
                    dataReadySubject = testScheduler.createObserver(DataDoneEnum.self)
                    mainViewModel.input?.loadSettingSubject.onNext(true)
                    mainViewModel.output!.dataIsDoneLoading.subscribe(dataReadySubject).disposed(by: disposeBag)
                }
                it("check if data is triggering the event on a subject"){
                    testScheduler.start()
                    mainViewModel.input!.getDataSubject.onNext("asd")
                    
                    expect(dataReadySubject.events.count).to(equal(2))
                    expect(dataReadySubject.events[0].value.element).to(equal(.dataNotReady))
                }
                it("Check if data is loaded into the viewModel"){
                    testScheduler.start()
                    mainViewModel.input!.getDataSubject.onNext("asd")
                    
                    expect(mainViewModel.mainWeatherData.currently.icon).toEventually(equal(weatherData.currently.icon))
                }
            }
        }
    }
}
