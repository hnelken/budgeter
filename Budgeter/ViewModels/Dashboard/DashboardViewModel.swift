//
//  DashboardViewModel.swift
//  Budgeter
//
//  Created by Harry Nelken on 12/27/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation

protocol DashboardFlowDelegate: class {
    func logOut()
    func createNewExpense()
}

final class DashboardViewModel {

    weak var flowDelegate: DashboardFlowDelegate?

    private var expenses: [Expense]

    init() {
        expenses = currentUser?.expenseArray ?? []
    }

    // MARK: - Data Source

    var numberOfRows: Int {
        return 10//expenses.count
    }

    // MARK: - Actions

    func addButtonPressed() {
        flowDelegate?.createNewExpense()
    }

    func backButtonPressed() {
        flowDelegate?.logOut()
    }
}
