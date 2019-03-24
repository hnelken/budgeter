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
    @IBOutlet weak var expenseCollectionView: UICollectionView!
    @IBOutlet weak var expenseCollectionLayout: UltravisualLayout!
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadData()
        expenseCollectionView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        carouselView.layer.cornerRadius = 12
        carouselView.clipsToBounds = true
    }

    // MARK: - Setup

    private func setup() {
        setupCollectionView()
        setupCarouselView()
        setupNextButton()
    }

    private func setupCollectionView() {
        let cellNib = UINib(nibName: DashboardExpenseCollectionCell.identifier, bundle: nil)
        expenseCollectionView.register(cellNib, forCellWithReuseIdentifier: DashboardExpenseCollectionCell.identifier)
        expenseCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        expenseCollectionView.showsVerticalScrollIndicator = false
    }

    private func setupCarouselView() {
        carouselView.resetToFirstPage()
    }

    private func setupNextButton() {
        // Rotate the button because im too lazy to rotate the asset
        nextButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
    }

    // MARK: - Actions

    @IBAction func addButtonPressed(_ sender: Any) {
        viewModel.addButtonPressed()
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

extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardExpenseCollectionCell.identifier, for: indexPath)

        guard let expenseCell = cell as? DashboardExpenseCollectionCell else { return cell }

        expenseCell.backgroundColor = UIColor.white
        expenseCell.configure(with: viewModel.cellViewModel(for: indexPath))
        return expenseCell
    }
}

extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let layout = expenseCollectionLayout else { return }
        let offset = layout.dragOffset * CGFloat(indexPath.item)
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(
                CGPoint(x: 0, y: offset), animated: true
            )
        }
    }
}
