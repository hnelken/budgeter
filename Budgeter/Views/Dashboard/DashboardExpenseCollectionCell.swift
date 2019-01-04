//
//  DashboardExpenseCollectionCell.swift
//  Budgeter
//
//  Created by Harry Nelken on 1/4/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

class DashboardExpenseCollectionCell: UICollectionViewCell {

    static let identifier = "DashboardExpenseCollectionCell"

    @IBOutlet weak var nameLabel: UILabel!

    func configure(for viewModel: DashboardExpenseCellViewModel) {
        nameLabel.text = viewModel.nameLabelText
    }
}
