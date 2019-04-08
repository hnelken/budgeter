//
//  ExpenseEditViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 4/7/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

class ExpenseEditViewController: UIViewController {

    // MARK: - Init
    
    init() {
        super.init(nibName: "ExpenseEditViewController", bundle: Bundle(for: ExpenseEditViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
