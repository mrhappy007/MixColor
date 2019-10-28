//
//  MixColors.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 9/18/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import Foundation
import UIKit

class MixColors {
    private let saiSo: CGFloat = 5.0
    private let itemsCountLimit = 5
    private let baseNumber = 50
    private var weightNumMatrix = [[Int]]()

    private var weightNums = Array(repeating: 0, count: 5)

    private let mainColor: UIColor
    private var colorList = [UIColor]()

    init(mainColor: ColorModel, colorListNew: [ColorModel]) {
        self.mainColor = UIColor(hex: mainColor.hexCode)
        colorList = createColorList(colorListModel: colorListNew)
        weightNumMatrix = createWeightNumsMatrix()
    }

    func createColorList(colorListModel: [ColorModel]) -> [UIColor] {
        var uiColorList = [UIColor]()
        for colorItem in colorListModel {
            uiColorList.append(UIColor(hex: colorItem.hexCode))
        }
        return uiColorList
    }

    func createWeightNumsMatrix() -> [[Int]] {
        let colorsCount = colorList.count

        var matrix = [[Int]]()
        for index1 in 0 ..< 20 {
            let codition1 = index1 != 0
            if colorsCount == 1 {
                if codition1 {
                    matrix.append([index1])
                }
            } else {
                for index2 in 0 ..< 20 {
                    let codition2 = codition1 && index2 != 0
                    if colorsCount == 2 {
                        if codition2 {
                            matrix.append([index1, index2])
                        }
                    } else {
                        for index3 in 0 ..< 20 {
                            let codition3 = codition2 && index3 != 0
                            if colorsCount == 3 {
                                if codition3 {
                                    matrix.append([index1, index2, index3])
                                }
                            } else {
                                for index4 in 0 ..< 20 {
                                    let codition4 = codition3 && index4 != 0
                                    if colorsCount == 4 {
                                        if codition4 {
                                            matrix.append([index1, index2, index3, index4])
                                        }
                                    } else {
                                        for index5 in 0 ..< 20 {
                                            let codition5 = codition4 && index5 != 0
                                            if colorsCount == 5 {
                                                if codition5 {
                                                    matrix.append([index1, index2, index3, index4, index5])
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return matrix
    }

    func getWeightNums() -> [Int]? {
        var weightNumsResult = Array(repeating: 0, count: colorList.count)
        if let canMixWithAColor = canMixWithAColor(mainColor: mainColor, colorList: colorList) {
            weightNumsResult[canMixWithAColor] = 100
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
        for trongSo in weightNumMatrix {

            var avgRed = 0
            var avgGreen = 0
            var avgBlue = 0

            for index in 0..<chenhLechMau.count {
                avgRed += chenhLechMau[index].0 * trongSo[index]
                avgGreen += chenhLechMau[index].1 * trongSo[index]
                avgBlue += chenhLechMau[index].2 * trongSo[index]
            }

            print(trongSo)
            print("avg r b g: \(avgRed); \(avgBlue); \(avgGreen)")

            if canMixCodition(chenhLechMau: (avgRed, avgGreen, avgBlue)) {
                let sumWeightNum = trongSo.reduce(0, +)
                return trongSo.map { Int(Float($0) / Float(sumWeightNum) * 100.0) }
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
