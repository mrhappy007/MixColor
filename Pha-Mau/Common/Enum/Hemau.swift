//
//  Hemau.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/24/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import Foundation

enum HeMau {
    case rgb(Rgb)
    case cmyk(Cmyk)
    case hsv(Hsv)

    enum Rgb {
        case red, green, blue
    }

    enum Cmyk {
        case cyan, magenta, yellow, black
    }

    enum Hsv {
        case hue, saturation, brightness
    }
}
