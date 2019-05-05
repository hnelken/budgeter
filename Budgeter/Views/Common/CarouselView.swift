//
//  CarouselView.swift
//  Budgeter
//
//  Created by Harry Nelken on 1/26/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

class CarouselView: UIView {

    private var carouselSubviews = [UIView]()
    private(set) var currentIndex = 0

    // MARK: - Transform Constants

    private var leftTransform: CGAffineTransform {
        return CGAffineTransform(translationX: -2 * bounds.width, y: 0)
    }

    private var rightTransform: CGAffineTransform {
        return CGAffineTransform(translationX: 2 * bounds.width, y: 0)
    }

    // MARK: - Data Source

    func addCarouselView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutAttachAll()
        view.transform = rightTransform
        carouselSubviews.append(view)
        setNeedsLayout()
    }

    // MARK: - Paging

    func resetToFirstPage() {
        guard carouselSubviews.count > 1 else { return }
        for i in carouselSubviews.startIndex ..< carouselSubviews.endIndex {
            if i == carouselSubviews.startIndex {
                carouselSubviews[i].transform = .identity
            } else {
                carouselSubviews[i].transform = rightTransform
            }
        }
    }

    func nextPage() {
        guard
            carouselSubviews.count > 1,
            let oldCenterView = carouselSubviews[safely: currentIndex]
            else { return }
        currentIndex = carouselSubviews.wrappedIndex(after: currentIndex)
        let newCenterView = carouselSubviews[currentIndex]
        newCenterView.transform = rightTransform
        UIView.animate(withDuration: 0.25) {
            oldCenterView.transform = self.leftTransform
            newCenterView.transform = .identity
        }
    }

    func previousPage() {
        guard
            carouselSubviews.count > 1,
            let oldCenterView = carouselSubviews[safely: currentIndex]
            else { return }
        currentIndex = carouselSubviews.wrappedIndex(before: currentIndex)
        let newCenterView = carouselSubviews[currentIndex]
        newCenterView.transform = leftTransform
        UIView.animate(withDuration: 0.25) {
            oldCenterView.transform = self.rightTransform
            newCenterView.transform = .identity
        }
    }
}
