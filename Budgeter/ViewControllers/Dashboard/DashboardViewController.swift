//
//  DashboardViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/18/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit


final class DashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var expenseCollectionView: UICollectionView!

    private let viewModel: DashboardViewModel

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadData()
        print(viewModel.numberOfRows)
        expenseCollectionView.reloadData()
    }

    // MARK: - Setup

    private func setup() {
        let collectionCellNib = UINib(nibName: DashboardExpenseCollectionCell.identifier, bundle: nil)
        expenseCollectionView.register(collectionCellNib, forCellWithReuseIdentifier: DashboardExpenseCollectionCell.identifier)
    }

    // MARK: - Actions

    @IBAction func addButtonPressed(_ sender: Any) {
        viewModel.addButtonPressed()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        viewModel.backButtonPressed()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardExpenseCollectionCell.identifier, for: indexPath)

        guard let expenseCell = cell as? DashboardExpenseCollectionCell else { return cell }

        if indexPath.row % 2 == 0 {
            expenseCell.backgroundColor = UIColor.gray
        } else {
            expenseCell.backgroundColor = UIColor.lightGray
        }
        expenseCell.configure(for: viewModel.cellViewModel(for: indexPath))
        return expenseCell
    }
}
