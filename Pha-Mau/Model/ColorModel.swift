//
//  Color.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/30/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import Foundation

class ColorModel: NSObject, NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        let colorModel = ColorModel(newID: self.idColor, newName: self.name, newHexCode: self.hexCode)
        return colorModel
    }

    var name: String
    var hexCode: String
    var idColor: String

    init(newID: String = "", newName: String, newHexCode: String) {
        name = newName
        hexCode = newHexCode
        if newID.isEmpty {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            idColor = formatter.string(from: date)
            return
        }
        idColor = newID
    }

    convenience override init() {
        self.init(newName: "New color", newHexCode: "005493")
    }

    func setDefaultColorName() {
        name = "New color"
    }
}

func == (lhs: ColorModel, rhs: ColorModel) -> Bool {
    return lhs.idColor == rhs.idColor
}
