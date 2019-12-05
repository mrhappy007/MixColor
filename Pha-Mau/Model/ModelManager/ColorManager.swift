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

    static let context = ColorManager()

    private let userDefaultKey = "ColorList"

    var colorList = [ColorModel]()

    func loadContext() {
        if !colorList.isEmpty {
            return
        }

        let userDefaults = UserDefaults.standard

        if let storeColor = userDefaults.object(forKey: userDefaultKey) as? [[String]] {
            for element in storeColor {
                appendColor(elementArray: element)
            }
            return
        }
        createNewUserDefault()

        if let storeColor = userDefaults.object(forKey: userDefaultKey) as? [[String]] {
            for element in storeColor {
                appendColor(elementArray: element)
            }
            return
        }
    }

func appentColor(colorModel: ColorModel) {
        colorList.insert(colorModel, at: 0)
        updateUserDefault()
    }

    func deleteColor(at index: Int) {
        colorList.remove(at: index)

        updateUserDefault()
    }

    func colorListSize() -> Int {
        return colorList.count
    }

    private func appendColor(elementArray element: [String]) {
        let color = ColorModel(newID: element[0], newName: element[1], newHexCode: element[2])
        colorList.append(color)
    }

    private func createNewUserDefault() {
        let userDefaults = UserDefaults.standard
        guard let path = Bundle.main.path(forResource: userDefaultKey, ofType: "plist") else {
            return
        }

        if let colorArray = NSArray(contentsOfFile: path) as? [[String]] {
            userDefaults.set(colorArray, forKey: userDefaultKey)
            userDefaults.synchronize()
        }
    }

    private func updateUserDefault() {
        let userDefaults = UserDefaults.standard
        let colorArray = convertColorListToStringArray()
        userDefaults.set(colorArray, forKey: userDefaultKey)
    }

    private func convertColorListToStringArray() -> [[String]] {
        var colorsArray = [[String]]()
        for index in 0..<colorList.count {
            let colorModel = colorList[index]
            colorsArray.append([colorModel.idColor, colorModel.name, colorModel.hexCode])
        }
        return colorsArray
    }
}
