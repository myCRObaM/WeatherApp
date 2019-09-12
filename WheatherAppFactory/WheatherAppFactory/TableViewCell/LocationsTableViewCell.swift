//
//  LocationsTableViewCell.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

class LocationTableViewCell: UITableViewCell {
    
    
    let locationLabel: UILabel = {
        let textView = UILabel()
        let gothamLightFont = UIFont(name: "GothamRounded-Light", size: 20)
        textView.font = gothamLightFont
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.numberOfLines = 1
        textView.textColor = UIColor(hex: "#EFFEFF")
        return textView
    }()
    let textImageView: UILabel = {
        let image = UILabel()
        image.translatesAutoresizingMaskIntoConstraints = false
        let gothamLightFont = UIFont(name: "GothamRounded-Light", size: 20)
        image.font = gothamLightFont
        image.textAlignment = .center
        image.textColor = .white
        image.backgroundColor = UIColor(hex: "#B3D9EF")
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textImageView)
        contentView.addSubview(locationLabel)
        
        
        NSLayoutConstraint.activate([
            textImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            textImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textImageView.heightAnchor.constraint(equalToConstant: 40),
            textImageView.widthAnchor.constraint(equalToConstant: 40),
            
            
//             locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
//            locationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            locationLabel.centerYAnchor.constraint(equalTo: textImageView.centerYAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: textImageView.trailingAnchor, constant: 2)
            ])
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(data: PostalCodes){
        locationLabel.text = data.placeName + ", " + data.countryCode
        textImageView.text = String(data.placeName.prefix(1).uppercased())
    }
}
