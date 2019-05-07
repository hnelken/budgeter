//
//  ExpenseEditViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 4/7/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

protocol ExpenseEditFlowDelegate: AnyObject {
    func finishEditingExpense()
}

final class ExpenseEditViewController: TypingFocusViewController {

    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dollarsTextField: UITextField!
    @IBOutlet weak var centsTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var paymentMethodTextField: UITextField!
    @IBOutlet weak var commentsTextField: UITextField!
    @IBOutlet weak var doneButton: RoundedButton!

    weak var flowDelegate: ExpenseEditFlowDelegate?

    // MARK: - Lifecycle

    init() {
        super.init(nibName: "ExpenseEditViewController", bundle: Bundle(for: ExpenseEditViewController.self))
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
        enableDoneButtonIfNeeded()
        setupDelegates()
        setupEditNotifications()
        setupDateEntry()
    }

    private func setupDelegates() {
        nameTextField.delegate = self
        dollarsTextField.delegate = self
        centsTextField.delegate = self
        dateTextField.delegate = self
        categoryTextField.delegate = self
        paymentMethodTextField.delegate = self
        commentsTextField.delegate = self
    }

    private func setupEditNotifications() {
        nameTextField.addTarget(self, action: #selector(textFieldEditChanged), for: .editingChanged)
        dollarsTextField.addTarget(self, action: #selector(textFieldEditChanged), for: .editingChanged)
        centsTextField.addTarget(self, action: #selector(textFieldEditChanged), for: .editingChanged)
        dateTextField.addTarget(self, action: #selector(textFieldEditChanged), for: .editingChanged)
        categoryTextField.addTarget(self, action: #selector(textFieldEditChanged), for: .editingChanged)
        paymentMethodTextField.addTarget(self, action: #selector(textFieldEditChanged), for: .editingChanged)
        commentsTextField.addTarget(self, action: #selector(textFieldEditChanged), for: .editingChanged)
    }

    private func setupDateEntry() {
        datePicker.setDate(Date(), animated: false)
        datePickerHeightConstraint.constant = 0
        view.layoutIfNeeded()
    }

    // MARK: - Expense Properties

    var expenseName: String {
        return nameTextField.text ?? ""
    }

    var expenseAmount: Double {
        let dollarsText = dollarsTextField.text ?? "0"
        let centsText = centsTextField.text ?? "0"
        let amount = Double(dollarsText + "." + centsText) ?? 0.0
        return amount
    }

    var expenseDate: Date {
        return datePicker.date
    }

    var areRequiredFieldsFilled: Bool {
        if nameTextField.text?.isEmpty ?? true {
            return false
        }
        if (dollarsTextField.text?.isEmpty ?? true) &&
            (centsTextField.text?.isEmpty ?? true) {
            return false
        }
        //category?
        //payment method?

        return true
    }

    // MARK: - Actions

    @IBAction func cancelButtonPressed(_ sender: Any) {
        flowDelegate?.finishEditingExpense()
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        // TODO: Flesh out expense object
        guard let currentUser = currentUser else { return }

        let _ = CoreDataInterface.shared.createExpense(
            user: currentUser,
            name: expenseName,
            amount: expenseAmount,
            date: expenseDate,
            category: nil,
            comment: commentsTextField.text
        )
        flowDelegate?.finishEditingExpense()
    }

    @objc func textFieldEditChanged() {
        enableDoneButtonIfNeeded()
    }

    override func releaseNonTypingFocus() {
        super.releaseNonTypingFocus()
        hideDatePicker(animated: true)
        enableDoneButtonIfNeeded()
    }

    // MARK: - Date Picker

    private var isDatePickerShowing: Bool {
        return datePickerHeightConstraint.constant != 0
    }

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

    // MARK: - Done Button

    private func enableDoneButtonIfNeeded() {
        doneButton.isHidden = !areRequiredFieldsFilled
    }
}

extension ExpenseEditViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        enableDoneButtonIfNeeded()
        guard textField == dateTextField else { return true }

        if isDatePickerShowing {
            hideDatePicker(animated: true)
        } else {
            view.endEditing(true)
            showDatePicker(animated: true)
        }
        return false
    }
}
