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
        static let userEntityName = "User"
        static let commentEntityName = "Comment"
        static let expenseEntityName = "Expense"
        static let expenseCategoryEntityName = "ExpenseCategory"
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

    func getExistingUser() -> User? {
        guard let context = context else { return nil }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.userEntityName)
        request.returnsObjectsAsFaults = false
        do {
            guard
                let result = try context.fetch(request) as? [User],
                let user = result.first else {
                return nil
            }
            return user
        } catch {
            return nil
        }
    }

    func createNewUser() -> User? {
        guard let context = context else { return nil }
        let newUser = User(context: context)
        newUser.name = "friend"
        newUser.password = ""
        save()
        return newUser
    }

    func set(password: String?, for user: User) {
        user.password = password
        save()
    }

    func set(name: String, for user: User) {
        user.name = name
        save()
    }

    // MARK: - Expense Category

    func createExpenseCategory(name: String) -> ExpenseCategory? {
        guard let context = context else { return nil }
        let newCategory = ExpenseCategory(context: context)
        newCategory.name = name
        return newCategory
    }

    // MARK: - Comment

    func createComment(text: String) -> Comment? {
        guard let context = context else { return nil }
        let comment = Comment(context: context)
        comment.text = text
        return comment
    }

    // MARK: - Expense

    func createExpense(
        user: User,
        name: String,
        amount: Double,
        date: Date,
        category: ExpenseCategory?,
        comment: Comment?
    ) -> Expense? {
        guard let context = context else { return nil }
        let expense = Expense(context: context)
        expense.user = user
        expense.name = name
        expense.amount = amount
        expense.date = date

        expense.category = category
        category?.addToExpenses(expense)

        expense.comment = comment

        save()
        return expense
    }
}
