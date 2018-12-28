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
    private var newExpenseFlow: NewExpenseFlowCoordinator?
    private(set) var currentSessionUser: User?

    private func setup() {
        let loginViewController = newLoginViewController()
        navigationController.pushViewController(loginViewController, animated: false)
    }

    private func showDashboard() {
        let dashboardViewController = newDashboardViewController()
        navigationController.pushViewController(dashboardViewController, animated: true)
    }

    private func showNewExpenseFlow() {
        let newExpenseFlow = newExpenseFlowCoordinator()
        navigationController.present(newExpenseFlow.navigationController, animated: true)
        self.newExpenseFlow = newExpenseFlow
    }
}

// MARK: - Flow / View Controller Creation

extension AppFlowCoordinator {
    private func newLoginViewController() -> LoginViewController {
        let viewModel = LoginViewModel()
        viewModel.flowDelegate = self
        let viewController = LoginViewController(viewModel: viewModel)
        return viewController
    }

    private func newDashboardViewController() -> DashboardViewController {
        let viewModel = DashboardViewModel()
        viewModel.flowDelegate = self
        let viewController = DashboardViewController(viewModel: viewModel)
        return viewController
    }

    private func newExpenseFlowCoordinator() -> NewExpenseFlowCoordinator {
        let newExpenseFlow = NewExpenseFlowCoordinator()
        newExpenseFlow.flowDelegate = self
        newExpenseFlow.setup()
        return newExpenseFlow
    }
}

// MARK: - Login Delegate

extension AppFlowCoordinator: LoginFlowDelegate {
    func completeAuthentication(for user: User) {
        currentSessionUser = user
        showDashboard()
    }
}

extension AppFlowCoordinator: DashboardFlowDelegate {
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
        newExpenseFlow = nil
    }
}
