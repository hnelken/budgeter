//
//  NewExpenseStepViewModel.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/30/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

protocol ExpenseEditStepViewModel: BasicTextInputViewModel {
    var isLastStep: Bool { get }
}

extension ExpenseEditStepViewModel {

    var headerText: String {
        return "New Expense"
    }

    var defaultInputFieldText: String {
        return ""
    }

    var buttonText: String {
        return isLastStep ? "Done" : "Next"
    }

    var isLastStep: Bool {
        return false
    }
}

final class ExpenseNameStepViewModel: ExpenseEditStepViewModel {
    var buttonAction: ((String?) -> ())?

    let detailText = "Enter a name for the expense"
    let placeHolderText = "Name"
}

final class ExpenseAmountStepViewModel: ExpenseEditStepViewModel {
    var buttonAction: ((String?) -> ())?

    let detailText: String = "How much was the expense?"
    let placeHolderText: String = "0.00"
    let keyboardType: UIKeyboardType = .numberPad
}

final class ExpenseDateStepViewModel: ExpenseEditStepViewModel {
    var buttonAction: ((String?) -> ())?
    let detailText: String = "When was the expense?"
    let placeHolderText: String = "Date"
    let keyboardType: UIKeyboardType = .numbersAndPunctuation
}

final class ExpenseCategoryStepViewModel: ExpenseEditStepViewModel {
    var buttonAction: ((String?) -> ())?
    let detailText: String = "What category is the expense in?"
    let placeHolderText: String = "Category"
}

final class ExpensePaymentMethodStepViewModel: ExpenseEditStepViewModel {
    var buttonAction: ((String?) -> ())?
    let detailText: String = "How did you pay for the expense?"
    let placeHolderText: String = "Payment Method"
}

final class ExpenseCommentStepViewModel: ExpenseEditStepViewModel {
    var buttonAction: ((String?) -> ())?
    let detailText: String = "Any further comments to add?"
    let placeHolderText: String = "Comments"
    let isLastStep: Bool = true
}
