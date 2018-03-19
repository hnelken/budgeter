//
//  LoginViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/18/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit
import LocalAuthentication

final class LoginViewController: UIViewController {

    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var inputField: UITextField!
    
    // MARK: View Life-Cycle
    
    init() {
        super.init(nibName: "LoginViewController", bundle: Bundle(for: LoginViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    // MARK: Setup
    
    private func setupButton() {
        enterButton.layer.cornerRadius = enterButton.frame.height / 2
        enterButton.clipsToBounds = true
    }

    // MARK: Actions
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        
        guard
            let text = inputField.text,
            !text.isEmpty
            else {
            authenticateViaTouchID()
            return
        }
        
        if text == "1247" {
            inputField.text = ""
            navigationController?.pushViewController(DashboardViewController(), animated: true)
        }
    }
    // MARK: Touch ID
    
    private func authenticateViaTouchID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.navigationController?.pushViewController(DashboardViewController(), animated: true)
                    } else {
                        self.presentAlert(withTitle: "Authentication failed", andMessage: "Sorry!")
                    }
                }
            }
        } else {
            presentAlert(withTitle: "Touch ID not available", andMessage: "Your device is not configured for Touch ID.")
        }
    }
    
    // MARK: Convenience
    
    private func presentAlert(withTitle title: String, andMessage message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
