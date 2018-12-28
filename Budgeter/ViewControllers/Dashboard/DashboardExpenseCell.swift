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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
