//
//  NewExpenseFlowCoordinator.swift
//  Budgeter
//
//  Created by Harry Nelken on 11/11/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation
import UIKit

private enum ExpenseEntryState {
    case name
    case amount
    case date
    case category
    case paymentMethod
    case comment
}

protocol NewExpenseDelegate: class {
    func completeExpenseCreation()
}

protocol NewExpenseInfoStep {
    var submitAction: ((Any) -> ())? { get }
}

final class NewExpenseFlowCoordinator {

    weak var delegate: NewExpenseDelegate?

    let navigationController = UINavigationController()
    private let currentUser: User

    private var state: ExpenseEntryState = .name

    init(currentUser: User) {
        self.currentUser = currentUser
    }

    func setup() {
        let nameEntryViewController = newTextEntryViewController()
        navigationController.pushViewController(nameEntryViewController, animated: false)
    }

    private func proceed() {
        switch state {
        case .name:
            state = .amount
        case .amount:
            state = .date
        case .date:
            state = .category
        case .category:
            state = .paymentMethod
        case .paymentMethod:
            state = .comment
        case .comment:
            state = .amount
        }
    }
}

extension NewExpenseFlowCoordinator {
    private func newTextEntryViewController() -> NewExpenseViewController {
        let textEntryViewModel = NewExpenseViewModel(currentUser: currentUser)
        let textEntryViewController = NewExpenseViewController(viewModel: textEntryViewModel) { [weak self] result in
            // TODO: Handle return of data from one step here
            self?.delegate?.completeExpenseCreation()
        }
        return textEntryViewController
    }

    private func newDateEntryViewController() {
        // TODO: Return date entry
    }
}
