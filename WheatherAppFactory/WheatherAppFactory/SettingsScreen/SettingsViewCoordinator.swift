//
//  SettingViewCoordinator.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SettingsViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let rootController: MainViewController!
    let viewController: SettingsViewController
    
    init(rootController: MainViewController){
        self.rootController = rootController
        let viewModel = SettingsScreenModel(dependencies: SettingsScreenModel.Dependencies(scheduler: ConcurrentDispatchQueueScheduler(qos: .background)), settings: rootController.viewModel.settingsObjects, location: rootController.viewModel.locationsData)
        viewModel.doneButtonPressedDelegate = rootController
        viewController = SettingsViewController(viewModel: viewModel)
        viewController.doneButtonPressedDelegate = rootController
    }
    
    func start() {
        
        viewController.modalPresentationStyle = .overFullScreen
        rootController.present(viewController, animated: true) {
        }
    }
    deinit {
        print("Deinit: \(self)")
    }
    
}
