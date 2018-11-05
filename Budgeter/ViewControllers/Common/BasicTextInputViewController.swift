//
//  LoginViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/18/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

protocol BasicTextInputViewModel: class {
    var headerText: String { get }
    var detailText: String { get }
    var defaultInputFieldText: String { get }
    var placeHolderText: String { get }
    var buttonText: String { get }
    var buttonAction: ((String?) -> ())? { get }
}

class BasicTextInputViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var button: RoundedButton!

    private let basicNibName = "BasicTextInputViewController"

    var viewModel: BasicTextInputViewModel

    // MARK: - Life-Cycle

    init(viewModel: BasicTextInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: basicNibName, bundle: Bundle(for: BasicTextInputViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        registerKeyboardNotifications()
        setupFromViewModel()
    }

    deinit {
        removeKeyboardNotifications()
    }

    // MARK: - Setup

    func updateUI() {
        headerLabel.text = viewModel.headerText
        detailLabel.text = viewModel.detailText
        inputField.text = viewModel.defaultInputFieldText
        inputField.placeholder = viewModel.placeHolderText
        button.setTitle(viewModel.buttonText, for: .normal)
    }

    private func setupFromViewModel() {
        updateUI()
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

    @IBAction private func enterButtonPressed(_ sender: Any) {
        inputField.resignFirstResponder()
        viewModel.buttonAction?(inputField.text)
    }

    @objc private func keyboardDidShow(_ sender: Notification) {
        guard let keyboardRect = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardOriginY = UIScreen.main.bounds.height - keyboardRect.height
        let movementThreshold = button.frame.maxY + 8
        if view.frame.origin.y == 0 && keyboardOriginY < movementThreshold {
            let offset = movementThreshold - keyboardOriginY
            UIView.animate(withDuration: 0.3) { [weak self] in
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

    func presentAlert(withTitle title: String, andMessage message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.inputField.resignFirstResponder()
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
