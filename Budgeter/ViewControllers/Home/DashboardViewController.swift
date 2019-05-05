//
//  DashboardViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/18/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit

final class DashboardViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var carouselView: CarouselView!
    @IBOutlet weak var previousButton: RoundedButton!
    @IBOutlet weak var nextButton: RoundedButton!

    // MARK: - Properties
    
    private let viewModel: DashboardViewModel

    // MARK: - Init

    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(
            nibName: "DashboardViewController",
            bundle: Bundle(for: DashboardViewController.self)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        carouselView.layer.cornerRadius = 12
        carouselView.clipsToBounds = true
    }

    // MARK: - Setup

    private func setup() {
        setupCarouselView()
        setupNextButton()
    }

    private func setupCarouselView() {
        for item in viewModel.carouselItems {
            let viewController = item.viewController()
            addChild(viewController)
            carouselView.addCarouselView(viewController.view)
            viewController.didMove(toParent: self)
        }
        carouselView.resetToFirstPage()
    }

    private func setupNextButton() {
        // Rotate the button because im too lazy to rotate the asset
        nextButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
    }

    // MARK: - Actions

    @IBAction func addButtonPressed(_ sender: Any) {
        let index = carouselView.currentIndex
        viewModel.addButtonPressed(at: index)
    }

    @IBAction func menuButtonPressed(_ sender: Any) {
        viewModel.menuButtonPressed()
    }

    @IBAction func previousButtonPressed(_ sender: Any) {
        carouselView.previousPage()
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        carouselView.nextPage()
    }

}
