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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? LocationTableViewCell else {
            fatalError("nije settano")
            
        }
        cell.setupCell(data: PostalCodes(placeName: "Neki", countryCode: "hr", lng: 23.2, lat: 12.3))
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        return cell
    }
    
    let viewModel: SettingsScreenModel!
    var doneButtonPressedDelegate: DoneButtonIsPressedDelegate!
    let disposeBag = DisposeBag()
    
    
    @IBDesignable class PaddingLabel: UILabel {
        @IBInspectable var topInset: CGFloat = 3.0
        @IBInspectable var bottomInset: CGFloat = 3.0
        @IBInspectable var leftInset: CGFloat = 5.0
        @IBInspectable var rightInset: CGFloat = 5.0
        
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        }
        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + leftInset + rightInset,
                          height: size.height + topInset + bottomInset)
        }
    }
    
    let locationLabel: UILabel = {
        let location = UILabel()
        location.translatesAutoresizingMaskIntoConstraints = false
        let gothamLightFont = UIFont(name: "GothamRounded-Book", size: 20)
        location.font = gothamLightFont
        location.text = "Location"
        location.textColor = .white
        return location
    }()
    
    let unitsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let gothamLightFont = UIFont(name: "GothamRounded-Book", size: 20)
        label.font = gothamLightFont
        label.text = "Units"
        label.textColor = .white
        return label
    }()
    let unitsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let metricUnitsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        return stack
    }()
    let imperialUnitsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        return stack
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let doneButton: PaddingLabel = {
        let imageView = PaddingLabel()
        imageView.text = "Done"
        imageView.textColor = .clear
        let gothamLightFont = UIFont(name: "GothamRounded-Book", size: 36)
        imageView.font = gothamLightFont
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let settingsView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let metricButton: UIButton = {
        let imageView = UIButton()
        imageView.setImage(UIImage(named: "square_checkmark_check"), for: .selected)
        imageView.setImage(UIImage(named: "square_checkmark_uncheck"), for: .normal)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let imperialButton: UIButton = {
        let imageView = UIButton()
        imageView.setImage(UIImage(named: "square_checkmark_check"), for: .selected)
        imageView.setImage(UIImage(named: "square_checkmark_uncheck"), for: .normal)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let unitMetricLabel: UILabel = {
        let textView = UILabel()
        let gothamLightFont = UIFont(name: "GothamRounded-Book", size: 20)
        textView.font = gothamLightFont
        textView.text = "Metric"
        textView.numberOfLines = 1
        textView.textColor = UIColor(hex: "#EFFEFF")
        return textView
    }()
    let unitImperialLabel: UILabel = {
        let textView = UILabel()
        let gothamLightFont = UIFont(name: "GothamRounded-Book", size: 20)
        textView.font = gothamLightFont
        textView.text = "Imperial"
        textView.numberOfLines = 1
        textView.textColor = UIColor(hex: "#EFFEFF")
        return textView
    }()
   
    let conditionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let gothamLightFont = UIFont(name: "GothamRounded-Book", size: 20)
        label.font = gothamLightFont
        label.text = "Conditions"
        label.textColor = .white
        return label
    }()
    
    let humidityImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "humidity")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let humidityButton: UIButton = {
        let imageView = UIButton()
        imageView.setImage(UIImage(named: "checkmark_check"), for: .selected)
        imageView.setImage(UIImage(named: "checkmark_uncheck"), for: .normal)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let humidityStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.widthAnchor.constraint(equalToConstant: 94).isActive = true
        stack.alignment = .center
        return stack
    }()
    
    let windImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wind")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let windButton: UIButton = {
        let imageView = UIButton()
        imageView.setImage(UIImage(named: "checkmark_check"), for: .selected)
        imageView.setImage(UIImage(named: "checkmark_uncheck"), for: .normal)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let windStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.widthAnchor.constraint(equalToConstant: 94).isActive = true
        stack.spacing = 15
        stack.alignment = .center
        return stack
    }()
    
    let pressureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pressure")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let pressureButton: UIButton = {
        let imageView = UIButton()
        imageView.setImage(UIImage(named: "checkmark_check"), for: .selected)
        imageView.setImage(UIImage(named: "checkmark_uncheck"), for: .normal)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let pressureStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.widthAnchor.constraint(equalToConstant: 94).isActive = true
        stack.spacing = 15
        stack.alignment = .center
        return stack
    }()
    
    let allConditionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 40
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
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
        
        humidityStack.addArrangedSubview(humidityImage)
        humidityStack.addArrangedSubview(humidityButton)
        
        windStack.addArrangedSubview(windImage)
        windStack.addArrangedSubview(windButton)
        
        pressureStack.addArrangedSubview(pressureImage)
        pressureStack.addArrangedSubview(pressureButton)
        
        allConditionsStackView.addArrangedSubview(humidityStack)
        allConditionsStackView.addArrangedSubview(windStack)
        allConditionsStackView.addArrangedSubview(pressureStack)
        
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(donePressed))
        doneButton.addGestureRecognizer(labelTap)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "cellID")
        
        
        metricUnitsStackView.addArrangedSubview(metricButton)
        metricUnitsStackView.addArrangedSubview(unitMetricLabel)

        imperialUnitsStackView.addArrangedSubview(imperialButton)
        imperialUnitsStackView.addArrangedSubview(unitImperialLabel)

        unitsStackView.addArrangedSubview(metricUnitsStackView)
        unitsStackView.addArrangedSubview(imperialUnitsStackView)
        unitsStackView.alignment = .leading
        
        view.addSubview(settingsView)
        view.addSubview(doneButton)
        view.addSubview(locationLabel)
        view.addSubview(tableView)
        view.addSubview(unitsLabel)
        view.addSubview(unitsStackView)
        view.addSubview(conditionsLabel)
        view.addSubview(allConditionsStackView)
        
        viewModel.updateRealmSettingsObject(subject: viewModel.getDataSubject).disposed(by: disposeBag)
        dataIsLoaded()
        setupConstraints()
        setupButtons()
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.topAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height/25),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.height/25)
            ])
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height/22),
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: view.bounds.height/30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: view.bounds.height/6.74)
            ])
        
        NSLayoutConstraint.activate([
            unitsLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: view.bounds.height/31),
            unitsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            unitsStackView.topAnchor.constraint(equalTo: unitsLabel.bottomAnchor, constant: view.bounds.height/31),
            unitsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/30),
            unitsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width/30)
            ])
        
        NSLayoutConstraint.activate([
            conditionsLabel.topAnchor.constraint(equalTo: unitsStackView.bottomAnchor, constant: view.bounds.height/30),
            conditionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            allConditionsStackView.topAnchor.constraint(equalTo: conditionsLabel.bottomAnchor, constant: view.bounds.height/30),
            allConditionsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        
    }
    
    func setupButtons(){
        humidityButton.addTarget(self, action: #selector(humidityButtonIsPressed), for: .touchUpInside)
        metricButton.addTarget(self, action: #selector(metricButtonIsPressed), for: .touchUpInside)
        imperialButton.addTarget(self, action: #selector(metricButtonIsPressed), for: .touchUpInside)
        pressureButton.addTarget(self, action: #selector(pressureButtonIsPressed), for: .touchUpInside)
        windButton.addTarget(self, action: #selector(windButtonIsPressed), for: .touchUpInside)
    }
    
    @objc func humidityButtonIsPressed(){
        humidityButton.isSelected = !humidityButton.isSelected
        viewModel.settingsObjects.humidityIsSelected = humidityButton.isSelected
        dataIsLoaded()
    }
    
    @objc func metricButtonIsPressed(){
        imperialButton.isSelected = !imperialButton.isSelected
        metricButton.isSelected = !metricButton.isSelected
        viewModel.settingsObjects.metricSelected = metricButton.isSelected
        dataIsLoaded()
    }
    @objc func pressureButtonIsPressed(){
        pressureButton.isSelected = !pressureButton.isSelected
        viewModel.settingsObjects.pressureIsSelected = pressureButton.isSelected
        dataIsLoaded()
    }
    @objc func windButtonIsPressed(){
        windButton.isSelected = !windButton.isSelected
        viewModel.settingsObjects.windIsSelected = windButton.isSelected
        dataIsLoaded()
    }
    
    func dataIsLoaded(){
        if viewModel.settingsObjects.humidityIsSelected {
            humidityButton.isSelected = true
        }
        if viewModel.settingsObjects.pressureIsSelected {
            pressureButton.isSelected = true
        }
        if viewModel.settingsObjects.windIsSelected {
            windButton.isSelected = true
        }
        if viewModel.settingsObjects.metricSelected {
            metricButton.isSelected = true
        }
        else {
            imperialButton.isSelected = true
        }
    }
    
    @objc func donePressed(){
        self.dismiss(animated: false, completion: nil)
        viewModel.getDataSubject.onNext(true)
        doneButtonPressedDelegate.close(settings: viewModel.settingsObjects)
    }
}
