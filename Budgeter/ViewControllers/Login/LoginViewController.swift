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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    // MARK: Setup
    
    private func setupButton() {
        enterButton.layer.cornerRadius = enterButton.frame.height / 2
        enterButton.clipsToBounds = true
    }
    

    @IBAction func enterButtonTapped(_ sender: Any) {
        
    }
}
