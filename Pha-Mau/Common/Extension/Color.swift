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

    convenience init(cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat, alpha: CGFloat) {
        let red = (1 - cyan) * (1 - black)
        let green = (1 - magenta) * (1 - black)
        let blue = (1 - yellow) * (1 - black)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
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

        func max(_ fistArg: Int, _ secondArg: Int) -> Int {
            return fistArg > secondArg ? fistArg : secondArg
        }

        let red = rgb.red
        let green = rgb.green
        let blue = rgb.blue

        let black = 255 - max(max(red, green), blue)

        if black == 255 {
            return (0, 0, 0, 255, rgb.alpha)
        }

        let cyan = (255 - red - black) / (255 - black)
        let magenta = (255 - green - black) / (255 - black)
        let yellow = (255 - blue - black) / (255 - black)

        return (cyan, magenta, yellow, black, rgb.alpha)
    }

    var hsv: (hue: Int, saturation: Int, brightness: Int, alpha: CGFloat) {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0
        var alpha: CGFloat = 0.0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return (Int(hue), Int(saturation), Int(brightness), alpha)
    }
}
