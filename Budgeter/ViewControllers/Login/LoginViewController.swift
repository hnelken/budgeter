//
//  LoginViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/18/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit
import LocalAuthentication

final class LoginViewController: UIViewController, LoginViewModelDelegate {

    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var inputField: UITextField!

    private var viewModel = LoginViewModel()

    // MARK: - Life-Cycle

    init() {
        super.init(nibName: "LoginViewController", bundle: Bundle(for: LoginViewController.self))
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }

    // MARK: - Setup

    private func setupButton() {
        enterButton.layer.cornerRadius = enterButton.frame.height / 2
        enterButton.clipsToBounds = true
    }

    // MARK: - Actions

    @IBAction func enterButtonPressed(_ sender: Any) {
        inputField.resignFirstResponder()
        viewModel.authenticate(textFieldContent: inputField.text)
    }

    // MARK: - LoginViewModelDelegate

    func authenticationSuccessful() {
        DispatchQueue.main.async { [weak self] in
            self?.inputField.text = ""
            self?.navigationController?.pushViewController(DashboardViewController(), animated: true)
        }
    }

    func authenticationFailed() {
        DispatchQueue.main.async { [weak self] in
            self?.inputField.becomeFirstResponder()
            self?.presentAlert(
                withTitle: "Authentication failed",
                andMessage: "Sorry!")
        }
    }

    func touchIDNotSupported() {
        DispatchQueue.main.async { [weak self] in
            self?.presentAlert(
                withTitle: "Touch ID not available",
                andMessage: "Your device is not configured for Touch ID.")
        }
    }

    private func presentAlert(withTitle title: String, andMessage message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
