//
//  HamburgerMenuTableViewCell.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/10/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

class HamburgerMenuTableViewCell: UITableViewCell {

    static let identifier = "HamburgerMenuTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!

    func configure(with viewModel: HamburgerMenuCellViewModel) {
        titleLabel.text = viewModel.title
        iconView.image = UIImage(named: viewModel.iconName)
    }
}
