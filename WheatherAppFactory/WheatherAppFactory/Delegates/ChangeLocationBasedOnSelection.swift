//
//  ChangeLocationBasedOnSelection.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

protocol ChangeLocationBasedOnSelection: class {
    func didSelectLocation(long: Double, lat: Double, location: String, countryc: String)
}
protocol SearchScreenDelegate: class {
    func openSearchScreen(searchBar: UISearchBar, rootController: MainViewController)
}
protocol hideKeyboard: class {
    func hideViewController()
}
