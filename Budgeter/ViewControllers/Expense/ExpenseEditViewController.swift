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

    // MARK: - Init
    
    init() {
        super.init(nibName: "ExpenseEditViewController", bundle: Bundle(for: ExpenseEditViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        [nameTextField,
         dollarsTextField,
         centsTextField,
         dateTextField,
         categoryTextField,
         paymentMethodTextField,
         commentsTextField
        ].forEach {
            $0?.delegate = self
        }
    }

    // MARK: - Actions

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func dateTextFieldTapped(_ sender: Any) {
        if datePickerHeightConstraint.constant == 0.0 {
            datePickerHeightConstraint.constant = 150.0
        } else {
            datePickerHeightConstraint.constant = 0.0
        }
    }
}

extension ExpenseEditViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return textField != dateTextField
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewInFocus = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        viewInFocus = nil
    }
}
