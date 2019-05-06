//
//  ColorDetailViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/13/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class ColorDetailViewController: UIViewController {

    @IBOutlet weak var reviewColorView: UIView!
    @IBOutlet weak var colorName: UILabel!
    @IBOutlet weak var hexCodeLabel: UILabel!
    @IBOutlet weak var rgbCodeLabel: UILabel!
    @IBOutlet weak var cmykCodeLabel: UILabel!
    @IBOutlet weak var hsvCodeLabel: UILabel!
    @IBOutlet weak var doThuongDung: UILabel!

    var colorIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        if colorIndex != -1 {
            updateUI(colorModel: ColorManager.context.colorList[colorIndex])
        }
    }

    func updateIndexColor(index: Int) {
        updateUI(colorModel: ColorManager.context.colorList[index])
    }

    private func updateUI(colorModel: ColorModel) {
        reviewColorView.backgroundColor = UIColor(hex: colorModel.hexCode)
        colorName.text = colorModel.name
        hexCodeLabel.text = "#" + colorModel.hexCode

        let color = UIColor(hex: colorModel.hexCode)
        updateRGBCodeLabel(color: color)
        updateCMYKCodeLabel(color: color)
        updateHsvCodeLabel(color: color)
    }

    private func updateRGBCodeLabel(color: UIColor) {
        let rgb = color.rgb
        rgbCodeLabel.text = "\(rgb.red) : \(rgb.green) : \(rgb.blue)"
    }

    private func updateCMYKCodeLabel(color: UIColor) {
        let cmyk = color.cmyk
        cmykCodeLabel.text = "\(cmyk.cyan) : \(cmyk.magenta) : \(cmyk.yellow) : \(cmyk.black)"
    }

    private func updateHsvCodeLabel(color: UIColor) {
        let hsv = color.hsv
        hsvCodeLabel.text = "\(hsv.hue) : \(hsv.saturation) : \(hsv.brightness)"
    }
}
