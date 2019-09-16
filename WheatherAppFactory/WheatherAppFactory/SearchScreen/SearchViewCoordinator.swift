//
//  SearchViewCoordinator.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SearchViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let rootController: MainViewController!
    let searchBar: UISearchBar!
    
    
    init(rootController: MainViewController, searchBar: UISearchBar) {
        self.rootController = rootController
        self.searchBar = searchBar
    }
    
    func start() {
        let viewModel = SearchViewModel(repository: LocationRepository(), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
        let viewController = SearchViewController(model: viewModel, searchBar: searchBar)
        viewController.cancelButtonPressed = rootController
        rootController.dataIsDoneLoading = viewController
        viewController.selectedLocationButton = rootController
        viewController.modalPresentationStyle = .overFullScreen
        rootController.present(viewController, animated: false) {
        }
        
    }
    
  
}
