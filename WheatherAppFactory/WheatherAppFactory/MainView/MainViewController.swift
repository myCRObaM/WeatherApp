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

protocol hideKeyboard {
    func hideViewController()
}

protocol SearchScreenDelegate {
    func openSearchScreen(searchBar: UISearchBar, rootController: MainViewController)
}


class MainViewController: UIViewController, UISearchBarDelegate{
    
    let viewModel: MainViewModel!
    let disposeBag = DisposeBag()
    var gradientView: GradientView!
    var tempUnits: String = "°C"
    var speedUnit: String = "km/h"
    var searchBarCenterY: NSLayoutConstraint!
    var openSearchScreenDelegate: SearchScreenDelegate!
    var locationText: String = "Zagreb"
    var vSpinner : UIView?
    
    
    let gradient: CAGradientLayer = {
        var gradient: CAGradientLayer = [
            UIColor(hex: "#59B7E0"),
            UIColor(hex: "#D8D8D8")
            ].gradient()
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.98)
        return gradient
    }()
    
    let mainBodyImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "body_image-clear-day")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mainBodyBackgroundStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        return stack
    }()
    
    let backgroundStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        return stack
    }()
    
    let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "header_image-clear-day")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let currentTemperatureLabel: UILabel = {
        let temp = UILabel()
        //temp.translatesAutoresizingMaskIntoConstraints = false
        let gothamLightFont = UIFont(name: "GothamRounded-Light", size: 72)
        temp.font = gothamLightFont
        temp.text = "99°"
        temp.textColor = .white
        return temp
    }()
    
    let currentSummaryLabel: UILabel = {
        let label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        let gothamLightFont = UIFont(name: "GothamRounded-Light", size: 24)
        label.font = gothamLightFont
        label.text = "Summary koji ce bi ovako negdje"
        label.textColor = .white
        return label
    }()
    
    let topTempStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        return stack
    }()
    
    
    let location: UILabel = {
        let location = UILabel()
        location.translatesAutoresizingMaskIntoConstraints = false
        let gothamLightFont = UIFont(name: "GothamRounded-Book", size: 36)
        location.font = gothamLightFont
        location.text = "London"
        location.textColor = .white
        return location
    }()
    
    let lowTemperatureLabel: UILabel = {
        let label = UILabel()
        let gothamLightFont = UIFont(name: "GothamRounded-Light", size: 24)
        label.font = gothamLightFont
        label.text = "89.3°"
        label.textColor = .white
        return label
    }()
    
    let lowTempWritingLabel: UILabel = {
        let label = UILabel()
        let gothamLightFont = UIFont(name: "GothamRounded-Light", size: 20)
        label.font = gothamLightFont
        label.text = "Low"
        label.textColor = .white
        return label
    }()
    let highTemperatureLabel: UILabel = {
        let label = UILabel()
        let gothamLightFont = UIFont(name: "GothamRounded-Light", size: 24)
        label.font = gothamLightFont
        label.text = "95.4°"
        label.textColor = .white
        return label
    }()
    
    let highTempWritingLabel: UILabel = {
        let label = UILabel()
        let gothamLightFont = UIFont(name: "GothamRounded-Light", size: 20)
        label.font = gothamLightFont
        label.text = "High"
        label.textColor = .white
        return label
    }()
    
    let lowTempStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        return stack
    }()
    
    let highTempStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        return stack
    }()
    
    let highAndLowTempStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 40
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        return stack
    }()
    
    let humidityImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "humidity")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        let gothamLightFont = UIFont(name: "GothamRounded-Light", size: 20)
        label.font = gothamLightFont
        label.text = "0.8%"
        label.textColor = .white
        return label
    }()
    
    let humidityStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.widthAnchor.constraint(equalToConstant: 94).isActive = true
        return stack
    }()
    
    let windImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wind")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let windLabel: UILabel = {
        let label = UILabel()
        let gothamLightFont = UIFont(name: "GothamRounded-Light", size: 20)
        label.font = gothamLightFont
        label.text = "1.2 mph"
        label.textColor = .white
        return label
    }()
    
    let windStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.widthAnchor.constraint(equalToConstant: 94).isActive = true
        return stack
    }()
    
    let pressureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pressure")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let pressureLabel: UILabel = {
        let label = UILabel()
        let gothamLightFont = UIFont(name: "GothamRounded-Light", size: 20)
        label.font = gothamLightFont
        label.text = "1009 hpa"
        label.textColor = .white
        return label
    }()
    
    let pressureStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.widthAnchor.constraint(equalToConstant: 94).isActive = true
        stack.alignment = .center
        return stack
    }()
    
    
    
    let moreInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 40
        stack.alignment = .center
        return stack
    }()
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.barTintColor = .green
        bar.backgroundImage = UIImage()
        return bar
    }()
    
    let settingsImage: UIButton = {
        let imageView = UIButton()
        imageView.setImage(UIImage(named: "settings_icon"), for: .normal)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    
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
        gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        settingsImage.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        gradientView.setupUI(gradient)
        view.addSubview(mainBodyImage)
        view.insertSubview(gradientView, belowSubview: mainBodyImage)
        view.insertSubview(headerImage, aboveSubview: gradientView)
        view.insertSubview(topTempStackView, aboveSubview: headerImage)
        view.addSubview(location)
        view.addSubview(highAndLowTempStackView)
        view.addSubview(moreInfoStackView)
        view.addSubview(searchBar)
        view.addSubview(settingsImage)
        //view.addSubview(searchBarStackView)
        
        topTempStackView.addArrangedSubview(currentTemperatureLabel)
        topTempStackView.addArrangedSubview(currentSummaryLabel)
        
        lowTempStackView.addArrangedSubview(lowTemperatureLabel)
        lowTempStackView.addArrangedSubview(lowTempWritingLabel)
        
        
        
        highTempStackView.addArrangedSubview(highTemperatureLabel)
        highTempStackView.addArrangedSubview(highTempWritingLabel)
        
        highAndLowTempStackView.addArrangedSubview(lowTempStackView)
        let separator = UIView()
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = .white
        highAndLowTempStackView.addArrangedSubview(separator)
        separator.heightAnchor.constraint(equalTo: highAndLowTempStackView.heightAnchor).isActive = true
        
        highAndLowTempStackView.addArrangedSubview(highTempStackView)
        
        humidityStackView.addArrangedSubview(humidityImage)
        humidityStackView.addArrangedSubview(humidityLabel)
        
        windStackView.addArrangedSubview(windImage)
        windStackView.addArrangedSubview(windLabel)
        
        pressureStackView.addArrangedSubview(pressureImage)
        pressureStackView.addArrangedSubview(pressureLabel)
        
        moreInfoStackView.addArrangedSubview(humidityStackView)
        moreInfoStackView.addArrangedSubview(windStackView)
        moreInfoStackView.addArrangedSubview(pressureStackView)
        
        
        //        searchBarStackView.addArrangedSubview(settingsImage)
        //        searchBarStackView.addArrangedSubview(searchBar)
        
        setupConstraints()
        
        settingsImage.addTarget(self, action: #selector(settingPressed), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topTempStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topTempStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/5),
            topTempStackView.heightAnchor.constraint(equalToConstant: view.bounds.height/9)
            ])
        
        NSLayoutConstraint.activate([
            mainBodyImage.topAnchor.constraint(equalTo: currentSummaryLabel.topAnchor),
            mainBodyImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainBodyImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainBodyImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: mainBodyImage.topAnchor, constant: view.bounds.height/5),
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            ])
        NSLayoutConstraint.activate([
            headerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImage.bottomAnchor.constraint(equalTo: mainBodyImage.topAnchor),
            headerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/25),
            ])
        
        NSLayoutConstraint.activate([
            location.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            location.topAnchor.constraint(equalTo: topTempStackView.bottomAnchor, constant: view.bounds.height/7),
            ])
        
        NSLayoutConstraint.activate([
            highAndLowTempStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            highAndLowTempStackView.topAnchor.constraint(equalTo: location.bottomAnchor, constant: view.bounds.height/18),
            ])
        
        NSLayoutConstraint.activate([
            moreInfoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            moreInfoStackView.topAnchor.constraint(equalTo: highAndLowTempStackView.bottomAnchor, constant: view.bounds.height/13),
            ])
        
        
        
        NSLayoutConstraint.activate([
            settingsImage.topAnchor.constraint(equalTo: moreInfoStackView.bottomAnchor, constant: view.bounds.height/11),
            //settingsImage.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            settingsImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            ])
        setupSearchBarConstraints()
    }
    
    func setupViewModel(){
        viewModel.getData(subject: viewModel.getDataSubject).disposed(by: disposeBag)
        spinnerControl(subject: viewModel.dataIsDoneLoading).disposed(by: disposeBag)
        viewModel.getDataSubject.onNext(viewModel.locationToUse)
    }
    func setupSearchBar() {
        let searchTextField:UITextField = searchBar.subviews[0].subviews.last as! UITextField
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
        checkForChangesInUnits()
        let weatherData = viewModel.mainWeatherData.currently
//        var currentLocation: String = ""
//        if let index = (viewModel.mainWeatherData.timezone.range(of: "/")?.upperBound){
//            currentLocation = String(viewModel.mainWeatherData.timezone.suffix(from: index))
//        }
        currentTemperatureLabel.text = String(Int(weatherData.temperature)) + "°"
        currentSummaryLabel.text = weatherData.summary
        location.text = locationText
        humidityLabel.text = String(Int(weatherData.humidity * 100)) + " %"
        windLabel.text = String((weatherData.windSpeed * 10).rounded()/10) + speedUnit
        pressureLabel.text = String(Int(weatherData.pressure)) + " hpa"
        let imageExtension = weatherData.icon
        headerImage.image = UIImage(named: "header_image-\(imageExtension)")
        mainBodyImage.image = UIImage(named: "body_image-\(imageExtension)")
        setupGradient(weatherData)
        setupLowAndHighTemperatures(viewModel.mainWeatherData)
    }
    
    func checkForChangesInUnits(){
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
        
        gradientView.setupUI(gradientLocal)
    }
    func setupLowAndHighTemperatures(_ data: MainDataClass){
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: NSDate(timeIntervalSince1970: Double(data.currently.time)) as Date)
        
        for day in data.daily.data {
            let searchDay = calendar.component(.day, from: NSDate(timeIntervalSince1970: Double(day.time)) as Date)
            if currentDay == searchDay {
                self.lowTemperatureLabel.text = String((day.temperatureMin * 10).rounded() / 10) + tempUnits
                self.highTemperatureLabel.text = String((day.temperatureMax * 10).rounded() / 10) + tempUnits
            }
        }
    }
    func setupSearchBarConstraints(){
        searchBar.delegate = self
        searchBarCenterY = NSLayoutConstraint(item: searchBar, attribute: .centerY, relatedBy: .equal, toItem: settingsImage, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 70),
            searchBar.leadingAnchor.constraint(equalTo: settingsImage.trailingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ])
        view.addConstraint(searchBarCenterY)
        
    }
    @objc func settingPressed(){
        
    }
    func searchBarPressed(){
        openSearchScreenDelegate.openSearchScreen(searchBar: searchBar, rootController: self)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBarPressed()
        return false
    }
    
    func spinnerControl(subject: PublishSubject<Bool>) -> Disposable{
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(viewModel.scheduler)
            .subscribe(onNext: {[unowned self] bool in
                switch bool {
                case true:
                    self.setupData()
                    self.removeSpinner()
                case false:
                    self.showSpinner(onView: self.view)
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
    
}
extension MainViewController: hideKeyboard {
    func hideViewController() {
        view.addSubview(searchBar)
        setupSearchBarConstraints()
        searchBar.text = ""
    }
}

extension MainViewController: ChangeLocationBasedOnSelection{
    func didSelectLocation(long: Double, lat: Double, location: String) {
        viewModel.locationToUse = String(String(long) + "," + String(String(lat)))
        viewModel.getDataSubject.onNext(viewModel.locationToUse)
        self.locationText = location
    }
    
    
}
