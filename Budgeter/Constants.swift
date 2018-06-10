//
//  Constants.swift
//  Budgeter
//
//  Created by Harry Nelken on 6/9/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class Constants {

    static let userEntityName = "BudgetUser"
    static let userEntityPasswordKey = "password"
    static var coreDataContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
}
