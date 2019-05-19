//
//  MixColorViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 5/11/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class MixColorViewController: UIViewController {

    @IBOutlet weak var reviewColorView: CustomView!
    @IBOutlet weak var colorNameTextField: UITextField!
    @IBOutlet weak var hexCodeTextField: UITextField!
    @IBOutlet weak var mixColorTableView: UITableView!
    @IBOutlet weak var progressCirle: UIActivityIndicatorView!

    let numberElement = 5

    var mainColor = ColorModel()
    var colorListMix = [ColorModel]()
    var trongSo = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateReviewColor()
        progressCirle.startAnimating()
        progressCirle.hidesWhenStopped = true

        mixColorTableView.rowHeight = UITableView.automaticDimension
        let colorCell = UINib(nibName: "ColorSummaryCell", bundle: nil)
        mixColorTableView.register(colorCell, forCellReuseIdentifier: "ColorSummaryCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let mixColor = MixColor(newMainColor: mainColor, newColorList: colorListMix)

        guard let currentTrongSo = mixColor.mixColor() else {
            progressCirle.stopAnimating()
            noResultColorListMix()
            return
        }
        trongSo = currentTrongSo
        mixColorTableView.reloadData()
        progressCirle.stopAnimating()
    }

    func updateReviewColor() {
        reviewColorView.backgroundColor = UIColor(hex: mainColor.hexCode)
        colorNameTextField.text = mainColor.name
        hexCodeTextField.text = mainColor.hexCode
    }

    func noResultColorListMix() {
        let titleNoResult = "No result"
        let messageNoResult = "Không thể pha màu từ những màu đã chọn, bạn hãy thử lại với những màu khác."

        let alert = UIAlertController(title: titleNoResult, message: messageNoResult, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
}

extension MixColorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trongSo.isEmpty ? 0 : colorListMix.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ColorSummaryCell", for: indexPath) as?  ColorSummaryCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell.updateContextMixColor(colorModel: colorListMix[indexPath.item], tiLe: trongSo[indexPath.item])
        return cell
    }
}
