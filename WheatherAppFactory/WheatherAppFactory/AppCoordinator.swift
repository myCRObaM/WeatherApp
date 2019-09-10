//
//  appCoordinator.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 10/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    let window: UIWindow?
    
    init(window: UIWindow){
        self.window = window
    }
    
    func start() {
        let IndexViewController = UIViewController()
        window?.rootViewController = IndexViewController
        window?.makeKeyAndVisible()
        
    }
    
    
}
