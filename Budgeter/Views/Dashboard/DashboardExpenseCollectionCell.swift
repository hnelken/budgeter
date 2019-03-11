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
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTitleLabel: UILabel!

    func configure(with viewModel: DashboardExpenseCellViewModel) {
        nameLabel.attributedText = viewModel.nameLabelAttributedText
        amountLabel.attributedText = viewModel.amountLabelAttributedText
        paymentMethodLabel.attributedText = viewModel.amountLabelAttributedText
        dateLabel.attributedText = viewModel.dateLabelAttributedText
        commentLabel.attributedText = viewModel.commentLabelAttributedText
    }

    // Adapted from:
    // https://www.raywenderlich.com/7246-expanding-cells-in-ios-collection-views
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        let standardHeight =  UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        let minimumScaleFactor = UltravisualLayoutConstants.Cell.minimumScaleFactor
        let delta = 1 - (
            (featuredHeight - frame.height) / (featuredHeight - standardHeight)
        )

        let minAlpha: CGFloat = 0.1
        let maxAlpha: CGFloat = 0.45
        coverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))

        let scale = max(delta, minimumScaleFactor)
        let newTransform: CGAffineTransform =
            scale == 1
                ? .identity
                : CGAffineTransform(scaleX: scale, y: scale)

        scaleSubviews(with: newTransform)
        fadeSubviews(withAlpha: delta)
    }

    private func scaleSubviews(with transform: CGAffineTransform) {
        nameLabel.transform = transform
//        commentLabel.transform = transform
//        commentTitleLabel.transform = transform
//        amountLabel.transform = transform
//        dateLabel.transform = transform
    }

    private func fadeSubviews(withAlpha alpha: CGFloat) {
//        amountLabel.alpha = alpha
//        dateLabel.alpha = alpha
        commentLabel.alpha = alpha
        commentTitleLabel.alpha = alpha
    }
}
