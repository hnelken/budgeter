//
//  DashboardExpenseCell.swift
//  Budgeter
//
//  Created by Harry Nelken on 12/27/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

class DashboardExpenseCell: UITableViewCell {

    static let identifier = "DashboardExpenseCell"
    
    @IBOutlet weak var nameLabel: UILabel!

    func configure(for viewModel: DashboardExpenseCellViewModel) {
        nameLabel.text = viewModel.nameLabelText
    }
}
