//
//  CustomView.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/11/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView: UIView {

    @IBInspectable
    var shadow: Bool = true {
        didSet (newValue) {
            shadow = newValue
            if shadow {
                self.layer.masksToBounds = false
                self.layer.shadowColor = UIColor.darkGray.cgColor
                self.layer.shadowOpacity = 0.5
                self.layer.shadowOffset = CGSize(width: 0, height: 0.1)
                self.layer.shadowRadius = 0
                self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
                self.layer.shouldRasterize = true
                self.layer.rasterizationScale = UIScreen.main.scale
            }
        }
    }
}
