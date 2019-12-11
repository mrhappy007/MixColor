//
//  HomeViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 11/16/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class HomeViewController: UIViewController {

    var colorManager = ColorManager.context

    var mainColor = ColorModel()
    var colorIdListMix = [String]()
    var materialColorList = [ColorModel]()

    var setMainColorFlag = false

    @IBOutlet weak var mauCanPhaDefaultView: UIView!

    @IBOutlet weak var mauCanPhaResultView: UIView!

    @IBOutlet weak var colorNameField: UITextField!

    @IBOutlet weak var colorCodeField: UITextField!

    @IBOutlet weak var colorReviewView: UIView!

    @IBOutlet weak var materialColorListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        colorManager.loadContext()

        materialColorListTableView.rowHeight = UITableView.automaticDimension
        let colorCell = UINib(nibName: "ColorSummaryCell", bundle: nil)
        materialColorListTableView.register(colorCell, forCellReuseIdentifier: "ColorSummaryCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        materialColorListTableView.reloadData()

        updateMainColorView()
    }

    @IBAction func addOrEditMainColorPressed(_ sender: UIButton) {
        guard let pickColorView = storyboard?.instantiateViewController(withIdentifier: "PickColorView") as? PickColorViewController else {
            return
        }
        pickColorView.pickColorDelegate = self
        pickColorView.isSetMainColor = true
        pickColorView.mainColor = mainColor
        self.navigationController?.pushViewController(pickColorView, animated: true)
    }

    @IBAction func addMaterialColorPressed(_ sender: UIButton) {
        guard let pickColorView = storyboard?.instantiateViewController(withIdentifier: "PickColorView") as? PickColorViewController else {
            return
        }
        pickColorView.pickColorDelegate = self
        pickColorView.isSetMainColor = false
        pickColorView.mainColor = mainColor
        self.navigationController?.pushViewController(pickColorView, animated: true)
    }

    @IBAction func startMixColorPressed(_ sender: UIButton) {

        if !canMixColor(selectedMainColor: setMainColorFlag, selectedMateralColor: !colorIdListMix.isEmpty) {
            return
        }
        var colorListMix = [ColorModel]()
        let colorListMixtemp = colorManager.colorList.filter({ colorIdListMix.contains($0.idColor) })
        for color in colorListMixtemp {
            colorListMix.append(color.copy() as! ColorModel)
        }

        let mixColor = MixColors(mainColor: mainColor.copy() as! ColorModel, colorListNew: colorListMix)
        guard let weightNums = mixColor.mix() else {
            noResultMixColor()
            return
        }
        for index in 0..<colorListMix.count {
            colorListMix[index].trongSo = weightNums[index]
        }

        guard let mixColorView = (storyboard?.instantiateViewController(withIdentifier: "MixColorView") as? MixColorResultViewController) else {
            return
        }
        mixColorView.mainColor = mainColor
        mixColorView.colorListMix = colorListMix.filter { $0.trongSo > 0 }
        self.navigationController?.pushViewController(mixColorView, animated: true)
    }

    @IBAction func showHistoryMixColorPressed(_ sender: UIButton) {
        guard let historyColorView = (storyboard?.instantiateViewController(withIdentifier: "HistoryColorView") as? HistoryColorViewController) else {
            return
        }
        self.navigationController?.pushViewController(historyColorView, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? PickColorViewController else {
            return
        }
        destination.pickColorDelegate = self
    }

    func updateMainColorView() {
        if setMainColorFlag {
            mauCanPhaDefaultView.isHidden = true
            colorReviewView.backgroundColor = UIColor(hex: mainColor.hexCode)
            colorNameField.text = mainColor.name
            colorCodeField.text = "#.\(mainColor.hexCode)"

            if UIColor(hex: mainColor.hexCode).hsv.saturation < 0.3 {
                colorNameField.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
                colorCodeField.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            } else {
                colorNameField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                colorCodeField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    }

    func reloadMaterialColorTableView() {
        materialColorListTableView.reloadData()
    }

    func showLimitMaterialColorAlert() {
        showAlertDefault(
            title: "Giới hạn màu",
            message: "Ứng dụng chỉ hỗ trợ tính toán tỉ lệ tối đa 5 màu nguyên liệu."
        )
    }

    func canMixColor(selectedMainColor: Bool, selectedMateralColor: Bool) -> Bool {
        var massager = ""
        if !selectedMainColor {
            if !selectedMateralColor {
                massager = "Bạn cần chọn màu cần pha và màu nguyên liệu để tiếp tục"
            } else {
                massager = "Bạn cần chọn màu cần pha để tiếp tục"
            }
        } else {
            if !selectedMateralColor {
                massager = "Bạn cần chọn màu nguyên liệu để tiếp tục"
            } else {
                return true
            }
        }

        showAlertDefault(title: "Chọn màu", message: massager)
        return false
    }

    func showAlertDefault(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func noResultMixColor() {
        let titleNoResult = "No result"
        let messageNoResult = "Không thể pha màu từ những màu đã chọn, bạn hãy thử lại với những màu khác."

        let alert = UIAlertController(title: titleNoResult, message: messageNoResult, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

@available(iOS 13.0, *)
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorManager.colorListSize()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ColorSummaryCell", for: indexPath) as?  ColorSummaryCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }

        let colorModel = colorManager.colorList[indexPath.row]

        if colorIdListMix.contains(colorModel.idColor) {
            cell.updateContextChooseColor(colorModel: colorModel, switchIsOn: true)
        } else {
            cell.updateContextChooseColor(colorModel: colorModel)
        }

        cell.cellDelegate = self

        return cell
    }
}

@available(iOS 13.0, *)
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let colorDetailView = (storyboard?.instantiateViewController(withIdentifier: "ColorDetailView") as? ColorDetailViewController) else {
            return
        }
        colorDetailView.mainColor = colorManager.colorList[indexPath.item]
        self.navigationController?.pushViewController(colorDetailView, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            colorManager.deleteColor(at: indexPath.item)
        }
        materialColorListTableView.reloadData()
    }
}

@available(iOS 13.0, *)
extension HomeViewController: ColorSummaryCellDelegate {
    func switchDidChange(colorSummaryCell: UITableViewCell, colorId: String, colorSwitchStatus: Bool) {
        switch colorSwitchStatus {
        case true:
            if colorIdListMix.count < 5 {
                colorIdListMix.append(colorId)
                break
            }
            guard let colorCell = colorSummaryCell as? ColorSummaryCell else {
                break
            }

            colorCell.setSwitchStatus(isOn: false)
            showLimitMaterialColorAlert()

        case false:
            guard let indexInColorListForMixer = colorIdListMix.firstIndex(where: { $0 == colorId }) else {
                return
            }
            colorIdListMix.remove(at: indexInColorListForMixer)
        }
    }
}

@available(iOS 13.0, *)
extension HomeViewController: PickColorViewDelegate {
    func successfulEditting(isSetMainColor: Bool, maincolor: ColorModel) {
        if isSetMainColor {
            setMainColorFlag = true
            self.mainColor = maincolor
            updateMainColorView()
            return
        }

        colorManager.appentColor(colorModel: maincolor.copy() as! ColorModel)
        reloadMaterialColorTableView()
    }
}
