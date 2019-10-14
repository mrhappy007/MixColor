//
//  ChooseColorsViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 5/3/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class ChooseColorsViewController: UIViewController {

    @IBOutlet weak var chooseColorsTableView: UITableView!
    @IBOutlet weak var countSelectedColors: UILabel!

    var mainColor = ColorModel()
    var colorListForMixer = [ColorModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 0...4 {
            colorListForMixer.append(ColorManager.context.colorList[index])
        }

        chooseColorsTableView.rowHeight = UITableView.automaticDimension

        let colorCell = UINib(nibName: "ColorSummaryCell", bundle: nil)
        chooseColorsTableView.register(colorCell, forCellReuseIdentifier: "ColorSummaryCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chooseColorsTableView.reloadData()
        countSelectedColors.text = String(colorListForMixer.count)
    }

    @IBAction func mixColorSelected(_ sender: UIBarButtonItem) {
        guard let mixColorView = (storyboard?.instantiateViewController(withIdentifier: "MixColorView") as? MixColorViewController) else {
            return
        }
        mixColorView.mainColor = mainColor
        mixColorView.colorListMix = colorListForMixer
        self.navigationController?.pushViewController(mixColorView, animated: true)
    }
}

extension ChooseColorsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ColorManager.context.colorList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ColorSummaryCell", for: indexPath) as?  ColorSummaryCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }

        let colorModel = ColorManager.context.colorList[indexPath.row]

        if colorListForMixer.contains(colorModel) {
            cell.updateContextChooseColor(colorModel: colorModel, switchIsOn: true)
        } else {
            cell.updateContextChooseColor(colorModel: colorModel)
        }

        cell.cellDelegate = self

        return cell
    }
}

extension ChooseColorsViewController: ColorSummaryCellDelegate {
    func switchDidChange(colorSummaryCell: UITableViewCell, colorId: String, colorSwitchStatus: Bool) {
        let colorList = ColorManager.context.colorList
        guard let indexInColorList = colorList.firstIndex(where: { $0.idColor == colorId }) else {
            return
        }
        switch colorSwitchStatus {
        case true:
            if colorListForMixer.count < 5 {
                colorListForMixer.append(colorList[indexInColorList])
                countSelectedColors.text = String(colorListForMixer.count)
                break
            }
            guard let colorCell = colorSummaryCell as? ColorSummaryCell else {
                break
            }
            colorCell.setSwitchStatus(isOn: false)

        case false:
            guard let indexInColorListForMixer = colorListForMixer.firstIndex(where: { $0.idColor == colorId }) else {
                return
            }
            colorListForMixer.remove(at: indexInColorListForMixer)
            countSelectedColors.text = String(colorListForMixer.count)
        }
    }
}
