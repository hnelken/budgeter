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
        static let sliceEntityName = "BudgetSlice"
        static let transactionEntityName = "BudgetTransaction"
    }

    // MARK: - General

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

    // MARK: - User

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

    func addSlice(_ slice: BudgetSlice) {
        guard let user = getExistingUser() else { return }
        user.addToSlices(slice)
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
        if let slice = createSlice(named: "Other", decimal: 0.0, asPercent: true) {
            newUser.addToSlices(slice)
        }
        save()
        return newUser
    }

    // MARK: - Slice

    func createSlice(named: String, decimal: Double, asPercent: Bool) -> BudgetSlice? {
        guard
            let context = context,
            let entity = NSEntityDescription.entity(
                forEntityName: Constants.sliceEntityName,
                in: context)
            else { return nil }
        let newSlice = BudgetSlice(entity: entity, insertInto: context)
        newSlice.name = named
        newSlice.decimal = decimal
        newSlice.isPercent = asPercent
        save()
        return newSlice
    }

    // MARK: - Transaction

    func createTransaction(named: String, amount: Double, slice: BudgetSlice?, date: Date) -> BudgetTransaction? {
        guard
            let context = context,
            let entity = NSEntityDescription.entity(
                forEntityName: Constants.transactionEntityName,
                in: context)
            else { return nil }
        let newTransaction = BudgetTransaction(entity: entity, insertInto: context)
        newTransaction.name = named
        newTransaction.amount = amount
        newTransaction.date = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
        newTransaction.slice = slice
        save()
        return newTransaction
    }
}
