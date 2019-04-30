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
    var mainColor = UIColor(hex: 0x009354)

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

        guard let rgbPage = pagesViewController[0] as? RGBPage else {
            return
        }
        rgbPage.rgbPageDelegate = self

        guard let cmykPage = pagesViewController[1] as? CMYKPage else {
            return
        }
        cmykPage.cmykPageDelegate = self

        guard let hsvPage = pagesViewController[2] as? HSVPage else {
            return
        }
        hsvPage.hsvPageDelegate = self
    }

    private func orderPageView(indentifier: String) -> UIViewController {
        return storyboard?.instantiateViewController(withIdentifier: indentifier) ?? UIViewController()
    }

    func whichToPage(index newIndex: Int, updateColor color: UIColor) {
        mainColor = color

        guard let fistPage = viewControllers?.first,
            let currentIndex = pagesViewController.firstIndex(of: fistPage) else {
                return
        }
        let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
        let nextPage = pagesViewController[newIndex]

        whichToPage(pageView: nextPage, direction: direction)
    }

    private func whichToPage(pageView: UIViewController, direction: UIPageViewController.NavigationDirection = .forward) {

        setViewControllers([pageView], direction: direction, animated: true)

        setupUISubPage(pageView: pageView)
    }

    func setupUISubPage(pageView: UIViewController) {
        if let rgbPage = pageView as? RGBPage {
            rgbPage.setupUI(color: mainColor)
            return
        }

        if let cmykPage = pageView as? CMYKPage {
            cmykPage.setupUI(color: mainColor)
            return
        }

        if let hsvPage = pageView as? HSVPage {
            hsvPage.setupUI(color: mainColor)
            return
        }
    }

    func mainColorUpdate(color: UIColor) {
        mainColor = color

        guard let fistPage = viewControllers?.first,
            let currentIndex = pagesViewController.firstIndex(of: fistPage) else {
                return
        }
        setupUISubPage(pageView: pagesViewController[currentIndex])
    }
}

extension ColorPageViewController: RGBPageDelegate {
    func sliderAction(rgbPage: UIViewController, rgbValue: (red: Int, green: Int, blue: Int)) {

        let red = CGFloat(rgbValue.red) / 255.0
        let green = CGFloat(rgbValue.green) / 255.0
        let blue = CGFloat(rgbValue.blue) / 255.0

        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)

        pageColorDelegate?.sliderAction(pageViewController: self, color: color)
    }
}

extension ColorPageViewController: CMYKPageDelegate {
    func sliderAction(cmykPage: UIViewController, cmykValue: (cyan: Int, magenta: Int, yellow: Int, black: Int)) {

        let cyan = Float(cmykValue.cyan) / 100.0
        let magenta = Float(cmykValue.magenta) / 100.0
        let yellow = Float(cmykValue.yellow) / 100.0
        let black = Float(cmykValue.black) / 100.0

        pageColorDelegate?.sliderAction(pageViewController: self, color: UIColor( cyan: cyan, magenta: magenta, yellow: yellow, black: black))
    }
}

extension ColorPageViewController: HSVPageDelegate {
    func sliderAction(hsvPage: UIViewController, hsvValue: (hue: Int, saturation: Int, brightness: Int)) {
        let hue = CGFloat(hsvValue.hue) / 359.0
        let saturation = CGFloat(hsvValue.saturation) / 100.0
        let brightness = CGFloat(hsvValue.brightness) / 100.0

        pageColorDelegate?.sliderAction(pageViewController: self, color: UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0))
    }
}

protocol ColorPageViewControllerDelegate: class {
    func sliderAction(pageViewController: UIPageViewController, color: UIColor)
}
