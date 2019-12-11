//
//  HistoryColor.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 11/26/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import Foundation
import UIKit

class HistoryColorManager {

    static let context = HistoryColorManager()

    private let userDefaultKey = "History"

    private var historyColors = [[ColorModel]]()

    func loadContext() {

        print("new h 0")
        if !historyColors.isEmpty {
            return
        }

        let userDefaults = UserDefaults.standard

        if let storeColor = userDefaults.object(forKey: userDefaultKey) as? [[[String]]] {
            for element in storeColor {
                appendColor(elementArray: element)
            }
            return
        }

        createNewUserDefault()

        if let storeColor = userDefaults.object(forKey: userDefaultKey) as? [[[String]]] {
            for element in storeColor {
                appendColor(elementArray: element)
            }
            return
        }
    }

    func mainColor(at: Int) -> ColorModel {
        return historyColors[at][0]
    }

    func colorListMix(index: Int) -> [ColorModel] {
        return historyColors[index].filter {
            $0 != historyColors[index][0]
        }
    }

    func appentColor(mainColor: ColorModel, colorListMix: [ColorModel]) {
        let newValue = [mainColor] + colorListMix
        historyColors.insert(newValue, at: 0)
        updateUserDefault()
    }

    func deleteColor(at index: Int) {
        historyColors.remove(at: index)

        updateUserDefault()
    }

    func colorListSize() -> Int {
        return historyColors.count
    }

    private func appendColor(elementArray elements: [[String]]) {
        var colors = [ColorModel]()
        for element in elements {
            let color = ColorModel(newID: element[0], newName: element[1], newHexCode: element[2], newTrongSo: Int(element[3]) ?? 0)
            colors.append(color)
        }
        historyColors.append(colors)
    }

    private func createNewUserDefault() {
        print("new h")
        let userDefaults = UserDefaults.standard
        guard let path = Bundle.main.path(forResource: userDefaultKey, ofType: "plist") else {
            return
        }

        if let colorArray = NSArray(contentsOfFile: path) as? [[[String]]] {
            userDefaults.set(colorArray, forKey: userDefaultKey)
            userDefaults.synchronize()
        }
    }

    private func updateUserDefault() {
        let userDefaults = UserDefaults.standard
        let colorArray = convertColorListToStringArray()
        userDefaults.set(colorArray, forKey: userDefaultKey)
    }

    private func convertColorListToStringArray() -> [[[String]]] {
        var colorsArray = [[[String]]]()
        for colors in historyColors {
            var colorArray = [[String]]()
            for index in 0..<colors.count {
                let colorModel = colors[index]
                colorArray.append([colorModel.idColor, colorModel.name, colorModel.hexCode, String(colorModel.trongSo)])
            }
            colorsArray.append(colorArray)
        }
        return colorsArray
    }
}
