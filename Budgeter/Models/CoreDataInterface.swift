//
//  CoreDataInterface.swift
//  Budgeter
//
//  Created by Harry Nelken on 6/10/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class CoreDataInterface {

    static let shared = CoreDataInterface()

    private init() {}
    private struct Constants {
        static let userEntityName = "BudgetUser"
        static let userEntityPasswordKey = "password"
    }

    var context: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }

    func save() {
        do {
            try context?.save()
        } catch {
            print("Failed saving")
        }
    }

    func getExistingUser() -> BudgetUser? {
        guard let context = context else { return nil }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.userEntityName)
        request.returnsObjectsAsFaults = false
        do {
            guard
                let result = try context.fetch(request) as? [BudgetUser],
                let user = result.first else {
                return nil
            }
            return user
        } catch {
            return nil
        }
    }

    func createNewUser() -> BudgetUser? {
        guard
            let context = context,
            let entity = NSEntityDescription.entity(
                forEntityName: Constants.userEntityName,
                in: context)
            else { return nil }
        let newUser = BudgetUser(entity: entity, insertInto: context)
        newUser.password = ""
        save()
        return newUser
    }
}
