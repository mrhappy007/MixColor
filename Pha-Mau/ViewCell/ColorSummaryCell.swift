//
//  ColorSummaryTableViewCell.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/20/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

protocol ColorSummaryCellDelegate: class {
    func switchDidChange(colorSummaryCell: UITableViewCell, colorId: String, colorSwitchStatus: Bool)
}

class ColorSummaryCell: UITableViewCell {

    @IBOutlet weak var reviewColor: UIView!
    @IBOutlet weak var colorName: UILabel!
    @IBOutlet weak var colorCode: UILabel!
    @IBOutlet weak var switchColor: UISwitch!
    @IBOutlet weak var tiLeLabel: UILabel!
    @IBOutlet weak var tiLeValueLabel: UILabel!

    weak var cellDelegate: ColorSummaryCellDelegate?
    var colorId = "19000101000000"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func switchDidChange(_ sender: UISwitch) {
    cellDelegate?.switchDidChange(colorSummaryCell: self, colorId: colorId, colorSwitchStatus: switchColor.isOn)
    }

    func updateContextSummary(colorModel: ColorModel) {
        reviewColor.backgroundColor = UIColor(hex: colorModel.hexCode)
        reviewColor.tintColor = UIColor(hex: colorModel.hexCode)
        colorName.text = colorModel.name
        colorCode.text = "#" + colorModel.hexCode
        colorId = colorModel.idColor
    }

    func updateContextChooseColor(colorModel: ColorModel, switchIsOn: Bool = false) {
        updateContextSummary(colorModel: colorModel)
        switchColor.isHidden = false
        switchColor.isOn = switchIsOn
    }

    func setSwitchStatus(isOn: Bool) {
        switchColor.isOn = isOn
    }

    func updateContextMixColor(colorModel: ColorModel, tiLe: Int = 0) {
        updateContextSummary(colorModel: colorModel)
        tiLeLabel.isHidden = false
        tiLeValueLabel.isHidden = false
        tiLeValueLabel.text = "\(tiLe) %"
    }
}
