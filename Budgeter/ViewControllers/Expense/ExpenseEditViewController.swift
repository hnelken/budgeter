//
//  ExpenseEditViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 4/7/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

class ExpenseEditViewController: TypingFocusViewController {

    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dollarsTextField: UITextField!
    @IBOutlet weak var centsTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var paymentMethodTextField: UITextField!
    @IBOutlet weak var commentsTextField: UITextField!

    // MARK: - Lifecycle
    
    init() {
        super.init(nibName: "ExpenseEditViewController", bundle: Bundle(for: ExpenseEditViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextField.delegate = self
        datePickerHeightConstraint.constant = 0
        view.layoutIfNeeded()
    }

    // MARK: - Actions

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    override func releaseNonTypingFocus() {
        super.releaseNonTypingFocus()
        hideDatePicker(animated: true)
    }

    // MARK: - Date Picker

    private func showDatePicker(animated: Bool) {
        guard datePickerHeightConstraint.constant == 0 else { return }
        setDatePickerHeightConstraint(to: 150.0, animated: animated)
    }

    private func hideDatePicker(animated: Bool) {
        guard datePickerHeightConstraint.constant == 150 else { return }
        setDatePickerHeightConstraint(to: 0.0, animated: animated)
    }

    private func setDatePickerHeightConstraint(
        to constant: CGFloat,
        animated: Bool
    ) {
        datePickerHeightConstraint.constant = constant
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension ExpenseEditViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField == dateTextField else { return true }
        view.endEditing(true)
        showDatePicker(animated: true)
        return false
    }
}
