//
//  LoginViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/18/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, LoginViewModelDelegate {

    @IBOutlet weak var enterButton: RoundedButton!
    @IBOutlet weak var inputField: UITextField!

    private var viewModel = LoginViewModel()

    // MARK: - Life-Cycle

    init() {
        super.init(nibName: viewModel.nibName, bundle: Bundle(for: LoginViewController.self))
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupUserFromStorage()
        registerKeyboardNotifications()
    }

    deinit {
        removeKeyboardNotifications()
    }

    // MARK: - Setup

    private func setupUserFromStorage() {
        viewModel.setupUserFromStorage()
    }

    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow(_:)),
            name: .UIKeyboardDidShow,
            object: view.window
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: .UIKeyboardWillHide,
            object: view.window
        )
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Actions

    @IBAction func enterButtonPressed(_ sender: Any) {
        inputField.resignFirstResponder()
        viewModel.authenticate(textFieldContent: inputField.text)
    }

    @objc private func keyboardDidShow(_ sender: Notification) {
        guard let keyboardRect = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardOriginY = UIScreen.main.bounds.height - keyboardRect.height
        let movementThreshold = enterButton.frame.maxY + 8
        if view.frame.origin.y == 0 && keyboardOriginY < movementThreshold {
            let offset = movementThreshold - keyboardOriginY
            UIView.animate(withDuration: 0.15) { [weak self] in
                self?.view.frame.origin.y -= offset
            }
        }
    }

    @objc private func keyboardWillHide(_ sender: Notification) {
        if view.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.15) { [weak self] in
                self?.view.frame.origin.y = 0
            }
        }
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

    private func presentAlert(withTitle title: String, andMessage message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.inputField.resignFirstResponder()
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
