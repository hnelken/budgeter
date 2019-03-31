//
//  NewExpenseFlowCoordinator.swift
//  Budgeter
//
//  Created by Harry Nelken on 11/11/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation
import UIKit

protocol NewExpenseFlowDelegate: AnyObject {
    func completeExpenseCreation()
}

final class NewExpenseFlowCoordinator {

    enum ExpenseEntryState: Int {
        case name
        case amount
        case date
        case category
        case paymentMethod
        case comment

        var nextState: ExpenseEntryState? {
            return ExpenseEntryState(rawValue: rawValue + 1)
        }
    }

    weak var flowDelegate: NewExpenseFlowDelegate?

    let navigationController = UINavigationController()

    private var state: ExpenseEntryState = .name

    private var expenseName: String = ""
    private var expenseAmount: String = ""
    private var expenseDate: String = ""
    private var expenseCategory: String = ""
    private var expensePaymentMethod: String = ""
    private var expenseComments: String = ""

    func setup() {
        setViewControllerForState()
    }

    private func proceed() {
        if let nextState = state.nextState {
            state = nextState
            setViewControllerForState()
        } else {
            createExpense()
            flowDelegate?.completeExpenseCreation()
        }
    }

    private func setViewControllerForState() {
//        switch state {
//        case .name:
//            let viewController = newTextEntryViewController(for: state)
//            currentStep = viewController
//        case .amount:
//            let viewController = newTextEntryViewController(for: state)
//            currentStep = viewController
//        case .date:
//            let viewController = newTextEntryViewController(for: state)
//            currentStep = viewController
//        case .category:
//            let viewController = newTextEntryViewController(for: state)
//            currentStep = viewController
//        case .paymentMethod:
//            let viewController = newTextEntryViewController(for: state)
//            currentStep = viewController
//        case .comment:
//        }

        let viewController = newTextEntryViewController(for: state)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func handleTextResultFromCurrentStep(_ result: String?) {
        guard let result = result else { return }
        switch state {
        case .name:
            handleNameResult(result)
        case .amount:
            handleAmountResult(result)
        case .date:
            handleDateResult(result)
        case .category:
            handleCategoryResult(result)
        case .paymentMethod:
            handlePaymentMethodResult(result)
        case .comment:
            handleCommentsResult(result)
        }
    }

    private func handleNameResult(_ result: String) {
        expenseName = result
    }

    private func handleAmountResult(_ result: String) {
        expenseAmount = result
    }

    private func handleDateResult(_ result: String) {
        expenseDate = result
    }

    private func handleCategoryResult(_ result: String) {
        expenseCategory = result
    }

    private func handlePaymentMethodResult(_ result: String) {
        expensePaymentMethod = result
    }

    private func handleCommentsResult(_ result: String) {
        expenseComments = result
    }

    private func createExpense() {
        // TODO: Flesh out expense object
        guard let currentUser = currentUser else { return }
        let _ = CoreDataInterface.shared.createExpense(
            user: currentUser,
            name: expenseName,
            amount: Double(expenseAmount) ?? 0.0,
            date: Date(),
            category: nil,
            comment: expenseComments
        )
    }
}

extension NewExpenseFlowCoordinator {
    private func newTextEntryViewController(for state: ExpenseEntryState) -> NewExpenseViewController {
        let viewModel: ExpenseEditStepViewModel
        switch state {
        case .name:
            viewModel = ExpenseNameStepViewModel()
        case .amount:
            viewModel = ExpenseAmountStepViewModel()
        case .date:
            viewModel = ExpenseDateStepViewModel()
        case .category:
            viewModel = ExpenseCategoryStepViewModel()
        case .paymentMethod:
            viewModel = ExpensePaymentMethodStepViewModel()
        case .comment:
            viewModel = ExpenseCommentStepViewModel()
        }
        viewModel.buttonAction = { [weak self] result in
            self?.handleTextResultFromCurrentStep(result)
            self?.proceed()
        }
        return NewExpenseViewController(viewModel: viewModel)
    }

    private func newDateEntryViewController() {
        // TODO: Return date entry

        switch state {
        case .date:
            break
        default:
            break
        }
    }
}
