//
//  UIViewController+Extensions.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/23/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChild(viewController: UIViewController, toView childView: UIView, toBack: Bool) {
        addChild(viewController)
        childView.addSubview(viewController.view)
        if toBack {
            childView.sendSubviewToBack(viewController.view)
        }
        viewController.didMove(toParent: self)
    }
}

extension Array {
    subscript(safely index: Int) -> Element? {
        get {
            guard index >= startIndex && index < endIndex else {
                return nil
            }
            return self[index]
        }
    }

    func wrappedIndex(after index: Int) -> Int {
        return index < endIndex - 1
            ? self.index(after: index)
            : startIndex
    }

    func wrappedIndex(before index: Int) -> Int {
        return index > startIndex
            ? self.index(before: index)
            : endIndex - 1
    }

}
