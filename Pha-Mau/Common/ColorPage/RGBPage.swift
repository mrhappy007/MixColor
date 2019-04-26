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

    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!

    weak var rgbPageDelegate: RGBPageDelegate?
    var mainColor = UIColor(hex: 0x005493)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(color: mainColor)
    }

    func setupUI(color: UIColor) {
        let redValue = color.rgb.red
        let greenValue = color.rgb.green
        let blueValue = color.rgb.blue

        redTextField.text = String(redValue)
        greenTextField.text = String(greenValue)
        blueTextField.text = String(blueValue)

        redSlider.setValue(Float(redValue), animated: true)
        greenSlider.setValue(Float(greenValue), animated: true)
        blueSlider.setValue(Float(blueValue), animated: true)
    }

    @IBAction func sliderAction(_ sender: UISlider) {
        redTextField.text = String(Int(redSlider.value))
        greenTextField.text = String(Int(greenSlider.value))
        blueTextField.text = String(Int(blueSlider.value))

        notifyRgbPageViewChange()
    }

    @IBAction func redTextFieldChange(_ sender: UITextField) {
        textFieldDidChange(textFile: sender, hemau: .red)
    }

    @IBAction func greenTextFieldChange(_ sender: UITextField) {
        textFieldDidChange(textFile: sender, hemau: .green)
    }

    @IBAction func blueTextFieldChange(_ sender: UITextField) {
        textFieldDidChange(textFile: sender, hemau: .blue)
    }

    func textFieldDidChange(textFile: UITextField, hemau: HeMau.Rgb) {
        var sliderValue: Int {
            switch hemau {
            case .red:
                return Int(redSlider.value)
            case .green:
                return Int(greenSlider.value)
            case .blue:
                return Int(blueSlider.value)
            }
        }

        guard let text = textFile.text else {
            textFile.text = String(sliderValue)
            return
        }
        guard let newValue = Int(text) else {
            textFile.text = String(sliderValue)
            return
        }
        if newValue < 0 || 255 < newValue {
            textFile.text = String(sliderValue)
            return
        }

        switch hemau {
        case .red:
            redSlider.value = Float(newValue)
        case .green:
            greenSlider.value = Float(newValue)
        case .blue:
            blueSlider.value = Float(newValue)
        }

        notifyRgbPageViewChange()
    }

    func notifyRgbPageViewChange() {
        rgbPageDelegate?.sliderAction(rgbPage: self, rgbValue: (red: Int(redSlider.value), green: Int(greenSlider.value), blue: Int(blueSlider.value)))
    }
}

protocol RGBPageDelegate: class {
    func sliderAction(rgbPage: UIViewController, rgbValue: (red: Int, green: Int, blue: Int))
}
