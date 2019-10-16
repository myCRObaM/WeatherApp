//
//  LocationsTableViewCell.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class LocationTableViewCell: UITableViewCell {
    
    
    let locationLabel: UILabel = {
        let textView = UILabel()
        let gothamLightFont = UIFont(name: "GothamRounded-Book", size: 20)
        textView.font = gothamLightFont
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.numberOfLines = 1
        textView.textColor = UIColor(hex: "#EFFEFF")
        return textView
    }()
    let textImageView: UILabel = {
        let image = UILabel()
        image.translatesAutoresizingMaskIntoConstraints = false
        let gothamLightFont = UIFont(name: "GothamRounded-Book", size: 20)
        image.font = gothamLightFont
        image.textAlignment = .center
        image.textColor = .white
        image.backgroundColor = UIColor(hex: "#B3D9EF")
        return image
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        contentView.addSubview(textImageView)
        contentView.addSubview(locationLabel)
        
        setupConstraints()
        
    }
    func setupConstraints(){
        textImageView.snp.makeConstraints { (make) in
            make.top.leading.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-5)
            make.height.width.equalTo(40)
        }
        
        locationLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(textImageView)
            make.trailing.equalTo(contentView)
            make.leading.equalTo(textImageView).offset(2)
        }
    }
    func setupCell(data: PostalCodes){
        locationLabel.text = data.name + ", " + data.countryCode
        textImageView.text = String(data.name.prefix(1).uppercased())
    }
}
