//
//  Color.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/30/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import Foundation

class ColorModel {

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

    convenience init() {
        self.init(newName: "new color", newHexCode: "005493")
    }
}
