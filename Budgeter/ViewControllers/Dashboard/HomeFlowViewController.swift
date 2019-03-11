//
//  HomeViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/11/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

class HomeFlowViewController: UIViewController {

    @IBOutlet weak var shadeView: UIView!
    @IBOutlet weak var hamburgerMenuView: UIView!

    private var hamburgerMenu: HamburgerMenuViewController?
    private var dashboard: DashboardViewController?

    private var isMenuShowing: Bool {
        return hamburgerMenuView.transform == .identity
    }

    init() {
        super.init(nibName: "HomeFlowViewController", bundle: Bundle(for: HomeFlowViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    private func setup() {
        setupChildViewControllers()
        setupTapGesture()
    }

    private func setupChildViewControllers() {
        let dashboardViewModel = DashboardViewModel()
        dashboardViewModel.flowDelegate = self
        let dashboardViewController = DashboardViewController(viewModel: dashboardViewModel)
        dashboard = dashboardViewController
        addChild(viewController: dashboardViewController, toView: view, toBack: true)

        let menuViewModel = HamburgerMenuViewModel()
        let menuViewController = HamburgerMenuViewController(viewModel: menuViewModel)
        hamburgerMenu = menuViewController
        addChild(viewController: menuViewController, toView: hamburgerMenuView, toBack: false)
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapToHideHamburgerMenu))
        shadeView.addGestureRecognizer(tapGesture)
    }

    @objc private func didTapToHideHamburgerMenu() {
        if isMenuShowing {
            setHamburgerMenuVisible(false, animated: true)
        }
    }

    private func addChild(viewController: UIViewController, toView childView: UIView, toBack: Bool) {
        addChildViewController(viewController)
        childView.addSubview(viewController.view)
        if toBack {
            childView.sendSubview(toBack: viewController.view)
        }
        viewController.didMove(toParentViewController: self)
    }

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
    func logOut() {

    }

    func openHamburgerMenu() {
        setHamburgerMenuVisible(true, animated: true)
    }

    func createNewExpense() {

    }
}
