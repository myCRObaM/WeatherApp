//
//  GradientView.swift
//  WheatherAppFactory
//
//  Created by Matej Hetzel on 11/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit
import Hue

class GradientView: UIView {
    
    var gradient: CAGradientLayer = {
        var gradient: CAGradientLayer = [
            UIColor(hex: "#59B7E0"),
            UIColor(hex: "#D8D8D8")
            ].gradient()
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.98)
        return gradient
    }()
    
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradient.frame = self.bounds
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI(self.gradient)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI(self.gradient)
    }
    
    func setupUI(_ gradient: CAGradientLayer){
        self.gradient = gradient
        self.gradient.frame = self.bounds
        self.layer.insertSublayer(self.gradient, at: 0)
    }
}
