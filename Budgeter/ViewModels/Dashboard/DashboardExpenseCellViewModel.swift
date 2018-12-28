//
//  DashboardExpenseCellViewModel.swift
//  Budgeter
//
//  Created by Harry Nelken on 12/28/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation

final class DashboardExpenseCellViewModel {

    private let expense: Expense

    init(expense: Expense) {
        self.expense = expense
    }

    var nameLabelText: String? {
        return expense.name
    }

    var dateLabelText: String? {
        guard let date = expense.date else { return nil }
        return "\(date)"
    }

    var amountLabelText: String {
        return "\(expense.amount)"
    }

    var categoryLabelText: String? {
        return expense.category?.name
    }

    var commentLabelText: String? {
        return expense.comment
    }
}
