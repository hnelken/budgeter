//
//  DashboardExpenseCellViewModel.swift
//  Budgeter
//
//  Created by Harry Nelken on 12/28/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation
import UIKit

final class DashboardExpenseCellViewModel {

    private let expense: Expense

    init(expense: Expense) {
        self.expense = expense
    }

    var nameLabelAttributedText: NSAttributedString? {
        return expense.name?.attributed()
    }

    var amountLabelAttributedText: NSAttributedString {
        return "$\(expense.amount)".attributed()
    }

    var dateLabelAttributedText: NSAttributedString? {
        guard let date = expense.date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        return formatter.string(from: date).attributed()
    }

    var categoryLabelAttributedText: NSAttributedString? {
        return expense.category?.name?.attributed()
    }

    var commentLabelAttributedText: NSAttributedString? {
        return expense.comment?.attributed()
    }
}

private extension String {
    func attributed() -> NSAttributedString {
        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor : UIColor.white,
            .foregroundColor : UIColor.black,
            .strokeWidth : -1.0,
            ]

        return NSAttributedString(string: self, attributes: strokeTextAttributes)
    }
}
