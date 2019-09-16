//
//  SettingViewController.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import RxSwift


class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataToUse = viewModel.locationsArray[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? LocationSettingsTableViewCell else {
            fatalError("nije settano")
            
        }
        cell.setupCell(data: PostalCodes(name: dataToUse.placeName, countryCode: dataToUse.countryCode, lng: String(dataToUse.lng), lat: String(dataToUse.lat)))
        cell.deleteButtonPressed = self
        cell.backgroundColor = .clear
        cell.selectionStyle = .default

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.currentLocation = viewModel.locationsArray[indexPath.row]
        viewModel.settingsObjects.lastSelectedLocation = viewModel.currentLocation.placeName
    }
    
    
    
    let viewModel: SettingsScreenModel!
    var doneButtonPressedDelegate: DoneButtonIsPressedDelegate!
    let disposeBag = DisposeBag()
    var customView: SettingsView!
    
    
    init(viewModel: SettingsScreenModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        customView = SettingsView(frame: view.frame, tableView: tableView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(donePressed))
        customView.doneButton.addGestureRecognizer(labelTap)
        
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        customView.tableView.register(LocationSettingsTableViewCell.self, forCellReuseIdentifier: "cellID")
        
        
        view.addSubview(customView)
        
        viewModel.updateRealmSettingsObject(subject: viewModel.getDataSubject).disposed(by: disposeBag)
        viewModel.loadLocationsFromRealm(subject: viewModel!.getLocationsDataSubject).disposed(by: disposeBag)
        reloadTableView(subject: viewModel.dataIsDoneSubject).disposed(by: disposeBag)
        viewModel.getLocationsDataSubject.onNext(true)
        viewModel.deleteObjectFromRealm(subject: viewModel.removeLocationSubject).disposed(by: disposeBag)
        
        dataIsLoaded()
        setupButtons()
        setupConstraints()
    }
    func setupConstraints(){
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: view.topAnchor),
            customView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    func setupButtons(){
        customView.humidityButton.addTarget(self, action: #selector(humidityButtonIsPressed), for: .touchUpInside)
        customView.metricButton.addTarget(self, action: #selector(metricButtonIsPressed), for: .touchUpInside)
        customView.imperialButton.addTarget(self, action: #selector(metricButtonIsPressed), for: .touchUpInside)
        customView.pressureButton.addTarget(self, action: #selector(pressureButtonIsPressed), for: .touchUpInside)
        customView.windButton.addTarget(self, action: #selector(windButtonIsPressed), for: .touchUpInside)
    }
    
    @objc func humidityButtonIsPressed(){
        customView.humidityButton.isSelected = !customView.humidityButton.isSelected
        viewModel.settingsObjects.humidityIsSelected = customView.humidityButton.isSelected
        dataIsLoaded()
    }
    
    @objc func metricButtonIsPressed(){
        customView.imperialButton.isSelected = !customView.imperialButton.isSelected
        customView.metricButton.isSelected = !customView.metricButton.isSelected
        viewModel.settingsObjects.metricSelected = customView.metricButton.isSelected
        dataIsLoaded()
    }
    @objc func pressureButtonIsPressed(){
        customView.pressureButton.isSelected = !customView.pressureButton.isSelected
        viewModel.settingsObjects.pressureIsSelected = customView.pressureButton.isSelected
        dataIsLoaded()
    }
    @objc func windButtonIsPressed(){
        customView.windButton.isSelected = !customView.windButton.isSelected
        viewModel.settingsObjects.windIsSelected = customView.windButton.isSelected
        dataIsLoaded()
    }
    
    func dataIsLoaded(){
        if viewModel.settingsObjects.humidityIsSelected {
            customView.humidityButton.isSelected = true
        }
        if viewModel.settingsObjects.pressureIsSelected {
            customView.pressureButton.isSelected = true
        }
        if viewModel.settingsObjects.windIsSelected {
            customView.windButton.isSelected = true
        }
        if viewModel.settingsObjects.metricSelected {
            customView.metricButton.isSelected = true
        }
        else {
            customView.imperialButton.isSelected = true
        }
    }
    
    @objc func donePressed(){
        self.dismiss(animated: false, completion: nil)
        viewModel.getDataSubject.onNext(true)
        doneButtonPressedDelegate.close(settings: viewModel.settingsObjects, location: viewModel.currentLocation)
    }
    
    func reloadTableView(subject: PublishSubject<CellControllEnum>) -> Disposable {
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.scheduler)
            .subscribe(onNext: {[unowned self]  bool in
                switch bool {
                case let .add(index):
                    self.customView.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                case let .remove(index):
                    self.customView.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            })
    }
}
extension SettingsViewController: DeleteButtonIsPressed {
    func deletePressed(name: String) {
        viewModel.removeLocationSubject.onNext(name)
    }
}
