//
//  CustomView.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/11/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@IBDesignable
class CustomView: UIView {

    @IBInspectable
    var shadow: Bool = false {
        didSet (newValue) {
            shadow = newValue
            if shadow {
//                self.layer.masksToBounds = false
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

    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet (newValue) {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }

    @IBInspectable
    var borderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet (newValue) {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet (newValue) {
            if borderWidth > 0 {
                self.layer.borderWidth = borderWidth
                self.layer.masksToBounds = true
            }
        }
    }
}
