//
//  ExpenseCollectionViewModel.swift
//  Budgeter
//
//  Created by Harry Nelken on 5/5/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import Foundation

final class ExpenseCollectionViewModel {
    private var expenses = [Expense]()

    init() {
        reloadData()
    }

    var numberOfRows: Int {
        return expenses.count
    }

    func reloadData() {
        expenses = currentUser?.expenseArray.reversed() ?? []
    }

    func cellViewModel(for indexPath: IndexPath) -> ExpenseCollectionCellViewModel {
        return ExpenseCollectionCellViewModel(expense: expenses[indexPath.row])
    }
}
