//
//  LocationsTableViewCell.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 12/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

protocol DeleteButtonIsPressed{
    func deletePressed(name: String)
}

class LocationSettingsTableViewCell: UITableViewCell {
    
    var localData: PostalCodes!
    var deleteButtonPressed: DeleteButtonIsPressed!
    
    let locationLabel: UILabel = {
        let textView = UILabel()
        let gothamLightFont = UIFont(name: "GothamRounded-Book", size: 20)
        textView.font = gothamLightFont
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.numberOfLines = 1
        textView.textColor = UIColor(hex: "#EFFEFF")
        return textView
    }()
    let deleteLocation: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icons8-delete-50"), for: .normal)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    func setupUI(){
        contentView.addSubview(deleteLocation)
        contentView.addSubview(locationLabel)
        deleteLocation.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        deleteLocation.snp.makeConstraints { (make) in
            make.top.leading.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-5)
            make.height.width.equalTo(40)
        }
        
        locationLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(deleteLocation)
            make.trailing.equalTo(contentView)
            make.leading.equalTo(deleteLocation.snp.trailing).offset(2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(data: PostalCodes){
        localData = data
        locationLabel.text = data.name + ", " + data.countryCode
    }
    @objc func deletePressed(){
        deleteButtonPressed.deletePressed(name: localData.name)
    }
}
