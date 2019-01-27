//
//  CarouselView.swift
//  Budgeter
//
//  Created by Harry Nelken on 1/26/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit

class CarouselView: UIView {

    @IBOutlet var carouselSubviews: [UIView]!
    private var currentIndex = 0

    // MARK: - Transform constants

    private var leftTransform: CGAffineTransform {
        return CGAffineTransform(translationX: -2 * bounds.width, y: 0)
    }

    private var rightTransform: CGAffineTransform {
        return CGAffineTransform(translationX: 2 * bounds.width, y: 0)
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
            currentIndex < carouselSubviews.count
            else { return }

        let oldCenterView = carouselSubviews[currentIndex]

        let newCenterView: UIView
        if currentIndex == carouselSubviews.count - 1 {
            currentIndex = 0
            newCenterView = carouselSubviews[currentIndex]
        } else {
            currentIndex += 1
            newCenterView = carouselSubviews[currentIndex]
        }

        newCenterView.transform = rightTransform
        UIView.animate(withDuration: 0.25) {
            oldCenterView.transform = self.leftTransform
            newCenterView.transform = .identity
        }
    }

    func previousPage() {
        guard currentIndex < carouselSubviews.count else { return }
        let oldCenterView = carouselSubviews[currentIndex]

        let newCenterView: UIView
        if currentIndex == 0 {
            currentIndex = carouselSubviews.count - 1
            newCenterView = carouselSubviews[currentIndex]
        } else {
            currentIndex -= 1
            newCenterView = carouselSubviews[currentIndex]
        }

        newCenterView.transform = leftTransform
        UIView.animate(withDuration: 0.25) {
            oldCenterView.transform = self.rightTransform
            newCenterView.transform = .identity
        }
    }
}
