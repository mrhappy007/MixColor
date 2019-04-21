//
//  PageColorViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/1/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class ColorPageViewController: UIPageViewController {

    weak var pageColorDelegate: ColorPageViewControllerDelegate?
    var mainColor = UIColor()

    var rgbPage: RGBPage? {
        didSet {
            rgbPage?.rgbPageDelegate = self
        }
    }

    lazy var pagesViewController: [UIViewController] = {
        return [
            self.orderPageView(indentifier: "RGBPage"),
            self.orderPageView(indentifier: "CMYKPage"),
            self.orderPageView(indentifier: "HSVPage"),
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let initialPage = pagesViewController.first else {
            return
        }
        whichToPage(pageView: initialPage)
    }

    private func orderPageView(indentifier: String) -> UIViewController {
        return storyboard?.instantiateViewController(withIdentifier: indentifier) ?? UIViewController()
    }

    func whichToPage(index newIndex: Int) {
        guard let fistPage = viewControllers?.first,
            let currentIndex = pagesViewController.firstIndex(of: fistPage) else {
                return
        }
        let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
        let nextPage = pagesViewController[newIndex]

        whichToPage(pageView: nextPage, direction: direction)
    }

    func whichToPage(pageView: UIViewController, direction: UIPageViewController.NavigationDirection = .forward) {
        setViewControllers([pageView], direction: direction, animated: true)
    }
}

extension ColorPageViewController: RGBPageDelegate {
    func rgbSliderAction(rgbPage: UIViewController, rgbValue: (red: Int, green: Int, blue: Int)) {

        let red = CGFloat(rgbValue.red)
        let green = CGFloat(rgbValue.green)
        let blue = CGFloat(rgbValue.blue)

        pageColorDelegate?.sliderAction(pageViewController: self, color: UIColor(displayP3Red: red, green: green, blue: blue, alpha: 1.0))

        print("---------")
    }
}

protocol ColorPageViewControllerDelegate: class {
    func sliderAction(pageViewController: UIPageViewController, color: UIColor)
}
