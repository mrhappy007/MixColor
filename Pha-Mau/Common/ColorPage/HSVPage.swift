//
//  HSV.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 3/31/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
// hue saturation brightness

import UIKit

class HSVPage: UIViewController {

    @IBOutlet weak var hueSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!

    @IBOutlet weak var hueTextField: UITextField!
    @IBOutlet weak var saturationTextField: UITextField!
    @IBOutlet weak var brightnessTextField: UITextField!

    weak var hsvPageDelegate: HSVPageDelegate?
    var mainColor = UIColor(hex: 0x005493)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(color: mainColor)
    }

    func setupUI(color: UIColor) {
        let hue = color.hsv.hue
        let saturation = color.hsv.saturation
        let brightness = color.hsv.brightness

        hueTextField.text = String(hue)
        saturationTextField.text = String(saturation)
        brightnessTextField.text = String(brightness)

        hueSlider.setValue(Float(hue), animated: true)
        saturationSlider.setValue(Float(saturation), animated: true)
        brightnessSlider.setValue(Float(brightness), animated: true)
    }

    @IBAction func sliderAction(_ sender: UISlider) {
        hueTextField.text = String(Int(hueSlider.value))
        saturationTextField.text = String(Int(saturationSlider.value))
        brightnessTextField.text = String(Int(brightnessSlider.value))

        notifyRgbPageViewChange()
    }

    @IBAction func hueTextFieldChange(_ sender: UITextField) {
        textFieldDidChange(textFile: sender, hemau: .hue)
    }

    @IBAction func saturationTextFieldChange(_ sender: UITextField) {
        textFieldDidChange(textFile: sender, hemau: .saturation)
    }

    @IBAction func brightnessTextFieldChange(_ sender: UITextField) {
        textFieldDidChange(textFile: sender, hemau: .brightness)
    }

    func textFieldDidChange(textFile: UITextField, hemau: HeMau.Hsv) {
        var sliderValue: Int {
            switch hemau {
            case .hue:
                return Int(hueSlider.value)
            case .saturation:
                return Int(saturationSlider.value)
            case .brightness:
                return Int(brightnessSlider.value)
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

        switch hemau {
        case .hue:
            if newValue < 0 || 359 < newValue {
                textFile.text = String(sliderValue)
                return
            }
        default:
            if newValue < 0 || 100 < newValue {
                textFile.text = String(sliderValue)
                return
            }
        }

        switch hemau {
        case .hue:
            hueSlider.value = Float(newValue)
        case .saturation:
            saturationSlider.value = Float(newValue)
        case .brightness:
            brightnessSlider.value = Float(newValue)
        }

        notifyRgbPageViewChange()
    }

    func notifyRgbPageViewChange() {
        hsvPageDelegate?.sliderAction(hsvPage: self, hsvValue: (Int(hueSlider.value), Int(saturationSlider.value), Int(brightnessSlider.value)))
    }
}

protocol HSVPageDelegate: class {
    func sliderAction(hsvPage: UIViewController, hsvValue: (hue: Int, saturation: Int, brightness: Int))
}
