//
//  ListColorViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/8/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class ColorListViewController: UIViewController {

    @IBOutlet weak var colorListTableView: UITableView!

    var collorManager = ColorManager.context

    override func viewDidLoad() {
        super.viewDidLoad()

        colorListTableView.rowHeight = UITableView.automaticDimension
        let colorCell = UINib(nibName: "ColorSummaryCell", bundle: nil)
        colorListTableView.register(colorCell, forCellReuseIdentifier: "ColorSummaryCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorListTableView.reloadData()
    }
}

extension ColorListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collorManager.colorList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ColorSummaryCell", for: indexPath) as?  ColorSummaryCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        let colorModel = collorManager.colorList[indexPath.item]
        cell.updateContextSummary(colorModel: colorModel)
        return cell
    }
}

extension ColorListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let colorDetailView = (storyboard?.instantiateViewController(withIdentifier: "ColorDetailView") as? ColorDetailViewController) else {
            return
        }
        colorDetailView.colorIndex = indexPath.item
        self.navigationController?.pushViewController(colorDetailView, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ColorManager.context.deleteColor(at: indexPath.item)
        }
        colorListTableView.reloadData()
    }
}
