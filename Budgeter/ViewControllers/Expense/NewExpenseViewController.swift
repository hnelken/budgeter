//
//  NewExpenseViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 11/4/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

final class NewExpenseViewController: BasicTextInputViewController {

    private lazy var newExpenseViewModel: ExpenseEditStepViewModel? = {
        return self.viewModel as? ExpenseEditStepViewModel
    }()

    override func updateUI() {
        updateKeyboardStyle()
        super.updateUI()
    }

    private func updateKeyboardStyle() {
        guard let viewModel = newExpenseViewModel else { return }
        inputField.keyboardType = viewModel.keyboardType
    }
}
