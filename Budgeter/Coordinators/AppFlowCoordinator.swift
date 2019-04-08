//
//  AppFlowCoordinator.swift
//  Budgeter
//
//  Created by Harry Nelken on 11/11/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation
import UIKit

var currentUser: User? {
    return AppFlowCoordinator.shared.currentSessionUser
}

final class AppFlowCoordinator {

    static let shared = AppFlowCoordinator()
    private init() { setup() }
    
    let navigationController = UINavigationController()
    private var modalNewExpenseFlow: ExpenseEditViewController?
    private(set) var currentSessionUser: User?

    private func setup() {
        let loginViewController = newLoginViewController()
        navigationController.pushViewController(loginViewController, animated: false)
    }

    private func showHomeFlow() {
        let homeFlow = newHomeFlowViewController()
        navigationController.pushViewController(homeFlow, animated: true)
    }

    private func showNewExpenseFlow() {
        let expenseEdit = ExpenseEditViewController()
        navigationController.pushViewController(expenseEdit, animated: true)
//        let newExpenseFlow = newExpenseFlowCoordinator()
//        navigationController.present(newExpenseFlow.navigationController, animated: true)
        self.modalNewExpenseFlow = expenseEdit//newExpenseFlow
    }
}

// MARK: - Flow / View Controller Creation

extension AppFlowCoordinator {
    private func newLoginViewController() -> LoginViewController {
        let viewModel = LoginViewModel()
        viewModel.buttonAction = { [weak viewModel] inputString in
            viewModel?.authenticate(inputString: inputString)
        }
        viewModel.flowDelegate = self
        let viewController = LoginViewController(viewModel: viewModel)
        return viewController
    }

    private func newHomeFlowViewController() -> HomeFlowViewController {
        let homeFlow = HomeFlowViewController()
        homeFlow.flowDelegate = self
        return homeFlow
    }

    private func newExpenseFlowCoordinator() -> NewExpenseFlowCoordinator {
        let newExpenseFlow = NewExpenseFlowCoordinator()
        newExpenseFlow.flowDelegate = self
        newExpenseFlow.setup()
        return newExpenseFlow
    }
}

extension AppFlowCoordinator: LoginFlowDelegate {
    func completeAuthentication(for user: User) {
        currentSessionUser = user
        showHomeFlow()
    }
}

extension AppFlowCoordinator: HomeFlowDelegate {
    func logOut() {
        currentSessionUser = nil
        navigationController.popViewController(animated: true)
    }
    
    func createNewExpense() {
        showNewExpenseFlow()
    }
}

extension AppFlowCoordinator: NewExpenseFlowDelegate {
    func completeExpenseCreation() {
        navigationController.dismiss(animated: true)
        modalNewExpenseFlow = nil
    }
}
