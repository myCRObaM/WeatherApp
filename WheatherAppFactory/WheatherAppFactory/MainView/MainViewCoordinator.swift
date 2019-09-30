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
        let mainViewModel = MainViewModel(dependencies: MainViewModel.Dependencies(scheduler: ConcurrentDispatchQueueScheduler(qos: .background), repository: WeatherRepository()))
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewController.openSearchScreenDelegate = self
        mainViewController.openSettingScreenDelegate = self
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
}

extension MainViewCoordinator: ParentCoordinatorDelegate, CoordinatorDelegate {
    
    func childHasFinished(coordinator: Coordinator) {
        removeCoordinator(coordinator: coordinator)
    }
    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        childHasFinished(coordinator: self)
    }
    
    
}
extension MainViewCoordinator: SearchScreenDelegate{
    func openSearchScreen(searchBar: UISearchBar, rootController: MainViewController) {
        let searchCoordinator = SearchViewCoordinator(rootController: rootController, searchBar: searchBar)
        searchCoordinator.viewController.coordinatorDelegate = self
        self.addCoordinator(coordinator: searchCoordinator)
        searchCoordinator.start()
    }
}

extension MainViewCoordinator: SettingsScreenDelegate{
    func buttonPressed(rootController: MainViewController) {
        let settingsCoordinator = SettingsViewCoordinator(rootController: rootController)
        settingsCoordinator.viewController.coordinatorDelegate = self
        self.addCoordinator(coordinator: settingsCoordinator)
        settingsCoordinator.start()
    }
}
