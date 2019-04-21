//
//  Color.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/4/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((hex >> 16) & 0xFF),
                  green: CGFloat((hex >> 8) & 0xFF),
                  blue: CGFloat((hex >> 0) & 0xFF),
                  alpha: alpha)
    }

    convenience init(cyan: Int, magenta: Int, yellow: Int, black: Int, alpha: CGFloat = 1.0) {
        let red = (1.0 - Float(cyan) / 100.0) * (1.0 - Float(black) / 100.0) * 255
        let green = (1.0 - Float(magenta) / 100.0) * (1.0 - Float(black) / 100.0)
        let blue = (1.0 - Float(yellow) / 100.0) * (1 - Float(black) / 100.0)
        self.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: alpha)
    }

    var rgb: (red: Int, green: Int, blue: Int, alpha: CGFloat) {
        guard let components = self.cgColor.components else {
            return (255, 255, 255, 1)
        }
        return (Int(components[0]), Int(components[1]), Int(components[2]), components[3])
    }

    var hex: String {
        return String(format: "%02X%02X%02X", rgb.red, rgb.green, rgb.blue)
    }

    var cmyk: (cyan: Int, magenta: Int, yellow: Int, black: Int, alpha: CGFloat) {

        let maxValueCMYK: Float = 100.0

        func max(_ fistArg: Float, _ secondArg: Float) -> Float {
            return fistArg > secondArg ? fistArg : secondArg
        }

        let red = Float(rgb.red) / 255.0
        let green = Float(rgb.green) / 255.0
        let blue = Float(rgb.blue) / 255.0

        let black = maxValueCMYK - max(max(red, green), blue)

        if black == maxValueCMYK {
            return (0, 0, 0, Int(black), rgb.alpha)
        }

        let cyan = (maxValueCMYK - red - black) / (maxValueCMYK - black)
        let magenta = (maxValueCMYK - green - black) / (maxValueCMYK - black)
        let yellow = (maxValueCMYK - blue - black) / (maxValueCMYK - black)

        return (Int(cyan), Int(magenta), Int(yellow), Int(black), rgb.alpha)
    }

    var hsv: (hue: Int, saturation: Int, brightness: Int, alpha: CGFloat) {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0
        var alpha: CGFloat = 0.0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return (Int(hue), Int(saturation), Int(brightness), alpha)
    }
}
