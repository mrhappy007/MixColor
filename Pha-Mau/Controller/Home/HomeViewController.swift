//
//  ViewController.swift
//  Pha-Mau
//
//  Created by Hieu Nghia on 3/21/19.
//  Copyright © 2019 Hieu Nghia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var reviewColorView: UIView!

    @IBOutlet weak var colorsSegmented: UISegmentedControl!
    @IBOutlet weak var cameraButton: UIButton!

    @IBOutlet weak var tenMauTextField: UITextField!
    @IBOutlet weak var maMauTextfield: UITextField!

    @IBOutlet weak var phaMauButton: UIButton!
    @IBOutlet weak var lichSuMauDaPhaButton: UIButton!
    @IBOutlet weak var danhSachPhaMauButton: UIButton!

    var mainColor = UIColor.lightGray

    var pageColorViewController: PageColorViewController? {
        didSet {
            pageColorViewController?.pageColorDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageColorViewController = segue.destination as? PageColorViewController {
            self.pageColorViewController = pageColorViewController
        }
    }

    @IBAction func switchColorViewAction(_ sender: UISegmentedControl) {
        switchColorView(index: sender.selectedSegmentIndex)
        pageColorViewController?.whichToPage(index: sender.selectedSegmentIndex)
    }

    func switchColorView(index: Int) {
        let images = [#imageLiteral(resourceName: "RGB"), #imageLiteral(resourceName: "CMYK"), #imageLiteral(resourceName: "HSV")]
        let imagesBW = [#imageLiteral(resourceName: "RGBB&W"), #imageLiteral(resourceName: "CMYKB&W"), #imageLiteral(resourceName: "HSVB&W")]
        for index in 0...2 {
            colorsSegmented.setImage(imagesBW[index], forSegmentAt: index)
        }
        colorsSegmented.setImage(images[index], forSegmentAt: index)
    }

    func reviewColor(color: UIColor) {
        reviewColorView.backgroundColor = color
    }

    func updateUI() {
    }
}

extension HomeViewController: PageColorViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, index: Int) {
        switchColorView(index: index)
    }
}
