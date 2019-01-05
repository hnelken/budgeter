//
//  DashboardExpenseCollectionCell.swift
//  Budgeter
//
//  Created by Harry Nelken on 1/4/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

class DashboardExpenseCollectionCell: UICollectionViewCell {

    static let identifier = "DashboardExpenseCollectionCell"

    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    func configure(for viewModel: DashboardExpenseCellViewModel) {
        nameLabel.attributedText = viewModel.nameLabelAttributedText
        amountLabel.attributedText = viewModel.amountLabelAttributedText
        dateLabel.attributedText = viewModel.dateLabelAttributedText
    }

    // Adapted from:
    // https://www.raywenderlich.com/7246-expanding-cells-in-ios-collection-views
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight

        let delta = 1 - (
            (featuredHeight - frame.height) / (featuredHeight - standardHeight)
        )

        let minAlpha: CGFloat = 0.1
        let maxAlpha: CGFloat = 0.45
        coverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))

        let scale = max(delta, 0.5)
        let newTransform: CGAffineTransform =
            scale == 1
                ? .identity
                : CGAffineTransform(scaleX: scale, y: scale)
        nameLabel.transform = newTransform
        amountLabel.transform = newTransform
        dateLabel.transform = newTransform

        amountLabel.alpha = delta
        dateLabel.alpha = delta
    }
}
