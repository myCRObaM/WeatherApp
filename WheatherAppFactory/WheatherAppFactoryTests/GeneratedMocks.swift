// MARK: - Mocks generated from file: WheatherAppFactory/Manager/WeatherRepository.swift at 2019-09-11 07:34:34 +0000

//
//  WeatherRepository.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 10/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Cuckoo
@testable import WheatherAppFactory

import Foundation
import RxSwift


 class MockWeatherRepository: WeatherRepository, Cuckoo.ClassMock {
    
     typealias MocksType = WeatherRepository
    
     typealias Stubbing = __StubbingProxy_WeatherRepository
     typealias Verification = __VerificationProxy_WeatherRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: WeatherRepository?

     func enableDefaultImplementation(_ stub: WeatherRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func alamofireRequest(_ location: String) -> Observable<MainDataClass> {
        
    return cuckoo_manager.call("alamofireRequest(_: String) -> Observable<MainDataClass>",
            parameters: (location),
            escapingParameters: (location),
            superclassCall:
                
                super.alamofireRequest(location)
                ,
            defaultCall: __defaultImplStub!.alamofireRequest(location))
        
    }
    

	 struct __StubbingProxy_WeatherRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func alamofireRequest<M1: Cuckoo.Matchable>(_ location: M1) -> Cuckoo.ClassStubFunction<(String), Observable<MainDataClass>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: location) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockWeatherRepository.self, method: "alamofireRequest(_: String) -> Observable<MainDataClass>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_WeatherRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func alamofireRequest<M1: Cuckoo.Matchable>(_ location: M1) -> Cuckoo.__DoNotUse<(String), Observable<MainDataClass>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: location) { $0 }]
	        return cuckoo_manager.verify("alamofireRequest(_: String) -> Observable<MainDataClass>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class WeatherRepositoryStub: WeatherRepository {
    

    

    
     override func alamofireRequest(_ location: String) -> Observable<MainDataClass>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<MainDataClass>).self)
    }
    
}

