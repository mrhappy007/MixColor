//
//  MixColors.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 9/18/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import Foundation
import UIKit

class MixColorsV2 {
    private let saiSo: CGFloat = 5.0
    private let itemsCountLimit = 5
    private let baseNumber = 50
    private let maTranTrongSo = { () -> [[Int]] in
        var maTran = [[Int]]()
        for index1 in 0 ..< 50 {
            for index2 in 0 ..< 50 - index1 {
                for index3 in 0 ..< 50 - index1 - index2 {
                    for index4 in 0 ..< 50 - index1 - index2 - index3 {
                        let index5 = 50 - index1 - index2 - index3 - index4
                        maTran.append([index1, index2, index3, index4, index5])
                    }
                }
            }
        }
        return maTran
    }()

    private var weightNums = Array(repeating: 0, count: 5)

    private let mainColor: UIColor
    private let colorList: [UIColor]

    init(mainColor: ColorModel, colorListNew: [ColorModel]) {
        self.mainColor = UIColor(hex: mainColor.hexCode)
        var uiColorList = [UIColor]()
        for colorItem in colorListNew {
            uiColorList.append(UIColor(hex: colorItem.hexCode))
        }
        self.colorList = uiColorList
    }

    func getWeightNums() -> [Int]? {
        var weightNumsResult = Array(repeating: 0, count: colorList.count)
        if let canMixWithAColor = canMixWithAColor(mainColor: mainColor, colorList: colorList) {
            weightNumsResult[canMixWithAColor] = 1
            return weightNumsResult
        }
        return canMixWithColors(mainColor: mainColor, colorList: colorList)
    }

    private func canMixWithAColor(mainColor: UIColor, colorList: [UIColor]) -> Int? {
        return colorList.firstIndex(where: {
            canMixCodition(mainColor: mainColor, colorMix: $0)
        })
    }

    private func canMixWithColors(mainColor: UIColor, colorList: [UIColor]) -> [Int]? {
        let chenhLechMau = tinhChenhLechMau(mainColor: mainColor, colorList: colorList)
        for trongSo in maTranTrongSo {
            var avgRed = 0
            var avgGreen = 0
            var avgBlue = 0

            for index in 0..<chenhLechMau.count {
                avgRed += chenhLechMau[index].0 * trongSo[index]
                avgGreen += chenhLechMau[index].1 * trongSo[index]
                avgBlue += chenhLechMau[index].2 * trongSo[index]
            }

            if canMixCodition(chenhLechMau: (avgRed, avgGreen, avgBlue)) {
                return trongSo
            }
        }
        return nil
    }

    private func tinhChenhLechMau(mainColor: UIColor, colorList: [UIColor]) -> [(red: Int, green: Int, blue: Int)] {
        return colorList.map {
            (Int( (mainColor.rgb.red - $0.rgb.red) * 255),
            Int( (mainColor.rgb.green - $0.rgb.green) * 255),
            Int( (mainColor.rgb.blue - $0.rgb.blue) * 255))
        }
    }

    private func canMixCodition(mainColor: UIColor, colorMix: UIColor) -> Bool {
        return (abs(mainColor.rgb.red - colorMix.rgb.red) * 255 <= self.saiSo &&
            abs(mainColor.rgb.green - colorMix.rgb.green) * 255 <= self.saiSo &&
            abs(mainColor.rgb.blue - colorMix.rgb.blue) * 255 <= self.saiSo)
    }

    private func canMixCodition(chenhLechMau: (avgRed: Int, avgGreen: Int, avgBlue: Int)) -> Bool {
        let saiSoInt = Int(self.saiSo)
        return abs(chenhLechMau.avgRed) <= saiSoInt
            && abs(chenhLechMau.avgGreen) <= saiSoInt
            && abs(chenhLechMau.avgBlue) <= saiSoInt
    }
}
