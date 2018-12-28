//
//  DashboardViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/18/18.
//  Copyright © 2018 Harry Nelken. All rights reserved.
//

import UIKit


final class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var expenseTableView: UITableView!

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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.reloadData()
        print(viewModel.numberOfRows)
        expenseTableView.reloadSections([0], with: .automatic)
    }

    // MARK: - Setup

    private func setup() {
        let cellNib = UINib(nibName: DashboardExpenseCell.identifier, bundle: nil)
        expenseTableView.register(cellNib, forCellReuseIdentifier: DashboardExpenseCell.identifier)
        expenseTableView.tableFooterView = UIView()
    }

    // MARK: - Actions

    @IBAction func addButtonPressed(_ sender: Any) {
        viewModel.addButtonPressed()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        viewModel.backButtonPressed()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardExpenseCell.identifier, for: indexPath)
        if let expenseCell = cell as? DashboardExpenseCell {
            expenseCell.configure(for: viewModel.cellViewModel(for: indexPath))
            return expenseCell
        } else {
            return cell
        }
    }
}
