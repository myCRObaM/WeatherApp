//
//  MainViewCoordinator.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 10/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import RxSwift




class MainViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var window: UIWindow!
    
    init(window: UIWindow){
        self.window = window
    }
    
    func start() {
        let mainViewModel = MainViewModel(scheduler: ConcurrentDispatchQueueScheduler(qos: .background), repository: WeatherRepository())
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewController.openSearchScreenDelegate = self
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
}
extension MainViewCoordinator: SearchScreenDelegate{
    func openSearchScreen(searchBar: UISearchBar, rootController: MainViewController) {
        let searchCoordinator = SearchViewCoordinator(rootController: rootController, searchBar: searchBar)
        searchCoordinator.start()
    }
    
    
}
