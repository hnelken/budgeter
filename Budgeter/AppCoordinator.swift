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

    let navigationController: UINavigationController

    init() {
        self.navigationController = UINavigationController()
    }

    func setup() {
        let loginViewController = newLoginViewController()
        navigationController.pushViewController(loginViewController, animated: false)
    }

    private func showDashboard(for currentUser: User) {
        let dashboardViewController = newDashboardViewController(for: currentUser)
        navigationController.pushViewController(dashboardViewController, animated: true)
    }
}

// MARK: - View Controller Creation

extension AppFlowCoordinator {
    private func newLoginViewController() -> LoginViewController {
        let viewController = LoginViewController()
        viewController.delegate = self
        return viewController
    }

    private func newDashboardViewController(for user: User) -> DashboardViewController {
        let viewController = DashboardViewController(user: user)
        return viewController
    }
}

// MARK: - Login Delegate

extension AppFlowCoordinator: LoginDelegate {
    func finishedAuthentication(for currentUser: User) {
        showDashboard(for: currentUser)
    }
}
