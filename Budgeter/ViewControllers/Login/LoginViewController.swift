//
//  LoginViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 9/25/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

final class LoginViewController: BasicTextInputViewController, LoginViewModelDelegate {

    private lazy var loginViewModel: LoginViewModel? = {
        return self.viewModel as? LoginViewModel
    }()

    // MARK: - Life-Cycle
    
    init() {
        super.init(viewModel: LoginViewModel())
        viewModel.buttonAction = { [weak self] in
            self?.loginViewModel?.authenticate(textFieldContent: self?.inputField.text)
        }
        loginViewModel?.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserFromStorage()
    }

    // MARK: - Setup

    private func setupUserFromStorage() {
        loginViewModel?.setupUserFromStorage()
    }

    // MARK: - LoginViewModelDelegate

    func authenticationSuccessful() {
        DispatchQueue.main.async { [weak self] in
            self?.inputField.text = ""
            self?.navigationController?.pushViewController(DashboardViewController(), animated: true)
        }
    }

    func authenticationFailed() {
        presentAlert(withTitle: "Authentication failed",
                     andMessage: "Sorry!")
    }

    func touchIDNotSupported() {
        presentAlert(withTitle: "Touch ID not available",
                     andMessage: "Your device is not configured for Touch ID.")

    }
}
