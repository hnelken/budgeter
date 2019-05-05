//
//  CommonTableViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 5/1/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

// MARK: - Protocols

protocol BasicTableViewCell: UITableViewCell {
    static var cellIdentifier: String { get }
    func configure(with viewModel: BasicTableViewCellViewModel)
}

protocol BasicTableViewCellViewModel {
    var name: String { get }
}

protocol BasicTableViewModel: AnyObject {
    var cellClass: BasicTableViewCell.Type { get }
    var numberOfSections: Int { get }

    func numberOfRows(in section: Int) -> Int
    func cellViewModel(for indexPath: IndexPath) -> BasicTableViewCellViewModel
}

// MARK: - Class

class BasicTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let nibIdentifier = String(describing: BasicTableViewController.self)
    private let viewModel: BasicTableViewModel

    init(viewModel: BasicTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibIdentifier, bundle: Bundle(for: BasicTableViewController.self))
        setupTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.register(viewModel.cellClass, forCellReuseIdentifier: viewModel.cellClass.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension BasicTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = viewModel.cellClass.cellIdentifier
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        )
        guard let typedCell = cell as? BasicTableViewCell else {
            return cell
        }
        typedCell.configure(with: viewModel.cellViewModel(for: indexPath))
        return typedCell
    }
}

extension BasicTableViewController: UITableViewDelegate { }
