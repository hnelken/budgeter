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

    weak var flowDelegate: HamburgerMenuFlowDelegate?

    var numberOfRows: Int {
        return rows.count
    }

    func cellViewModel(for indexPath: IndexPath) -> HamburgerMenuCellViewModel {
        return rows[indexPath.row].viewModel
    }

    func didSelectRow(at indexPath: IndexPath) {
        flowDelegate?.didSelect(menuItem: rows[indexPath.row])
    }

    private var rows: [HamburgerMenuItem] = [
//        .item1,
//        .item2,
        .logOut
    ]
}

enum HamburgerMenuItem {
    case item1
    case item2
    case logOut

    var viewModel: HamburgerMenuCellViewModel {
        switch self {
        case .item1:
            break
        case .item2:
            break
        case .logOut:
            return HamburgerMenuCellViewModel(title: "Log Out", iconName: "power-off")
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
