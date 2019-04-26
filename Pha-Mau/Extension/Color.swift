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

    convenience init(cyan: Float, magenta: Float, yellow: Float, black: Float, alpha: CGFloat = 1.0) {
        let red = (1.0 - cyan) * (1.0 - black)
        let green = (1.0 - magenta) * (1.0 - black)
        let blue = (1.0 - yellow) * (1 - black)
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
        func max(_ fistArg: Float, _ secondArg: Float) -> Float {
            return fistArg > secondArg ? fistArg : secondArg
        }

        let red = Float(rgb.red) / 255.0
        let green = Float(rgb.green) / 255.0
        let blue = Float(rgb.blue) / 255.0

        let black = 1 - max(max(red, green), blue)

        if black == 1 {
            return (0, 0, 0, 100, rgb.alpha)
        }

        let cyan = (1 - red - black) / (1 - black)
        let magenta = (1 - green - black) / (1 - black)
        let yellow = (1 - blue - black) / (1 - black)

        return (Int(cyan * 100), Int(magenta * 100), Int(yellow * 100), Int(black * 100), rgb.alpha)
    }

    var hsv: (hue: Int, saturation: Int, brightness: Int, alpha: CGFloat) {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0
        var alpha: CGFloat = 0.0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        if saturation > 1 {
            saturation = 1
        } else if saturation < 0 {
            saturation = 0
        }

        if brightness > 1 {
            brightness = 1
        } else if brightness < 0 {
            brightness = 0
        }

        return (Int(hue * 359), Int(saturation * 100), Int(brightness * 100), alpha)
    }
}
