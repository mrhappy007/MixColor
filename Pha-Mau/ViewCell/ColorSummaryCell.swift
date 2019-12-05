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

    @IBOutlet weak var cellView: UIView!
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        let myViewBackgroundColor = cellView.backgroundColor
        super.setSelected(false, animated: false)
        cellView.backgroundColor = myViewBackgroundColor
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }

    @IBAction func switchDidChange(_ sender: UISwitch) {
    cellDelegate?.switchDidChange(colorSummaryCell: self, colorId: colorId, colorSwitchStatus: switchColor.isOn)
    }

    func updateContextSummary(colorModel: ColorModel) {
        let reviewUiColor = UIColor(hex: colorModel.hexCode)
        reviewColor.backgroundColor = reviewUiColor
        reviewColor.tintColor = reviewUiColor
        if reviewUiColor.hsv.saturation < 0.3 {
            reviewColor.layer.borderWidth = 0.5
            reviewColor.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
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

    func updateContextMixColor(colorModel: ColorModel) {
        updateContextSummary(colorModel: colorModel)
        tiLeLabel.isHidden = false
        tiLeValueLabel.isHidden = false
        tiLeValueLabel.text = "\(colorModel.trongSo) %"
    }
}
