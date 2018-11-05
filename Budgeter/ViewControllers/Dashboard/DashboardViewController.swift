//
//  DashboardViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/18/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

final class DashboardViewController: UIViewController {
    private var user: User

    init(user: User) {
        self.user = user
        super.init(nibName: "DashboardViewController", bundle: Bundle(for: DashboardViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        let viewModel = NewExpenseViewModel(currentUser: user)
        let viewController = NewExpenseViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
