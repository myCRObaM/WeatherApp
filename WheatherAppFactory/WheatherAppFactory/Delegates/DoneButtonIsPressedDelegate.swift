//
//  DoneButtonIsPressedDelegate.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 13/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
protocol DoneButtonIsPressedDelegate: class {
    func close(settings: SettingsScreenObject, location: LocationsObject)
}

protocol SettingsScreenDelegate: class {
    func buttonPressed(rootController: MainViewController)
}
