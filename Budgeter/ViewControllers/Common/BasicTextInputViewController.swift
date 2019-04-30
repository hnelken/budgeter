//
//  LoginViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/18/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

protocol BasicTextInputViewModel: AnyObject {
    var headerText: String { get }
    var detailText: String { get }

    var keyboardType: UIKeyboardType { get }
    var defaultInputFieldText: String { get }
    var placeHolderText: String { get }

    var buttonText: String { get }
    var buttonAction: ((String?) -> ())? { get set }
}

extension BasicTextInputViewModel {
    var keyboardType: UIKeyboardType {
        return .asciiCapable
    }

    var defaultInputFieldText: String {
        return ""
    }
}

class BasicTextInputViewController: TypingFocusViewController {

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
//        viewInFocus = button
        setupFromViewModel()
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

    // MARK: - Actions

    @IBAction private func enterButtonPressed(_ sender: Any) {
        view.endEditing(true)
        viewModel.buttonAction?(inputField.text)
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
