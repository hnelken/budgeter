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

protocol LoginFlowDelegate: AnyObject {
    func completeAuthentication(for user: User)
}

protocol LoginViewModelDelegate: AnyObject {
    func configureUIForSuccess()
    func configureUIForFailure()
    func touchIDNotSupported()
}

final class LoginViewModel: BasicTextInputViewModel {

    weak var flowDelegate: LoginFlowDelegate?
    weak var delegate: LoginViewModelDelegate?
    private(set) var currentUser: User?
    private(set) var isNewUser = false

    // MARK: - BasicTextInputViewModel

    var headerText: String {
        return "Welcome!"
    }

    var detailText: String {
        return "Enter your password to continue, or leave it blank to use Touch ID, even if its your first time!"
    }

    var placeHolderText: String {
        return "Password"
    }

    var buttonText: String {
        return "Enter"
    }

    var buttonAction: ((String?) -> ())?

    // MARK: - CoreData

    func setupUserFromStorage() {
        checkForExistingUser()
    }

    private func set(newPassword: String?) {
        guard let user = currentUser else { return }
        CoreDataInterface.shared.set(password: newPassword, for: user)
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

    func authenticate(inputString: String?) {
        if let text = inputString, !text.isEmpty {
            authenticateViaPassword(text)
        } else {
            authenticateViaTouchID()
        }
    }

    private func authenticateViaPassword(_ text: String) {
        if isNewUser {
            set(newPassword: text)
            authenticationSuccessful()
        }
        else if text == currentUser?.password {
            authenticationSuccessful()
        } else {
            authenticationFailed()
        }
    }
    
    private func authenticateViaTouchID() {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            delegate?.touchIDNotSupported()
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authorization") { [unowned self] success, _ in
            if success {
                if self.isNewUser {
                    self.set(newPassword: "")
                }
                self.authenticationSuccessful()
            } else {
                self.authenticationFailed()
            }
        }
    }

    private func authenticationSuccessful() {
        isNewUser = false
        delegate?.configureUIForSuccess()
        guard let currentUser = currentUser else { return }
        flowDelegate?.completeAuthentication(for: currentUser)
    }

    private func authenticationFailed() {
        isNewUser = false
        delegate?.configureUIForFailure()
    }
}
