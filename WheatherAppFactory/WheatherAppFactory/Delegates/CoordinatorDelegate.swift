//
//  CoordinatorDelegate.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 30/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
protocol ParentCoordinatorDelegate {
    func childHasFinished(coordinator: Coordinator)
}

protocol CoordinatorDelegate: class {
    func viewControllerHasFinished()
}
