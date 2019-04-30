//
//  TextFocusViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 4/15/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

class TypingFocusViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView?

    // MARK: Life Cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("TextFieldFocusViewController must be subclassed")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    deinit {
        removeKeyboardNotifications()
    }

    // MARK: - Setup

    private func setup() {
        registerKeyboardNotifications()
        scrollView?.keyboardDismissMode = .interactive
        setupTapGesture()
    }

    private func setupTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        scrollView?.addGestureRecognizer(gesture)
    }

    // MARK: - Actions

    @objc private func didTap() {
        view.endEditing(true)
        releaseNonTypingFocus()
    }

    func releaseNonTypingFocus() { /* override */ }

    // MARK: - Focus

    // Keyboard hiding approach adapted from:
    /*
     https://github.com/mattneub/Programming-iOS-Book-Examples/blob/swift4ios11/bk2ch10p522textFieldScrollView/ch23p805textFieldSliding/ViewController.swift
    */

    private var lastContentInset = UIEdgeInsets.zero
    private var lastIndicatorInset = UIEdgeInsets.zero
    private var lastOffset = CGPoint.zero
    private var keyboardRect: CGRect?

    private func focusIfNeeded(force: Bool) {
        guard
            let scrollView = scrollView,
            var keyboardRect = keyboardRect
            else { return }

        lastContentInset = scrollView.contentInset
        lastIndicatorInset = scrollView.scrollIndicatorInsets
        lastOffset = scrollView.contentOffset

        // Convert keyboard into scroll view coordinates
        keyboardRect = scrollView.convert(keyboardRect, from: nil)

        let padding: CGFloat = 16.0
        let inset = keyboardRect.height + padding
        scrollView.contentInset.bottom = inset
        scrollView.scrollIndicatorInsets.bottom = inset
    }

    private func endFocusIfNeeded() {
        guard keyboardRect == nil else { return }
        scrollView?.contentOffset = lastOffset
        scrollView?.contentInset = lastContentInset
        scrollView?.scrollIndicatorInsets = lastIndicatorInset
    }

    // MARK: - Notifications

    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: .UIKeyboardWillShow,
            object: view.window
        )
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

    @objc private func keyboardWillShow(_ sender: Notification) {
        releaseNonTypingFocus()
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
