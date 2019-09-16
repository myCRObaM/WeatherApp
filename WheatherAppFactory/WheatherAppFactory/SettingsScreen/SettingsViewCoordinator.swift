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
    
    init(rootController: MainViewController){
        self.rootController = rootController
    }
    
    func start() {
        let viewModel = SettingsScreenModel(scheduler: ConcurrentDispatchQueueScheduler(qos: .background), settings: rootController.viewModel.settingsObjects, location: rootController.viewModel.locationsData)
        viewModel.doneButtonPressedDelegate = rootController
        let settingsVC = SettingsViewController(viewModel: viewModel)
        settingsVC.modalPresentationStyle = .overFullScreen
        settingsVC.doneButtonPressedDelegate = rootController
        rootController.present(settingsVC, animated: true) {
        }
    }
    
    
}
