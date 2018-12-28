//
//  NewExpenseViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 11/4/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

final class NewExpenseViewController: BasicTextInputViewController, NewExpenseViewModelDelegate, NewExpenseInfoStep {

    var submitAction: ((Any) -> ())?

    private lazy var newExpenseViewModel: NewExpenseViewModel? = {
        return self.viewModel as? NewExpenseViewModel
    }()

    init(viewModel: NewExpenseViewModel, submitAction: @escaping ((Any) -> ())) {
        self.submitAction = submitAction
        super.init(viewModel: viewModel)
        newExpenseViewModel?.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func updateUI() {
        updateKeyboardStyle()
        super.updateUI()
    }

    // MARK: - Setup

    private func updateKeyboardStyle() {
        guard let viewModel = newExpenseViewModel else { return }
        inputField.keyboardType = viewModel.keyboardType
    }

    // MARK: - NewExpenseViewModelDelegate

    func updateUIFromViewModel() {
        updateUI()
    }

    func finishCreatingExpense() {
//        navigationController?.popViewController(animated: true)
        submitAction?(self)
    }
}
