//
//  CustomMainself.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 16/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class MainView: UIView    {
    
    var gradientView: GradientView!
    
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
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.heightAnchor.constraint(equalToConstant: 72).isActive = true
        let gothamLightFont = UIFont(name: "GothamRounded-Light", size: 72)
        temp.font = gothamLightFont
        temp.text = "99°"
        temp.textColor = .white
        return temp
    }()
    
    let currentSummaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
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
        self.addSubview(mainBodyImage)
        self.insertSubview(gradientView, belowSubview: mainBodyImage)
        self.insertSubview(headerImage, aboveSubview: gradientView)
        self.insertSubview(topTempStackView, aboveSubview: headerImage)
        self.addSubview(location)
        self.addSubview(highAndLowTempStackView)
        self.addSubview(moreInfoStackView)
        self.addSubview(searchBar)
        self.addSubview(settingsImage)
        
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
        
        setupConstraints()
    }
    func setupConstraints(){
        
        topTempStackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(self.bounds.height/7)
        }
        
        mainBodyImage.snp.makeConstraints { (make) in
            make.top.equalTo(topTempStackView.snp.bottom).offset(self.bounds.height/15)
            make.leading.bottom.trailing.equalTo(self)
        }
        
        gradientView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(self)
            make.bottom.equalTo(mainBodyImage.snp.top).offset(self.bounds.height/5)
        }
        
        headerImage.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(mainBodyImage.snp.top)
            make.top.equalTo(self).offset(self.bounds.height/25)
        }
        
        location.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(topTempStackView.snp.bottom).offset(self.bounds.height/7)
        }
        
        highAndLowTempStackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(location.snp.bottom).offset(self.bounds.height/18)
        }
        
        moreInfoStackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(highAndLowTempStackView.snp.bottom).offset(self.bounds.height/13)
        }
        
        settingsImage.snp.makeConstraints { (make) in
            make.top.equalTo(moreInfoStackView.snp.bottom).offset(self.bounds.height/11)
            make.leading.equalTo(self).offset(10)
        }
    }
}
