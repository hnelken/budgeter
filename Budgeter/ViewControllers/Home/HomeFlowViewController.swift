//
//  HomeViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/11/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

protocol HomeFlowDelegate: AnyObject {
    func logOut()
    func createNewExpense()
}

final class HomeFlowViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var shadeView: UIView!
    @IBOutlet weak var hamburgerMenuView: UIView!

    // MARK: - Properties

    weak var flowDelegate: HomeFlowDelegate?

    private var hamburgerMenu: HamburgerMenuViewController?
    private var dashboard: DashboardViewController?

    private var isMenuShowing: Bool {
        return hamburgerMenuView.transform == .identity
    }

    // MARK: - Init
    
    init() {
        super.init(nibName: "HomeFlowViewController", bundle: Bundle(for: HomeFlowViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hamburgerMenu?.view.frame = hamburgerMenuView.frame
        dashboard?.view.frame = view.frame
        setHamburgerMenuVisible(false, animated: false)
    }

    // MARK: - Setup

    private func setup() {
        setupTapGesture()
        setupChildViewControllers()
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapToHideHamburgerMenu))
        shadeView.addGestureRecognizer(tapGesture)
    }

    private func setupChildViewControllers() {
        setupDashboardViewController()
        setupHamburgerMenuViewController()
    }

    private func setupDashboardViewController() {
        let dashboardViewModel = DashboardViewModel()
        dashboardViewModel.flowDelegate = self
        let dashboardViewController = DashboardViewController(viewModel: dashboardViewModel)
        dashboard = dashboardViewController
        addChild(viewController: dashboardViewController, toView: view, toBack: true)
    }

    private func setupHamburgerMenuViewController() {
        let menuViewModel = HamburgerMenuViewModel()
        menuViewModel.flowDelegate = self
        let menuViewController = HamburgerMenuViewController(viewModel: menuViewModel)
        hamburgerMenu = menuViewController
        addChild(viewController: menuViewController, toView: hamburgerMenuView, toBack: false)
    }

    // MARK: - Actions

    @objc private func didTapToHideHamburgerMenu() {
        if isMenuShowing {
            setHamburgerMenuVisible(false, animated: true)
        }
    }

    // MARK: - Helpers

    private func setHamburgerMenuVisible(_ visible: Bool, animated: Bool) {
        let transform: CGAffineTransform = visible ? .identity : CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0.0)
        let shadeAlpha: CGFloat = visible ? 1.0 : 0.0
        if animated {
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.shadeView.alpha = shadeAlpha
                self?.hamburgerMenuView.transform = transform
            }
        } else {
            shadeView.alpha = shadeAlpha
            hamburgerMenuView.transform = transform
        }
    }
}

extension HomeFlowViewController: DashboardFlowDelegate {
    func openHamburgerMenu() {
        setHamburgerMenuVisible(true, animated: true)
    }

    func createNewExpense() {
        flowDelegate?.createNewExpense()
    }
}

extension HomeFlowViewController: HamburgerMenuFlowDelegate {
    func didSelect(menuItem: HamburgerMenuItem) {
        switch menuItem {
        case .other:
            showOther()
        case .logOut:
            logOut()
        }
    }

    private func showOther() {
        print("other")
    }

    private func logOut() {
        flowDelegate?.logOut()
    }
}
