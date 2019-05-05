//
//  CategoryTableViewModel.swift
//  Budgeter
//
//  Created by Harry Nelken on 5/5/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

final class CategoryTableCell: UITableViewCell, BasicTableViewCell {

    static var cellIdentifier: String = String(describing: CategoryTableCell.self)

    func configure(with viewModel: BasicTableViewCellViewModel) {
        textLabel?.text = viewModel.name
    }
}

final class CategoryTableCellViewModel: BasicTableViewCellViewModel {
    var name = "hey"
}

final class CategoryTableViewModel: BasicTableViewModel {
    var numberOfSections: Int = 0
    var cellClass: BasicTableViewCell.Type {
        return CategoryTableCell.self
    }

    func numberOfRows(in section: Int) -> Int {
        return 3
    }

    func cellViewModel(for indexPath: IndexPath) -> BasicTableViewCellViewModel {
        return CategoryTableCellViewModel()
    }
}
