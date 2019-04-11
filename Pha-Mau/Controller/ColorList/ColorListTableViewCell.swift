//
//  ListColorTableViewCell.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/8/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class ColorListTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewColorView: UIView!
    @IBOutlet weak var colorName: UILabel!
    @IBOutlet weak var colorCode: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
