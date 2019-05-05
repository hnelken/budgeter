//
//  DashboardViewModel.swift
//  Budgeter
//
//  Created by Harry Nelken on 12/27/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation
import UIKit

protocol DashboardFlowDelegate: AnyObject {
    func openHamburgerMenu()
    func createNewExpense()
}

final class DashboardViewModel {

    weak var flowDelegate: DashboardFlowDelegate?

    // MARK: - Data Source

    let carouselItems: [DashboardCarouselItem] = [
        .expenseList,
        .green
    ]

    // MARK: - Actions

    func addButtonPressed(at index: Int) {
        guard let item = carouselItems[safely: index] else { return }
        switch item {
        case .expenseList:
            flowDelegate?.createNewExpense()
        case .categoryList:
            break
        case .green:
            break
        }
    }

    func menuButtonPressed() {
        flowDelegate?.openHamburgerMenu()
    }
}

enum DashboardCarouselItem {
    case expenseList
    case categoryList
    case green

    var displayTitle: String {
        switch self {
        case .expenseList:
            return "Expenses"
        case .categoryList:
            return "Categories"
        case .green:
            return "Payment Methods"
        }
    }

    func viewController() -> UIViewController {
        switch self {
        case .expenseList:
            let viewModel = ExpenseCollectionViewModel()
            return ExpenseCollectionViewController(viewModel: viewModel)
        case .categoryList:
            let viewModel = CategoryTableViewModel()
            return BasicTableViewController(viewModel: viewModel)
        case .green:
            let vc = UIViewController()
            vc.view.backgroundColor = .green
            return vc
        }
    }
}
