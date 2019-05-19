//
//  MixColors.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 5/11/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import Foundation
import UIKit

class MixColor {

    private let saiSo = 10
    private let numberElement = 5

    private var mainColor = ColorModel()
    private var colorList = [ColorModel]() // gioi han 10 mau
    private var chenhLechMau = [[Int]]() //nx3
    private var trongSo = [[Int]]() //

    init(newMainColor: ColorModel, newColorList: [ColorModel]) {
        mainColor = newMainColor
        colorList = newColorList
    }

    func mixColor() -> [Int]? {
        chenhLechMau = tinhChenhLechMau()
        print("chenh lech mau: ", chenhLechMau)

        if let index = caseOneColor() {
            var currentTrongSo = Array(repeating: 0, count: numberElement)
            currentTrongSo[index] = 100 //100%
            return currentTrongSo
        }
        if let currentTrongSo = caseDefault() {
            return currentTrongSo
        }
        return nil
    }

    private func tinhChenhLechMau() -> [[Int]] {
        var chenhMau = Array(repeating: Array(repeating: 255, count: 3), count: numberElement)
        let rgbMainColor = UIColor(hex: mainColor.hexCode).rgb
        let numberItem = colorList.count > numberElement ? numberElement : colorList.count
        for index in 0..<numberItem {
            let colorItem = UIColor(hex: colorList[index].hexCode).rgb
            chenhMau[index][0] = Int((rgbMainColor.red - colorItem.red) * 100)
            chenhMau[index][1] = Int((rgbMainColor.green - colorItem.green) * 100)
            chenhMau[index][2] = Int((rgbMainColor.blue - colorItem.blue) * 100)
        }
        return chenhMau
    }

    private func tinhTongKhiNhanVoiTronSo(trongSo: [Int], col: Int) -> Int {
        var sum = 0
        for index in 0..<trongSo.count {
            sum += chenhLechMau[index][col] * trongSo[index]
        }
        return sum
    }

    private func tinhTongChenhLech(chenhLechRGB: [Int]) -> Int {
        return abs(chenhLechRGB[0]) + abs(chenhLechRGB[1]) + abs(chenhLechRGB[2])
    }

    private func caseOneColor() -> Int? {
        var currentIndex = 0
        var minChenhLech = tinhTongChenhLech(chenhLechRGB: chenhLechMau[currentIndex])

        for index in 1..<chenhLechMau.count {
            if tinhTongChenhLech(chenhLechRGB: chenhLechMau[index]) < minChenhLech {
                currentIndex = index
                minChenhLech = tinhTongChenhLech(chenhLechRGB: chenhLechMau[index])
            }
        }
        if minChenhLech <= saiSo {
            return currentIndex
        }
        return nil
    }

    /**
     Tính giá trị trọng số cho 10 element of chenh lech mau.
     nếu |sum(Red)| + |sum(Green)| + |sum(Blue)| < sai so && mĩnimun -> chọn bộ trọng số đó làm đáp án.
     nếu khôgn trả về nil.
     */
    private func caseDefault() -> [Int]? {
        var resultTrongso = [Int]()
        var minChenhLech = 100000

        var sumRed = 0
        var sumGreen = 0
        var sumBlue = 0

        for index_0 in 0...100 {
            for index_1 in 0...(100 - index_0) {
                for index_2 in 0...(100 - index_0 - index_1) {
                    for index_3 in 0...(100 - index_0 - index_1 - index_2) {
                        let index_4 = 100 - index_0 - index_1 - index_2 - index_3
                        let trongSoArray = [index_0, index_1, index_2, index_3, index_4]

                        sumRed = tinhTongKhiNhanVoiTronSo(trongSo: trongSoArray, col: 0)
                        sumGreen = tinhTongKhiNhanVoiTronSo(trongSo: trongSoArray, col: 1)
                        sumBlue = tinhTongKhiNhanVoiTronSo(trongSo: trongSoArray, col: 2)

                        if tinhTongChenhLech(chenhLechRGB: [sumRed, sumGreen, sumBlue]) < minChenhLech {
                            minChenhLech = tinhTongChenhLech(chenhLechRGB: [sumRed, sumGreen, sumBlue])
                            resultTrongso = trongSoArray
                        }
                    }
                }
            }
        }

        if minChenhLech <= saiSo * 100 {
            return resultTrongso
        }
        return nil
    }
}
