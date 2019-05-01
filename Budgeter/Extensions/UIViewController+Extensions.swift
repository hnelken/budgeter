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
