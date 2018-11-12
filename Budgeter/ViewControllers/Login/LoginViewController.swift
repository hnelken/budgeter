//
//  LoginViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 9/25/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

protocol LoginDelegate: class {
    func completeAuthentication(for currentUser: User)
}

final class LoginViewController: BasicTextInputViewController, LoginViewModelDelegate {

    weak var delegate: LoginDelegate?

    private lazy var loginViewModel: LoginViewModel? = {
        return self.viewModel as? LoginViewModel
    }()

    // MARK: - Life-Cycle
    
    init() {
        super.init(viewModel: LoginViewModel())
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

    func authenticationSuccessful() {
        DispatchQueue.main.async { [weak self] in
            guard let currentUser = self?.loginViewModel?.currentUser else {
                return
            }
            self?.inputField.text = ""
            self?.delegate?.completeAuthentication(for: currentUser)
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
