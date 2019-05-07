//
//  HamburgerMenuViewController.swift
//  Budgeter
//
//  Created by Harry Nelken on 3/10/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

final class HamburgerMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let viewModel: HamburgerMenuViewModel
    init(viewModel: HamburgerMenuViewModel) {
        self.viewModel = viewModel
        super.init(
            nibName: "HamburgerMenuViewController",
            bundle: Bundle(for: HamburgerMenuViewController.self)
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setupTableView()
    }

    private func setupTableView() {
        let cellNib = UINib(nibName: HamburgerMenuTableViewCell.identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: HamburgerMenuTableViewCell.identifier)
    }
}

extension HamburgerMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: HamburgerMenuTableViewCell.identifier, for: indexPath)
        guard let menuCell = cell as? HamburgerMenuTableViewCell else { return cell }
        menuCell.configure(with: viewModel.cellViewModel(for: indexPath))
        return menuCell
    }
}

extension HamburgerMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HamburgerMenuTableViewCell.height
    }
}
