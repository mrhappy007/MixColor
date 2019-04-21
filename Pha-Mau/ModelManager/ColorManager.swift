//
//  ColorsManager.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/20/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import Foundation
import UIKit

class ColorManager {

    static var shareColor = ColorManager()

    var color: UIColor

    init(color: UIColor = UIColor(hex: 0x005493)) {
        self.color = color
    }

    func setColor(newColor: UIColor) {
        color = newColor
    }
}
