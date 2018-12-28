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
    
    init(viewModel: LoginViewModel) {
        super.init(viewModel: viewModel)
        loginViewModel?.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        setupKeyboard()
        setupUserFromStorage()
    }

    private func setupKeyboard() {
        inputField.isSecureTextEntry = true
        inputField.keyboardType = .numberPad
    }

    private func setupUserFromStorage() {
        loginViewModel?.setupUserFromStorage()
    }

    // MARK: - LoginViewModelDelegate

    func configureUIForSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.inputField.text = ""
        }
    }

    func configureUIForFailure() {
        presentAlert(withTitle: "Authentication failed",
                     andMessage: "Sorry!")
    }

    func touchIDNotSupported() {
        presentAlert(withTitle: "Touch ID not available",
                     andMessage: "Your device is not configured for Touch ID.")

    }
}
