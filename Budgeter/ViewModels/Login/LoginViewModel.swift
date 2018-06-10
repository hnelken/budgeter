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

    private var currentUser: BudgetUser?
    private(set) var isNewUser: Bool = false

    // MARK: - CoreData

    func setupUserFromStorage() {
        checkForExistingUser()
    }

    private func set(newPassword: String?) {
        currentUser?.password = newPassword
        CoreDataInterface.shared.save()
    }

    private func checkForExistingUser() {
        if let user = CoreDataInterface.shared.getExistingUser() {
            currentUser = user
            isNewUser = false
        } else {
            setupNewUser()
        }
    }

    private func setupNewUser() {
        currentUser = CoreDataInterface.shared.createNewUser()
        isNewUser = true
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
