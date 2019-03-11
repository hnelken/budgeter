//
//  HamburgerMenuViewModel.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/10/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import Foundation

protocol HamburgerMenuFlowDelegate: AnyObject {
    func didSelect(menuItem: HamburgerMenuItem)
}

final class HamburgerMenuViewModel {

    var numberOfRows: Int {
        return rows.count
    }

    func cellViewModel(for indexPath: IndexPath) -> HamburgerMenuCellViewModel {
        return rows[indexPath.row].viewModel
    }

    func didSelectRow(at indexPath: IndexPath) {
        
    }

    private var rows: [HamburgerMenuItem] = [
        .item1,
        .item2,
        .item3
    ]
}

enum HamburgerMenuItem {
    case item1
    case item2
    case item3

    var viewModel: HamburgerMenuCellViewModel {
        switch self {
        case .item1:
            break
        case .item2:
            break
        case .item3:
            break
        }

        return HamburgerMenuCellViewModel(
            title: "ItemTitle",
            iconName: "imageName"
        )
    }
}

struct HamburgerMenuCellViewModel {
    var title: String
    var iconName: String
}
