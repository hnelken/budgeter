//
//  LoginViewModel.swift
//  Budgeter
//
//  Created by Harry Nelken on 6/9/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import Foundation
import LocalAuthentication

protocol LoginViewModelDelegate: class {
    func authenticationSuccessful()
    func authenticationFailed()
    func touchIDNotSupported()
}

final class LoginViewModel {

    weak var delegate: LoginViewModelDelegate?

    func authenticate(textFieldContent: String?) {
        if let text = textFieldContent, !text.isEmpty {
            authenticateViaPassword(text)
        } else {
            authenticateViaTouchID()
        }
    }

    private func authenticateViaPassword(_ text: String) {
        if text == "1247" {
            delegate?.authenticationSuccessful()
        } else {
            delegate?.authenticationFailed()
        }
    }
    
    private func authenticateViaTouchID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authorization") { [unowned self] success, _ in
                if success {
                    self.delegate?.authenticationSuccessful()
                } else {
                    self.delegate?.authenticationFailed()
                }
            }
        } else {
            delegate?.touchIDNotSupported()
        }
    }
}
