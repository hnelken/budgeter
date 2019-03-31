//
//  NewExpenseViewModel.swift
//  Budgeter
//
//  Created by Harry Nelken on 11/4/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation
import UIKit

protocol NewExpenseViewModelDelegate: AnyObject {
    func updateUIFromViewModel()
    func finishCreatingExpense()
}

private enum NewExpenseEntryState {
    case name
    case amount
    case date
    case category
    case paymentMethod
    case comment
}

final class NewExpenseViewModel {

    weak var delegate: NewExpenseViewModelDelegate?

    private var name = ""
    private var amount = ""
    private var date = ""
    private var category = ""
    private var paymentMethod = ""
    private var comment: String?

    private var state: NewExpenseEntryState = .name

    init() {

        // TODO: Setup data source and UI for options during creation
        
    }

    var buttonAction: ((String?) -> ())? {
        return { [weak self] inputString in
            self?.advanceState(with: inputString)
        }
    }

    private func advanceState(with rawTextInput: String?) {
        let inputString = rawTextInput ?? ""
        switch state {
        case .name:
            name = inputString
            state = .amount
        case .amount:
            amount = inputString
            state = .date
        case .date:
            date = inputString
            state = .category
        case .category:
            category = inputString
            state = .paymentMethod
        case .paymentMethod:
            paymentMethod = inputString
            state = .comment
        case .comment:
            comment = rawTextInput
//            createExpense()
        }
        delegate?.updateUIFromViewModel()
    }


}
