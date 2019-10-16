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
    //MARK: Table view
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
    
    
    //MARK: variable
    let viewModel: SettingsScreenModel!
    weak var doneButtonPressedDelegate: DoneButtonIsPressedDelegate?
    weak var coordinatorDelegate: CoordinatorDelegate?
    let disposeBag = DisposeBag()
    var customView: SettingsView!
    
    //MARK: init
    init(viewModel: SettingsScreenModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        coordinatorDelegate?.viewControllerHasFinished()
        print("Deinit: \(self)")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    //MARK: SetupUI
    func setupUI(){
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        customView = SettingsView(frame: view.frame, tableView: tableView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(donePressed))
        customView.doneButton.addGestureRecognizer(labelTap)
        
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        customView.tableView.register(LocationSettingsTableViewCell.self, forCellReuseIdentifier: "cellID")
        
        
        view.addSubview(customView)
        
        
        setupViewModel()
        setupButtons()
        setupConstraints()
        dataIsLoaded()
    }
    
    func setupConstraints(){
        customView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    //MARK: Setup view model
    func setupViewModel(){
        let input = SettingsScreenModel.Input(getDataSubject: ReplaySubject<Bool>.create(bufferSize: 1), getLocationsDataSubject: ReplaySubject<Bool>.create(bufferSize: 1), removeLocationSubject: PublishSubject<String>())
        
        let output = viewModel.transform(input: input)
        
        for disposable in output.disposables {
            disposable.disposed(by: disposeBag)
        }
        
        viewModel.output!.popUpSubject
        .observeOn(MainScheduler.instance)
        .subscribeOn(viewModel.dependencies.scheduler)
        .subscribe(onNext: {[unowned self] bool in
                self.showPopUp()
            }).disposed(by: disposeBag)
        
        
        viewModel.input!.getLocationsDataSubject.onNext(true)
        
        reloadTableView(subject: viewModel.output!.dataIsDoneSubject).disposed(by: disposeBag)
    }
    //MARK: Setup buttons
    func setupButtons(){
        customView.humidityButton.addTarget(self, action: #selector(humidityButtonIsPressed), for: .touchUpInside)
        customView.metricButton.addTarget(self, action: #selector(metricButtonIsPressed), for: .touchUpInside)
        customView.imperialButton.addTarget(self, action: #selector(metricButtonIsPressed), for: .touchUpInside)
        customView.pressureButton.addTarget(self, action: #selector(pressureButtonIsPressed), for: .touchUpInside)
        customView.windButton.addTarget(self, action: #selector(windButtonIsPressed), for: .touchUpInside)
    }
    //MARK: Button actions
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
    //MARK: Setup view
    func dataIsLoaded(){
        customView.humidityButton.isSelected = viewModel.settingsObjects.humidityIsSelected
        customView.pressureButton.isSelected = viewModel.settingsObjects.pressureIsSelected
        customView.windButton.isSelected = viewModel.settingsObjects.windIsSelected
        customView.metricButton.isSelected = viewModel.settingsObjects.metricSelected
        customView.imperialButton.isSelected = !viewModel.settingsObjects.metricSelected
    }
    
    //MARK: Done button pressed
    @objc func donePressed(){
        self.dismiss(animated: false, completion: nil)
        viewModel.input!.getDataSubject.onNext(true)
        doneButtonPressedDelegate!.close(settings: viewModel.settingsObjects, location: viewModel.currentLocation)
    }
    
    //MARK: ReloadTableView
    func reloadTableView(subject: PublishSubject<CellControllEnum>) -> Disposable {
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: {[unowned self]  bool in
                switch bool {
                case .add(_):
                    self.tableView.reloadData()
                    self.dataIsLoaded()
                case let .remove(index):
                    self.customView.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            },  onError: {[unowned self] (error) in
                self.viewModel.output!.popUpSubject.onNext(true)
                    print(error)
            })
    }
    //MARK: Popup
    func showPopUp(){
          let alert = UIAlertController(title: "Error", message: "Something went wrong.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
              alert.dismiss(animated: true, completion: nil)
          }))
          self.present(alert, animated: true)
      }
}

extension SettingsViewController: DeleteButtonIsPressed {
    func deletePressed(name: String) {
        viewModel.input!.removeLocationSubject.onNext(name)
    }
}
