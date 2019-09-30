//
//  ViewController.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 10/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit
import RxSwift
import Hue
import MapKit

class MainViewController: UIViewController, UISearchBarDelegate{
    
    let viewModel: MainViewModel!
    let disposeBag = DisposeBag()
    var customView: MainView!
    
    var searchBarCenterY: NSLayoutConstraint!
    weak var openSearchScreenDelegate: SearchScreenDelegate?
    weak var openSettingScreenDelegate: SettingsScreenDelegate?
    var vSpinner : UIView?
    var dataIsDoneLoading: hideViewController!
    
    
//MARK: SearchBar
  func setupSearchBar(){
           let searchTextField = customView.searchBar.value(forKey: "searchField") as! UITextField
           searchTextField.textAlignment = NSTextAlignment.left
           let image:UIImage = UIImage(named: "search_icon")!
           let imageView:UIImageView = UIImageView.init(image: image)
           imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
           imageView.tintColor = UIColor(hex: "#6DA133")
           searchTextField.leftView = nil
           searchTextField.placeholder = "Search"
           searchTextField.rightView = imageView
           searchTextField.rightViewMode = UITextField.ViewMode.always
           
           if let backgroundview = searchTextField.subviews.first {
               backgroundview.layer.cornerRadius = 18;
               backgroundview.clipsToBounds = true;
           }
       }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupSearchBar()
        super.viewDidAppear(animated)
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: setupView
    func setupView(){
        
       customView = MainView(frame: view.frame)

        view.addSubview(customView)
        setupConstraints()
        
        customView.settingsImage.addTarget(self, action: #selector(settingPressed), for: .touchUpInside)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: view.topAnchor),
            customView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        setupSearchBarConstraints()
    }
    
    func setupSearchBarConstraints(){
        customView.searchBar.delegate = self
        searchBarCenterY = NSLayoutConstraint(item: customView.searchBar, attribute: .centerY, relatedBy: .equal, toItem: customView.settingsImage, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            customView.searchBar.heightAnchor.constraint(equalToConstant: 70),
            customView.searchBar.leadingAnchor.constraint(equalTo: customView.settingsImage.trailingAnchor, constant: 10),
            customView.searchBar.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -10)
            ])
        view.addConstraint(searchBarCenterY)
        
    }
    
    //MARK: Setup view by settings
    func checkSettings(){
        if viewModel.settingsObjects.humidityIsSelected {
            setupHumidity()
        }
        else {
            customView.moreInfoStackView.removeArrangedSubview(customView.humidityStackView)
            customView.humidityStackView.removeFromSuperview()
        }
        if viewModel.settingsObjects.windIsSelected {
            setupWind()
        }
        else {
            customView.moreInfoStackView.removeArrangedSubview(customView.windStackView)
            customView.windStackView.removeFromSuperview()
        }
        if viewModel.settingsObjects.pressureIsSelected {
            setupPressure()
        }
        else {
            customView.moreInfoStackView.removeArrangedSubview(customView.pressureStackView)
            customView.pressureStackView.removeFromSuperview()
        }
    }
    
    func setupHumidity(){
        customView.humidityStackView.addArrangedSubview(customView.humidityImage)
        customView.humidityStackView.addArrangedSubview(customView.humidityLabel)
        
        customView.moreInfoStackView.addArrangedSubview(customView.humidityStackView)
    }
    func setupWind(){
        customView.windStackView.addArrangedSubview(customView.windImage)
        customView.windStackView.addArrangedSubview(customView.windLabel)
        
        customView.moreInfoStackView.addArrangedSubview(customView.windStackView)
    }
    func setupPressure(){
        customView.pressureStackView.addArrangedSubview(customView.pressureImage)
        customView.pressureStackView.addArrangedSubview(customView.pressureLabel)
    
        customView.moreInfoStackView.addArrangedSubview(customView.pressureStackView)
    }
    
    //MARK: setupViewModel
    func setupViewModel(){
        
        let output = viewModel.transform(input: MainViewModel.Input(getDataSubject: ReplaySubject<String>.create(bufferSize: 1), loadSettingSubject: ReplaySubject<Bool>.create(bufferSize: 1), firstLoadOfRealm: PublishSubject<Bool>(), getLocationSubject: PublishSubject<Bool>(), addLocationToRealmSubject: PublishSubject<Bool>(), setupCurrentLocationSubject: PublishSubject<Bool>()))
        
        for disposable in output.disposables {
            disposable.disposed(by: disposeBag)
        }
        
        viewModel.output?.popUpSubject
        .observeOn(MainScheduler.instance)
        .subscribeOn(viewModel.dependencies.scheduler)
        .subscribe(onNext: {[unowned self] bool in
                self.showPopUp()
            }).disposed(by: disposeBag)

        spinnerControl(subject: viewModel.output!.dataIsDoneLoading).disposed(by: disposeBag)
        viewModel.locationManager.requestWhenInUseAuthorization()
        viewModel.input!.loadSettingSubject.onNext(true)
    }
    
   
    //MARK: setupData
    func setupData(){
        let lowAndHighTemp = viewModel.setupLowAndHighTemperatures(viewModel.mainWeatherData)
        let weatherData = viewModel.mainWeatherData.currently
        let imageExtension = weatherData.icon
        
        checkSettings()
        customView.currentTemperatureLabel.text = String(Int(weatherData.temperature)) + "°"
        customView.currentSummaryLabel.text = weatherData.summary
        customView.location.text = viewModel.locationsData.placeName
        customView.humidityLabel.text = String(Int(weatherData.humidity * 100)) + " %"
        customView.windLabel.text = lowAndHighTemp.speed
        customView.pressureLabel.text = String(Int(weatherData.pressure)) + " hpa"
        
        customView.headerImage.image = UIImage(named: "header_image-\(imageExtension)")
        customView.mainBodyImage.image = UIImage(named: "body_image-\(imageExtension)")
        customView.gradientView.setupUI(viewModel.setupGradient(weatherData))
        
        customView.lowTemperatureLabel.text = lowAndHighTemp.lowTemp
        customView.highTemperatureLabel.text = lowAndHighTemp.highTemp
        
        viewModel.isDownloadingFromSearch = false
    }
    
    //MARK: Spinner control
    func spinnerControl(subject: PublishSubject<DataDoneEnum>) -> Disposable{
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.dependencies.scheduler)
            .subscribe(onNext: {[unowned self] bool in
                switch bool {
                case .dataForMainDone:
                    self.setupData()
                    self.removeSpinner()
                    self.viewModel.input!.addLocationToRealmSubject.onNext(true)
                case .dataNotReady:
                    self.showSpinner(onView: self.view)
                case .dataFromSearchDone:
                    self.view.addSubview(self.customView.searchBar)
                    self.setupSearchBarConstraints()
                    self.customView.searchBar.text = ""
                    self.dataIsDoneLoading.didLoadData()
                    self.setupData()
                    self.removeSpinner()
                    self.viewModel.input!.addLocationToRealmSubject.onNext(true)
                    self.viewModel.input!.firstLoadOfRealm.onNext(true)
                }
                
            },  onError: {[unowned self] (error) in
                self.viewModel.output!.popUpSubject.onNext(true)
                    print(error)
            })
    }
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    func hideSearch(){
        self.view.addSubview(self.customView.searchBar)
        self.setupSearchBarConstraints()
        self.customView.searchBar.text = ""
    }
    
    
    @objc func settingPressed(){
        openSettingScreenDelegate!.buttonPressed(rootController: self)
    }
    
    func searchBarPressed(){
        openSearchScreenDelegate!.openSearchScreen(searchBar: customView.searchBar, rootController: self)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBarPressed()
        return false
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
extension MainViewController: hideKeyboard {
    func hideViewController() {
        hideSearch()
    }
}

extension MainViewController: ChangeLocationBasedOnSelection{
    func didSelectLocation(long: Double, lat: Double, location: String, countryc: String) {
        viewModel.isDownloadingFromSearch = true
        
        let location = CLLocation(latitude: lat, longitude: long)
        viewModel.fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let _ = country, error == nil else { return }
            let locationToUse = String(lat) + "," + String(long)
            self.viewModel.locationsData = LocationsObject(placeName: city, countryCode: countryc, lng: long, lat: lat, isSelected: true)
            self.viewModel.settingsObjects = SettingsScreenObject(metricSelected: true, humidityIsSelected: true, windIsSelected: true, pressureIsSelected: true, lastSelectedLocation: self.viewModel.locationsData.placeName)
            self.viewModel.input!.getDataSubject.onNext(locationToUse)
        }
    }
}

extension MainViewController: DoneButtonIsPressedDelegate {
    func close(settings: SettingsScreenObject, location: LocationsObject) {
        viewModel.locationsData = location
        viewModel.settingsObjects = settings
        viewModel.input!.loadSettingSubject.onNext(true)
    }
}
