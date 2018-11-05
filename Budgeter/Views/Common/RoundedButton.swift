//
//  RoundedButton.swift
//  Budgeter
//
//  Created by Harry Nelken on 9/23/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
}
