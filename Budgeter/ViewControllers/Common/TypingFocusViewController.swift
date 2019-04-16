//
//  TextFocusViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 4/15/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

class TypingFocusViewController: UIViewController {

    // MARK: Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("TextFieldFocusViewController must be subclassed")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    }

    deinit {
        removeKeyboardNotifications()
    }

    // MARK: - Focus

    var viewInFocus: UIView? {
        didSet {
            focusIfNeeded(force: true)
        }
    }

    private var keyboardRect: CGRect?
    private var currentViewOffset: CGFloat = 0.0

    private func focusIfNeeded(force: Bool) {
        guard
            let keyboardRect = keyboardRect,
            let viewInFocus = viewInFocus
            else { return }

        let keyboardOriginY = UIScreen.main.bounds.height - keyboardRect.height
        let movementThreshold = viewInFocus.frame.maxY + 8.0
        if (view.frame.origin.y == 0.0 || force) && keyboardOriginY < movementThreshold {
            let offset = movementThreshold - keyboardOriginY
            currentViewOffset = offset
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.frame.origin.y -= offset
            }
        }
    }

    private func endFocusIfNeeded() {
        if view.frame.origin.y != 0.0 {
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.view.frame.origin.y += self?.currentViewOffset ?? 0.0
            }, completion: { [weak self] _ in
                self?.currentViewOffset = 0.0
            })
        }
    }

    // MARK: - Notifications

    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow(_:)),
            name: .UIKeyboardDidShow,
            object: view.window
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: .UIKeyboardWillHide,
            object: view.window
        )
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardDidShow(_ sender: Notification) {
        keyboardRect = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
        focusIfNeeded(force: false)
    }

    @objc private func keyboardWillHide(_ sender: Notification) {
        keyboardRect = nil
        endFocusIfNeeded()
    }
}
