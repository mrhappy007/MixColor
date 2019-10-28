//
//  ViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 3/21/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var reviewColorView: UIView!
    @IBOutlet weak var colorsSegmented: UISegmentedControl!
    @IBOutlet weak var colorNameTextField: UITextField!
    @IBOutlet weak var colorCodeTextfield: UITextField!

    var colorManager = ColorManager.context

    var mainColor = ColorModel()

    var pageColorViewController: ColorPageViewController? {
        didSet {
            pageColorViewController?.pageColorDelegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultName()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        colorManager.loadContext()
        pageColorViewController?.mainColorUpdate(color: UIColor(hex: mainColor.hexCode))
        colorNameTextField.text = mainColor.name
        updateUI(newColorHexCode: mainColor.hexCode)
    }

    private func updateUI(newColorHexCode: String) {
        mainColor.hexCode = newColorHexCode
        reviewColorView.backgroundColor = UIColor(hex: newColorHexCode)
        colorCodeTextfield.text = newColorHexCode
        pageColorViewController?.mainColorUpdate(color: UIColor(hex: newColorHexCode))
    }

    private func setDefaultName() {
        mainColor.setDefaultColorName()
        colorNameTextField.text = mainColor.name
    }

    /*
     Nếu dùng chung với updateUI
     thì xuất hiện bug
 K(cmyk) = 1 c,m,y = 0
     v(hsv) = 0 -> h,s = 0
     */
    private func updateReviewColorAndHexCode(newColorHexCode: String) {
        mainColor.hexCode = newColorHexCode
        reviewColorView.backgroundColor = UIColor(hex: newColorHexCode)
        colorCodeTextfield.text = newColorHexCode
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageColorViewController = segue.destination as? ColorPageViewController {
            self.pageColorViewController = pageColorViewController
        }

        if segue.identifier == "ChooseColorWithCamera" {
            if let customCameraView = segue.destination as? CustomCameraViewController {
                customCameraView.customCameraDelegate = self
            }
        }
    }

    @IBAction func colorNameDidChange(_ sender: UITextField) {
        guard let colorName = sender.text else {
            colorNameTextField.text = mainColor.name
            return
        }
        if colorName.isEmpty {
            colorNameTextField.text = mainColor.name
            return
        }
        mainColor.name = colorName
    }

    @IBAction func maMauDidChange(_ sender: UITextField) {
        guard let hexCode = sender.text else {
            updateUI(newColorHexCode: mainColor.hexCode)
            return
        }

        if hexCode.isEmpty {
            updateUI(newColorHexCode: mainColor.hexCode)
            return
        }

        let exception: UInt32 = 16_777_215 // 16_777_215 = ffffff

        let canner = Scanner(string: hexCode)
        var value: UInt32 = exception
        canner.scanHexInt32(&value)

        if value > exception {
            updateUI(newColorHexCode: mainColor.hexCode)
            return
        }

        updateUI(newColorHexCode: String(String("000000" + hexCode).dropFirst(hexCode.count)))
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == colorCodeTextfield {
            textField.resignFirstResponder()
            return true
        }
        return false
    }

    @IBAction func switchColorSegmeted(_ sender: UISegmentedControl) {
        switchColorView(index: sender.selectedSegmentIndex)
        pageColorViewController?.whichToPage(index: sender.selectedSegmentIndex, updateColor: UIColor(hex: mainColor.hexCode))
    }

    @IBAction func saveDidSelect(_ sender: UIBarButtonItem) {
        colorNameDidChange(colorNameTextField)
        maMauDidChange(colorCodeTextfield)

        colorManager.appentColor(colorModel: mainColor.copy() as! ColorModel)

        guard let colorDetailView = (storyboard?.instantiateViewController(withIdentifier: "ColorDetailView") as? ColorDetailViewController) else {
            return
        }
        colorDetailView.mainColor = mainColor
        self.navigationController?.pushViewController(colorDetailView, animated: true)
    }

    @IBAction func mixColor(_ sender: UIButton) {
        guard let chooseColorView = (storyboard?.instantiateViewController(withIdentifier: "ChooseColorsView") as? ChooseColorsViewController) else {
            return
        }
        chooseColorView.mainColor = mainColor
        self.navigationController?.pushViewController(chooseColorView, animated: true)
    }

    private func switchColorView(index: Int) {
        let images = [#imageLiteral(resourceName: "RGB"), #imageLiteral(resourceName: "CMYK"), #imageLiteral(resourceName: "HSV")]
        let imagesBW = [#imageLiteral(resourceName: "RGBB&W"), #imageLiteral(resourceName: "CMYKB&W"), #imageLiteral(resourceName: "HSVB&W")]
        for index in 0...2 {
            colorsSegmented.setImage(imagesBW[index], forSegmentAt: index)
        }
        colorsSegmented.setImage(images[index], forSegmentAt: index)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension HomeViewController: ColorPageViewControllerDelegate {
    func sliderAction(pageViewController: UIPageViewController, colorHexCode: String) {
        updateReviewColorAndHexCode(newColorHexCode: colorHexCode)
    }
}

extension HomeViewController: CustomCameraDelegate {
    func choosedColor(colorHexResult: String) {
        if colorHexResult.isEmpty { return }
        updateReviewColorAndHexCode(newColorHexCode: colorHexResult)
    }
}
