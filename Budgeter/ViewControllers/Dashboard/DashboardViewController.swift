//
//  DashboardViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/18/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

protocol DashboardDelegate: class {
    func logOut()
    func createNewExpense()
}

final class DashboardViewController: UIViewController {

    weak var delegate: DashboardDelegate?

    private var user: User

    init(user: User) {
        self.user = user
        super.init(nibName: "DashboardViewController", bundle: Bundle(for: DashboardViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func addButtonPressed(_ sender: Any) {
//        let viewModel = NewExpenseViewModel(currentUser: user)
//        let viewController = NewExpenseViewController(viewModel: viewModel)
//        navigationController?.pushViewController(viewController, animated: true)
        delegate?.createNewExpense()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        delegate?.logOut()
//        navigationController?.popViewController(animated: true)
    }
}
