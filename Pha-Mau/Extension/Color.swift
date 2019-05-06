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
        self.init(red: CGFloat((hex >> 16) & 0xFF) / 255,
                  green: CGFloat((hex >> 8) & 0xFF) / 255,
                  blue: CGFloat((hex >> 0) & 0xFF) / 255,
                  alpha: alpha)
    }

    convenience init(hex: String) {
        let canner = Scanner(string: hex)
        var value: UInt32 = 20651
        canner.scanHexInt32(&value)
        self.init(hex: Int(value))
    }

    convenience init(cyan: Float, magenta: Float, yellow: Float, black: Float, alpha: CGFloat = 1.0) {
        let red = (1.0 - cyan) * (1.0 - black)
        let green = (1.0 - magenta) * (1.0 - black)
        let blue = (1.0 - yellow) * (1 - black)
        self.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: alpha)
    }

    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        guard let components = self.cgColor.components else {
            return (1, 1, 1, 1)
        }
        return (components[0], components[1], components[2], components[3])
    }

    var hex: String {
        return String(format: "%02X%02X%02X", Int(rgb.red * 255), Int(rgb.green * 255), Int(rgb.blue * 255))
    }

    var cmyk: (cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat, alpha: CGFloat) {
        func max(_ fistArg: CGFloat, _ secondArg: CGFloat) -> CGFloat {
            return fistArg > secondArg ? fistArg : secondArg
        }

        let red = rgb.red
        let green = rgb.green
        let blue = rgb.blue

        let black = 1 - max(max(red, green), blue)

        if black == 1 {
            return (0, 0, 0, 1, rgb.alpha)
        }

        let cyan = (1 - red - black) / (1 - black)
        let magenta = (1 - green - black) / (1 - black)
        let yellow = (1 - blue - black) / (1 - black)

        return (cyan, magenta, yellow, black, rgb.alpha)
    }

    var hsv: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
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
        return (hue, saturation, brightness, alpha)
    }
}
