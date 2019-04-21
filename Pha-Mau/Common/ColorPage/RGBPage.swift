//
//  GRB.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 3/31/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class RGBPage: UIViewController {

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!

    @IBOutlet weak var redLabel: UITextField!
    @IBOutlet weak var greenLabel: UITextField!
    @IBOutlet weak var blueLabel: UITextField!

    weak var rgbPageDelegate: RGBPageDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        rgbPageDelegate?.rgbSliderAction(rgbPage: self, rgbValue: (red: 0, green: 0, blue: 255))
    }

    @IBAction func sliderAction(_ sender: UISlider) {
        redLabel.text = String(Int(redSlider.value))
        greenLabel.text = String(Int(greenSlider.value))
        blueLabel.text = String(Int(blueSlider.value))

        rgbPageDelegate?.rgbSliderAction(rgbPage: self, rgbValue: (Int(redSlider.value), Int(greenSlider.value), Int(blueSlider.value)))
    }

    func setupUI(color: UIColor) {
        let redValue = color.rgb.red
        let greenValue = color.rgb.green
        let blueValue = color.rgb.blue

        redLabel.text = String(redValue)
        greenLabel.text = String(greenValue)
        blueLabel.text = String(blueValue)

        redSlider.setValue(Float(redValue), animated: true)
        greenSlider.setValue(Float(greenValue), animated: true)
        blueSlider.setValue(Float(blueValue), animated: true)
    }
}

protocol RGBPageDelegate: class {
    func rgbSliderAction(rgbPage: UIViewController, rgbValue: (red: Int, green: Int, blue: Int))
}
