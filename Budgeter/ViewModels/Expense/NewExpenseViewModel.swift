//
//  NewExpenseViewModel.swift
//  Budgeter
//
//  Created by Harry Nelken on 11/4/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation
import UIKit

protocol NewExpenseViewModelDelegate: class {
    func updateUIFromViewModel()
    func finishCreatingExpense()
}

private enum NewExpenseEntryState {
    case name
    case amount
    case date
    case category
    case paymentMethod
    case comments
}

final class NewExpenseViewModel: BasicTextInputViewModel {

    weak var delegate: NewExpenseViewModelDelegate?

    private var name = ""
    private var amount = ""
    private var date = ""
    private var category = ""
    private var paymentMethod = ""
    private var comments: String?

    private var currentUser: User
    private var state: NewExpenseEntryState = .name

    init(currentUser: User) {
        self.currentUser = currentUser

        // TODO: Setup data source and UI for options during creation

    }

    // MARK: - View Properties

    var headerText: String {
        return "New Expense"
    }

    var detailText: String {
        switch state {
        case .name:
            return "Enter a name for the expense"
        case .amount:
            return "Enter the amount of the expense"
        case .date:
            return "Enter the date of the expense"
        case .category:
            return "Choose a category for the expense"
        case .paymentMethod:
            return "Choose how you paid for the expense"
        case .comments:
            return "Enter any additional comments"
        }
    }

    var defaultInputFieldText: String {
        return ""
    }

    var placeHolderText: String {
        switch state {
        case .name:
            return "Name"
        case .amount:
            return "Amount"
        case .date:
            return "Date"
        case .category:
            return "Category"
        case .paymentMethod:
            return "Payment Method"
        case .comments:
            return "Comments"
        }
    }

    var buttonText: String {
        switch state {
        case .comments:
            return "Done"
        default:
            return "Next"
        }
    }

    var keyboardType: UIKeyboardType {
        switch state {
        case .amount:
            return .decimalPad
        case .date:
            return .numbersAndPunctuation
        default:
            return .asciiCapable
        }
    }

    // MARK: - Actions

    var buttonAction: ((String?) -> ())? {
        return { [weak self] inputString in
            self?.advanceState(with: inputString)
        }
    }

    private func advanceState(with rawTextInput: String?) {
        let inputString = rawTextInput ?? ""
        switch state {
        case .name:
            name = inputString
            state = .amount
        case .amount:
            amount = inputString
            state = .date
        case .date:
            date = inputString
            state = .category
        case .category:
            category = inputString
            state = .paymentMethod
        case .paymentMethod:
            paymentMethod = inputString
            state = .comments
        case .comments:
            comments = rawTextInput
            createExpense()
        }
        delegate?.updateUIFromViewModel()
    }

    // MARK: - Expense

    private func createExpense() {

        // TODO: Flesh out expense object

        var commentObject: Comment?
        if let commentText = comments {
            commentObject = CoreDataInterface.shared.createComment(text: commentText)
        }

        let _ = CoreDataInterface.shared.createExpense(
            user: currentUser,
            name: name,
            amount: Double(amount) ?? 0.0,
            date: Date(),
            category: nil,
            comment: commentObject
        )

        delegate?.finishCreatingExpense()
    }
}
