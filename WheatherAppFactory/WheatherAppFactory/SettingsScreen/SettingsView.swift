//
//  SettingsView.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 16/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

class SettingsView: UIView {
    
    
    @IBDesignable class PaddingLabel: UILabel {
        @IBInspectable var topInset: CGFloat = 10.0
        @IBInspectable var bottomInset: CGFloat = 5.0
        @IBInspectable var leftInset: CGFloat = 25.0
        @IBInspectable var rightInset: CGFloat = 25.0
        
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
    
   
    
    let doneButton: PaddingLabel = {
        let imageView = PaddingLabel()
        imageView.text = "Done"
        imageView.textColor = .gray
        let gothamLightFont = UIFont(name: "GothamRounded-Book", size: 14)
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
    
    let tableView: UITableView!
    
    init(frame: CGRect, tableView: UITableView) {
        self.tableView = tableView
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
        humidityStack.addArrangedSubview(humidityImage)
        humidityStack.addArrangedSubview(humidityButton)
        
        windStack.addArrangedSubview(windImage)
        windStack.addArrangedSubview(windButton)
        
        pressureStack.addArrangedSubview(pressureImage)
        pressureStack.addArrangedSubview(pressureButton)
        
        allConditionsStackView.addArrangedSubview(humidityStack)
        allConditionsStackView.addArrangedSubview(windStack)
        allConditionsStackView.addArrangedSubview(pressureStack)
        
        
        metricUnitsStackView.addArrangedSubview(metricButton)
        metricUnitsStackView.addArrangedSubview(unitMetricLabel)
        
        imperialUnitsStackView.addArrangedSubview(imperialButton)
        imperialUnitsStackView.addArrangedSubview(unitImperialLabel)
        
        unitsStackView.addArrangedSubview(metricUnitsStackView)
        unitsStackView.addArrangedSubview(imperialUnitsStackView)
        unitsStackView.alignment = .leading
        
        self.addSubview(settingsView)
        self.addSubview(doneButton)
        self.addSubview(locationLabel)
        self.addSubview(unitsLabel)
        self.addSubview(tableView)
        self.addSubview(unitsStackView)
        self.addSubview(conditionsLabel)
        self.addSubview(allConditionsStackView)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: self.topAnchor),
            settingsView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            settingsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.bounds.height/25),
            doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.bounds.height/25)
            ])
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: self.bounds.height/22),
            locationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: self.bounds.height/30),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: self.bounds.height/6.74)
            ])
        
        NSLayoutConstraint.activate([
            unitsLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: self.bounds.height/31),
            unitsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            unitsStackView.topAnchor.constraint(equalTo: unitsLabel.bottomAnchor, constant: self.bounds.height/31),
            unitsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.bounds.width/30),
            unitsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.bounds.width/30)
            ])
        
        NSLayoutConstraint.activate([
            conditionsLabel.topAnchor.constraint(equalTo: unitsStackView.bottomAnchor, constant: self.bounds.height/30),
            conditionsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            allConditionsStackView.topAnchor.constraint(equalTo: conditionsLabel.bottomAnchor, constant: self.bounds.height/30),
            allConditionsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        
    }
}
