//
//  CMYK.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 3/31/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
// cyan magenta yellow black

import UIKit

class CMYKPage: UIViewController {

    @IBOutlet weak var cyanSlider: UISlider!
    @IBOutlet weak var magentaSlider: UISlider!
    @IBOutlet weak var yellowSlider: UISlider!
    @IBOutlet weak var blackSlider: UISlider!

    @IBOutlet weak var cyanTextField: UITextField!
    @IBOutlet weak var magentaTextField: UITextField!
    @IBOutlet weak var yellowTextField: UITextField!
    @IBOutlet weak var blackTextField: UITextField!

    weak var cmykPageDelegate: CMYKPageDelegate?
    var mainColor = UIColor(hex: 0x005493)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(color: mainColor)
    }

    func setupUI(color: UIColor) {
        let cyan = color.cmyk.cyan
        let magenta = color.cmyk.magenta
        let yellow = color.cmyk.yellow
        let black = color.cmyk.black

        cyanTextField.text = String(cyan)
        magentaTextField.text = String(magenta)
        yellowTextField.text = String(yellow)
        blackTextField.text = String(black)

        cyanSlider.setValue(Float(cyan), animated: true)
        magentaSlider.setValue(Float(magenta), animated: true)
        yellowSlider.setValue(Float(yellow), animated: true)
        blackSlider.setValue(Float(black), animated: true)
    }

    @IBAction func sliderAction(_ sender: UISlider) {
        cyanTextField.text = String(Int(cyanSlider.value))
        magentaTextField.text = String(Int(magentaSlider.value))
        yellowTextField.text = String(Int(yellowSlider.value))
        blackTextField.text = String(Int(blackSlider.value))

        notifyCmykPageViewChange()
    }

    @IBAction func cyanTextFieldChange(_ sender: UITextField) {
        textFieldDidChange(textFile: sender, hemau: .cyan)
    }

    @IBAction func magentaTextFieldChange(_ sender: UITextField) {
        textFieldDidChange(textFile: sender, hemau: .magenta)
    }

    @IBAction func yellowTextFieldChange(_ sender: UITextField) {
        textFieldDidChange(textFile: sender, hemau: .yellow)
    }

    @IBAction func blackTextFieldChange(_ sender: UITextField) {
        textFieldDidChange(textFile: sender, hemau: .black)
    }

    func textFieldDidChange(textFile: UITextField, hemau: HeMau.Cmyk) {
        var sliderValue: Int {
            switch hemau {
            case .cyan:
                return Int(cyanSlider.value)
            case .magenta:
                return Int(magentaSlider.value)
            case .yellow:
                return Int(yellowSlider.value)
            case .black:
                return Int(blackSlider.value)
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
        if newValue < 0 || 100 < newValue {
            textFile.text = String(sliderValue)
            return
        }

        switch hemau {
        case .cyan:
            cyanSlider.value = Float(newValue)
        case .magenta:
            magentaSlider.value = Float(newValue)
        case .yellow:
            yellowSlider.value = Float(newValue)
        case .black:
            blackSlider.value = Float(newValue)
        }

        notifyCmykPageViewChange()
    }

    func notifyCmykPageViewChange() {
        cmykPageDelegate?.sliderAction(cmykPage: self, cmykValue: (Int(cyanSlider.value), Int(magentaSlider.value), Int(yellowSlider.value), Int(blackSlider.value)))
    }
}

protocol CMYKPageDelegate: class {
    func sliderAction(cmykPage: UIViewController, cmykValue: (cyan: Int, magenta: Int, yellow: Int, black: Int))
}
