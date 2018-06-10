//
//  LoginViewModel.swift
//  Budgeter
//
//  Created by Harry Nelken on 6/9/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication
import CoreData

protocol LoginViewModelDelegate: class {
    func authenticationSuccessful()
    func authenticationFailed()
    func touchIDNotSupported()
}

final class LoginViewModel {

    weak var delegate: LoginViewModelDelegate?

    private(set) var isNewUser: Bool = false

    private var currentUser: BudgetUser?

    // MARK: - CoreData

    func setupUserFromStorage() {
        checkForExistingUser()
    }

    private func set(newPassword: String?) {
        currentUser?.password = newPassword
        save(context: Constants.coreDataContext)
    }

    private func checkForExistingUser() {
        guard let context = Constants.coreDataContext else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.userEntityName)
        request.returnsObjectsAsFaults = false
        do {
            guard let result = try context.fetch(request) as? [BudgetUser] else {
                setupNewUser()
                return
            }
            if let user = result.first {
                currentUser = user
            } else {
                setupNewUser()
            }
        } catch {
            setupNewUser()
        }
    }

    private func setupNewUser() {
        guard
            let context = Constants.coreDataContext,
            let entity = NSEntityDescription.entity(
                forEntityName: Constants.userEntityName,
                in: context)
            else { return }
        isNewUser = true
        currentUser = BudgetUser(entity: entity, insertInto: context)
        currentUser?.password = ""
        save(context: context)

    }

    private func save(context: NSManagedObjectContext?) {
        do {
            try context?.save()
        } catch {
            print("Failed saving")
        }
    }

    // MARK: - Authentication

    func authenticate(textFieldContent: String?) {
        if isNewUser {
            set(newPassword: textFieldContent)
        }
        if let text = textFieldContent, !text.isEmpty {
            authenticateViaPassword(text)
        } else {
            authenticateViaTouchID()
        }
    }

    private func authenticateViaPassword(_ text: String) {
        if text == currentUser?.password {
            authenticationSuccessful()
        } else {
            authenticationFailed()
        }
    }
    
    private func authenticateViaTouchID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authorization") { [unowned self] success, _ in
                if success {
                    self.authenticationSuccessful()
                } else {
                    self.authenticationFailed()
                }
            }
        } else {
            delegate?.touchIDNotSupported()
        }
    }

    private func authenticationSuccessful() {
        isNewUser = false
        delegate?.authenticationSuccessful()
    }

    private func authenticationFailed() {
        isNewUser = false
        delegate?.authenticationFailed()
    }
}
