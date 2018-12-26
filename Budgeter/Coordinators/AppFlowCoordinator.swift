//
//  AppCoordinator.swift
//  Budgeter
//
//  Created by Harry Nelken on 11/11/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation
import UIKit

final class AppFlowCoordinator {

    let navigationController = UINavigationController()
    private var newExpenseFlow: NewExpenseFlowCoordinator?
    private var currentUser: User?

    func setup() {
        let loginViewController = newLoginViewController()
        navigationController.pushViewController(loginViewController, animated: false)
    }

    private func showDashboard(for currentUser: User) {
        self.currentUser = currentUser
        let dashboardViewController = newDashboardViewController(for: currentUser)
        navigationController.pushViewController(dashboardViewController, animated: true)
    }

    private func showNewExpenseFlow() {
        guard let currentUser = currentUser else { return }
        let newExpenseFlow = newExpenseFlowCoordinator(for: currentUser)
        navigationController.present(newExpenseFlow.navigationController, animated: true)
        self.newExpenseFlow = newExpenseFlow
    }
}

// MARK: - Flow / View Controller Creation

extension AppFlowCoordinator {
    private func newLoginViewController() -> LoginViewController {
        let viewController = LoginViewController(flowDelegate: self)
        return viewController
    }

    private func newDashboardViewController(for user: User) -> DashboardViewController {
        let viewController = DashboardViewController(user: user)
        viewController.delegate = self
        return viewController
    }

    private func newExpenseFlowCoordinator(for user: User) -> NewExpenseFlowCoordinator {
        let newExpenseFlow = NewExpenseFlowCoordinator(currentUser: user)
        newExpenseFlow.setup()
        newExpenseFlow.flowDelegate = self
        return newExpenseFlow
    }
}

// MARK: - Login Delegate

extension AppFlowCoordinator: LoginFlowDelegate {
    func completeAuthentication(for currentUser: User) {
        showDashboard(for: currentUser)
    }
}

extension AppFlowCoordinator: DashboardFlowDelegate {
    func logOut() {
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
