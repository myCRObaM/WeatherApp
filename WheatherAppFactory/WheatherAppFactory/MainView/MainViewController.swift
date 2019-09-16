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
import CoreLocation

class MainViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate{
    
    let viewModel: MainViewModel!
    let disposeBag = DisposeBag()
    var customView: MainView!
    
    var tempUnits: String = "°C"
    var speedUnit: String = "km/h"
    var searchBarCenterY: NSLayoutConstraint!
    var openSearchScreenDelegate: SearchScreenDelegate!
    var openSettingScreenDelegate: SettingsScreenDelegate!
    var vSpinner : UIView?
    var dataIsDoneLoading: hideViewController!
    let locationManager = CLLocationManager()
    
    
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
        checkForChangesInUnits()
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
    
    func setupViewModel(){
        viewModel.getData(subject: viewModel.getDataSubject).disposed(by: disposeBag)
        spinnerControl(subject: viewModel.dataIsDoneLoading).disposed(by: disposeBag)
        viewModel.addObjectToRealm(subject: viewModel.firstLoadOfRealm).disposed(by: disposeBag)
        viewModel.loadDataForScreen(subject: viewModel.loadSettingSubject).disposed(by: disposeBag)
        viewModel.loadLocationsFromRealm(subject: viewModel!.setupCurrentLocationSubject).disposed(by: disposeBag)
        locationManager.requestWhenInUseAuthorization()
        viewModel.loadSettingSubject.onNext(true)
        setupLocation(subject: viewModel.getLocationSubject).disposed(by: disposeBag)
        viewModel.addLocationToRealm(subject: viewModel.addLocationToRealmSubject).disposed(by: disposeBag)
    }
    func setupLocation(subject: PublishSubject<Bool>) -> Disposable{
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.scheduler)
            .subscribe(onNext: {[unowned self] bool in
                switch bool{
                case true:
                    if CLLocationManager.locationServicesEnabled() {
                        self.locationManager.delegate = self
                        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                        self.locationManager.startUpdatingLocation()
                    }
                case false:
                        self.locationManager.stopUpdatingLocation()
                    }
                
            })}
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        viewModel.locationToUse = String(String(locValue.latitude) + "," + String(locValue.longitude))
        viewModel.getLocationSubject.onNext(false)
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            self.viewModel.locationsData = LocationsObject(placeName: city, countryCode: Locale.current.regionCode ?? country, lng: locValue.longitude, lat: locValue.latitude, isSelected: true)
            self.viewModel.firstLoadOfRealm.onNext(true)
            self.viewModel.getDataSubject.onNext(self.viewModel.locationToUse)
        }
    }
    
    
    func setupSearchBar() {
        let searchTextField:UITextField = customView.searchBar.subviews[0].subviews.last as! UITextField
        searchTextField.layer.cornerRadius = 15
        searchTextField.textAlignment = NSTextAlignment.left
        let image:UIImage = UIImage(named: "search_icon")!
        let imageView:UIImageView = UIImageView.init(image: image)
        searchTextField.leftView = nil
        searchTextField.placeholder = "Search"
        searchTextField.rightView = imageView
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(hex: "#6DA133")
        if let backgroundview = searchTextField.subviews.first {
            backgroundview.layer.cornerRadius = 18;
            backgroundview.clipsToBounds = true;
        }
        searchTextField.rightViewMode = UITextField.ViewMode.always
    }
    func setupData(){
        
        let weatherData = viewModel.mainWeatherData.currently
        checkSettings()
        customView.currentTemperatureLabel.text = String(Int(weatherData.temperature)) + "°"
        customView.currentSummaryLabel.text = weatherData.summary
        customView.location.text = viewModel.locationsData.placeName
        customView.humidityLabel.text = String(Int(weatherData.humidity * 100)) + " %"
        customView.windLabel.text = String((weatherData.windSpeed * 10).rounded()/10) + speedUnit
        customView.pressureLabel.text = String(Int(weatherData.pressure)) + " hpa"
        
        let imageExtension = weatherData.icon
        customView.headerImage.image = UIImage(named: "header_image-\(imageExtension)")
        customView.mainBodyImage.image = UIImage(named: "body_image-\(imageExtension)")
        setupGradient(weatherData)
        
        setupLowAndHighTemperatures(viewModel.mainWeatherData)
        
        viewModel.isDownloadingFromSearch = false
        
    }
    
    func checkForChangesInUnits(){
        if viewModel.settingsObjects.metricSelected {
            viewModel.unitMode = "si"
        } else {
            viewModel.unitMode = "us"
        }
        
        if viewModel.unitMode == "si" {
            tempUnits = "°C"
            speedUnit = "km/h"
        }
        else {
            tempUnits = "°F"
            speedUnit = "mph"
        }
    }
    
    func setupGradient(_ data: Currently){
        var firstColor = UIColor(hex: "#15587B")
        var secondColor = UIColor(hex: "#4A75A2")
        if data.icon == "clear-day" || data.icon == "wind"  {
            firstColor = UIColor(hex: "#59B7E0")
            secondColor = UIColor(hex: "#D8D8D8")
        }
        else if data.icon == "clear-night" || data.icon == "partly-cloudy-night"{
            firstColor = UIColor(hex: "#044663")
            secondColor = UIColor(hex: "#234880")
        }
        else if data.icon == "rain" || data.icon == "cloudy" || data.icon == "thunderstorm" || data.icon == "tornado" || data.icon == "hail"{
            firstColor = UIColor(hex: "#15587B")
            secondColor = UIColor(hex: "#4A75A2")
        }
        else if data.icon == "snow" || data.icon == "sleet" {
            firstColor = UIColor(hex: "#0B3A4E")
            secondColor = UIColor(hex: "#80D5F3")
        }
        else if data.icon == "fog" || data.icon == "cloudy" || data.icon == "partly-cloudy-day" {
            firstColor = UIColor(hex: "#ABD6E9")
            secondColor = UIColor(hex: "#D8D8D8")
        }
        
        
        let gradientLocal: CAGradientLayer = {
            let gradientLocal: CAGradientLayer = [
                firstColor,
                secondColor
                ].gradient()
            gradientLocal.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLocal.endPoint = CGPoint(x: 0.5, y: 0.98)
            return gradientLocal
        }()
        
        customView.gradientView.setupUI(gradientLocal)
    }
    func setupLowAndHighTemperatures(_ data: MainDataClass){
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: NSDate(timeIntervalSince1970: Double(data.currently.time)) as Date)
        
        for day in data.daily.data {
            let searchDay = calendar.component(.day, from: NSDate(timeIntervalSince1970: Double(day.time)) as Date)
            if currentDay == searchDay {
                self.customView.lowTemperatureLabel.text = String((day.temperatureMin * 10).rounded() / 10) + tempUnits
                self.customView.highTemperatureLabel.text = String((day.temperatureMax * 10).rounded() / 10) + tempUnits
            }
        }
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
    
    @objc func settingPressed(){
        openSettingScreenDelegate.buttonPressed(rootController: self)
    }
    
    func searchBarPressed(){
        openSearchScreenDelegate.openSearchScreen(searchBar: customView.searchBar, rootController: self)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBarPressed()
        return false
    }
    
    func spinnerControl(subject: PublishSubject<DataDoneEnum>) -> Disposable{
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.scheduler)
            .subscribe(onNext: {[unowned self] bool in
                switch bool {
                case .dataForMainDone:
                    self.setupData()
                    self.removeSpinner()
                    self.viewModel.addLocationToRealmSubject.onNext(true)
                case .dataNotReady:
                     self.showSpinner(onView: self.view)
                case .dataFromSearchDone:
                    self.view.addSubview(self.customView.searchBar)
                    self.setupSearchBarConstraints()
                    self.customView.searchBar.text = ""
                    self.dataIsDoneLoading.didLoadData()
                    self.setupData()
                    self.removeSpinner()
                    self.viewModel.addLocationToRealmSubject.onNext(true)
                    self.viewModel.firstLoadOfRealm.onNext(true)
                }
                
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
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let _ = country, error == nil else { return }
            self.viewModel.locationToUse = String(String(lat) + "," + String(String(long)))
            self.viewModel.locationsData = LocationsObject(placeName: city, countryCode: countryc, lng: long, lat: lat, isSelected: true)
            self.viewModel.getDataSubject.onNext(self.viewModel.locationToUse)
        }
    }
}

extension MainViewController: DoneButtonIsPressedDelegate {
    func close(settings: SettingsScreenObject, location: LocationsObject) {
        viewModel.locationsData = location
        viewModel.settingsObjects = settings
        checkForChangesInUnits()
        viewModel.loadSettingSubject.onNext(true)
    }
}
