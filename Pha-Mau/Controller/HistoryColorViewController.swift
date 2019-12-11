//
//  ListColorViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/8/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class HistoryColorViewController: UIViewController {

    @IBOutlet weak var colorListTableView: UITableView!

    var historyColorManage = HistoryColorManager.context

    override func viewDidLoad() {
        super.viewDidLoad()
        historyColorManage.loadContext()

        colorListTableView.rowHeight = UITableView.automaticDimension

        let colorCell = UINib(nibName: "ColorSummaryCell", bundle: nil)
        colorListTableView.register(colorCell, forCellReuseIdentifier: "ColorSummaryCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorListTableView.reloadData()
    }
}

extension HistoryColorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyColorManage.colorListSize()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ColorSummaryCell", for: indexPath) as?  ColorSummaryCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        let colorModel = historyColorManage.mainColor(at: indexPath.row)
        cell.updateContextSummary(colorModel: colorModel)
        return cell
    }
}

extension HistoryColorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mixColorView = (storyboard?.instantiateViewController(withIdentifier: "MixColorView") as? MixColorResultViewController) else {
            return
        }
        mixColorView.mainColor = historyColorManage.mainColor(at: indexPath.row)
        mixColorView.colorListMix = historyColorManage.colorListMix(index: indexPath.row)
        mixColorView.isReviewMixColor = true
        self.navigationController?.pushViewController(mixColorView, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            historyColorManage.deleteColor(at: indexPath.row)
        }
        colorListTableView.reloadData()
    }
}
