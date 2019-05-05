//
//  ExpenseCollectionViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 5/5/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

final class ExpenseCollectionViewController: UICollectionViewController {

    private let viewModel: ExpenseCollectionViewModel

    init(viewModel: ExpenseCollectionViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UltravisualLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        self.viewModel = ExpenseCollectionViewModel()
        super.init(collectionViewLayout: UltravisualLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        registerCellClass()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadData()
        collectionView.reloadData()
    }

    func setupCollectionView() {
        collectionView.decelerationRate = .fast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .groupTableViewBackground
    }

    private func registerCellClass() {
        let cellNib = UINib(nibName: ExpenseCollectionCell.identifier, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: ExpenseCollectionCell.identifier)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpenseCollectionCell.identifier, for: indexPath)

        guard let expenseCell = cell as? ExpenseCollectionCell else { return cell }

        expenseCell.backgroundColor = UIColor.white
        expenseCell.configure(with: viewModel.cellViewModel(for: indexPath))
        return expenseCell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let layout = collectionViewLayout as? UltravisualLayout else { return }
        let offset = layout.dragOffset * CGFloat(indexPath.item)
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(
                CGPoint(x: 0, y: offset), animated: true
            )
        }
    }
}
