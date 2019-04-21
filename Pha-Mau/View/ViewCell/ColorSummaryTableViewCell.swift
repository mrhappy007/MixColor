//
//  ColorSummaryTableViewCell.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/20/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class ColorSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewColor: UIView!
    @IBOutlet weak var colorName: UILabel!
    @IBOutlet weak var colorCode: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
