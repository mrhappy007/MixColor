//
//  PageColorViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 4/1/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class PageColorViewController: UIPageViewController {

    weak var pageColorDelegate: PageColorViewControllerDelegate?

    lazy var pagesViewController: [UIViewController] = {
        return [
            self.orderPageView(indentifier: "RGBPage"),
            self.orderPageView(indentifier: "CMYKPage"),
            self.orderPageView(indentifier: "HSVPage"),
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self

        guard let initialPage = pagesViewController.first else {
            return
        }
        whichToPage(pageView: initialPage)
        pageColorDelegate?.pageViewController(pageViewController: self, index: 0)
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
        notifyPageViewDelegateChangeIndex()
    }

    func notifyPageViewDelegateChangeIndex() {
        guard let fistPage = viewControllers?.first,
            let currentIndex = pagesViewController.firstIndex(of: fistPage) else {
            return
        }
        pageColorDelegate?.pageViewController(pageViewController: self, index: currentIndex)
    }
}

extension PageColorViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pagesViewController.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = currentIndex - 1
        if previousIndex < 0 {
            return pagesViewController.last
        }
        return pagesViewController[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pagesViewController.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = currentIndex + 1
        if nextIndex >= pagesViewController.count {
            return pagesViewController.first
        }
        return pagesViewController[nextIndex]
    }
}

extension PageColorViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        notifyPageViewDelegateChangeIndex()
    }
}

protocol PageColorViewControllerDelegate: class {
    func pageViewController(pageViewController: UIPageViewController, index: Int)
}
