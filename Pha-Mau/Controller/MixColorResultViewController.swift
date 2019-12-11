//
//  MixColorViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 5/11/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class MixColorResultViewController: UIViewController {

    @IBOutlet weak var reviewColorView: UIView!
    @IBOutlet weak var colorNameTextField: UITextField!
    @IBOutlet weak var hexCodeTextField: UITextField!
    @IBOutlet weak var mixColorTableView: UITableView!

    @IBAction func pressedDoneButton(_ sender: UIButton) {
        if isReviewMixColor {
            navigationController?.popViewController(animated: true)
            return
        }
        historyColorManager.appentColor(mainColor: mainColor.copy() as! ColorModel, colorListMix: colorListMix)
        navigationController?.popToRootViewController(animated: true)
    }

    var historyColorManager = HistoryColorManager.context

    var mainColor = ColorModel()
    var colorListMix = [ColorModel]()
    var isReviewMixColor = false

    override func viewDidLoad() {
        super.viewDidLoad()
        updateReviewColor()

        mixColorTableView.rowHeight = UITableView.automaticDimension
        let colorCell = UINib(nibName: "ColorSummaryCell", bundle: nil)
        mixColorTableView.register(colorCell, forCellReuseIdentifier: "ColorSummaryCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func updateReviewColor() {
        reviewColorView.backgroundColor = UIColor(hex: mainColor.hexCode)
        colorNameTextField.text = mainColor.name
        hexCodeTextField.text = mainColor.hexCode
    }
}

extension MixColorResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorListMix.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ColorSummaryCell", for: indexPath) as?  ColorSummaryCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell.updateContextMixColor(colorModel: colorListMix[indexPath.item])
        return cell
    }
}

extension MixColorResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let colorDetailView = (storyboard?.instantiateViewController(withIdentifier: "ColorDetailView") as? ColorDetailViewController) else {
            return
        }
        colorDetailView.mainColor = colorListMix[indexPath.item]
        self.navigationController?.pushViewController(colorDetailView, animated: true)
    }
}
