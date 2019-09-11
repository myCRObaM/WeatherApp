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
                    let weather = try! JSONDecoder().decode(MainDataClass.self, from: dataFromLocation)
                    
                    when(mock.alamofireRequest(any())).thenReturn(Observable.just(weather))
                    weatherData = weather
                }
            }
            context("Initialize viewModel"){
                var dataReadySubject: TestableObserver<Bool>!
                beforeEach {
                    testScheduler = TestScheduler(initialClock: 0)
                    mainViewModel = MainViewModel(scheduler: testScheduler, repository: mockedWeatherRepository)
                    mainViewModel.getData(subject: mainViewModel.getDataSubject).disposed(by: disposeBag)
                    
                    dataReadySubject = testScheduler.createObserver(Bool.self)
                    
                    mainViewModel.dataIsDoneLoading.subscribe(dataReadySubject).disposed(by: disposeBag)
                }
                it("check if data is triggering the event on a subject"){
                    testScheduler.start()
                    mainViewModel.getDataSubject.onNext("asd")
                    
                    expect(dataReadySubject.events.count).to(equal(1))
                    expect(dataReadySubject.events[0].value.element).to(equal(true))
                }
                it("Check if data is loaded into the viewModel"){
                    testScheduler.start()
                    mainViewModel.getDataSubject.onNext("asd")
                    
                    expect(mainViewModel.mainWeatherData.currently.icon).toEventually(equal(weatherData.currently.icon))
                }
            }
        }
    }
}
