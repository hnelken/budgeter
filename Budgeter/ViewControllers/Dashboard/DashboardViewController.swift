//
//  DashboardViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/18/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

final class DashboardViewController: UIViewController {
    
    init() {
        super.init(nibName: "DashboardViewController", bundle: Bundle(for: DashboardViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
