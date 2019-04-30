//
//  ViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 3/21/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var reviewColorView: UIView!

    @IBOutlet weak var colorsSegmented: UISegmentedControl!

    @IBOutlet weak var tenMauTextField: UITextField!
    @IBOutlet weak var maMauTextfield: UITextField!

    var mainColor = UIColor(hex: "005493")

    var pageColorViewController: ColorPageViewController? {
        didSet {
            pageColorViewController?.pageColorDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    func updateUI() {
        reviewColorView.backgroundColor = mainColor
        maMauTextfield.text = mainColor.hex
        pageColorViewController?.mainColorUpdate(color: mainColor)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageColorViewController = segue.destination as? ColorPageViewController {
            self.pageColorViewController = pageColorViewController
        }
    }

    @IBAction func maMauDidChange(_ sender: UITextField) {
        guard let hexCode = sender.text else {
            return
        }

        let exception: UInt32 = 16_777_216

        let canner = Scanner(string: hexCode)
        var value: UInt32 = exception
        canner.scanHexInt32(&value)

        if value >= exception {
            sender.text = reviewColorView.backgroundColor?.hex
            return
        }

        mainColor = UIColor(hex: Int(value))
        updateUI()
    }

    @IBAction func switchColorSegmeted(_ sender: UISegmentedControl) {
        switchColorView(index: sender.selectedSegmentIndex)
        pageColorViewController?.whichToPage(index: sender.selectedSegmentIndex, updateColor: reviewColorView.backgroundColor ?? mainColor)
    }

    func switchColorView(index: Int) {
        let images = [#imageLiteral(resourceName: "RGB"), #imageLiteral(resourceName: "CMYK"), #imageLiteral(resourceName: "HSV")]
        let imagesBW = [#imageLiteral(resourceName: "RGBB&W"), #imageLiteral(resourceName: "CMYKB&W"), #imageLiteral(resourceName: "HSVB&W")]
        for index in 0...2 {
            colorsSegmented.setImage(imagesBW[index], forSegmentAt: index)
        }
        colorsSegmented.setImage(images[index], forSegmentAt: index)
    }

    func setReviewColor(color: UIColor) {
        reviewColorView.backgroundColor = color
        maMauTextfield.text = color.hex
    }
}

extension HomeViewController: ColorPageViewControllerDelegate {
    func sliderAction(pageViewController: UIPageViewController, color: UIColor) {
        setReviewColor(color: color)
    }
}
