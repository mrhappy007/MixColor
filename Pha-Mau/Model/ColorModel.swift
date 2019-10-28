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

    init(newID: String = "", newName: String = "", newHexCode: String) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmmss"

        hexCode = newHexCode

        name = newName
        if newName.isEmpty {
            name = formatter.string(from: date)
        }

        idColor = newID
        if newID.isEmpty {
            idColor = formatter.string(from: date)
        }
    }

    convenience override init() {
        self.init(newName: "New color", newHexCode: "005493")
    }

    func setDefaultColorName() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmmss"
        name = formatter.string(from: date)
    }
}

func == (lhs: ColorModel, rhs: ColorModel) -> Bool {
    return lhs.idColor == rhs.idColor
}
