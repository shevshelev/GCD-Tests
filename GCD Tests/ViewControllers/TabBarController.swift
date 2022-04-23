//
//  TabBarController.swift
//  GCD Tests
//
//  Created by Shevshelev Lev on 23.04.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let imageVC = ImageViewController()
    private let primesNumberVC = PrimesNumberViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC(VC: imageVC, title: "Image", imageName: "photo")
        setupVC(VC: primesNumberVC, title: "Primes Number", imageName: "123.rectangle")
        setViewControllers([imageVC, primesNumberVC], animated: false)
    }
    
    private func setupVC(VC: UIViewController, title: String, imageName: String) {
        VC.tabBarItem.title = title
        VC.tabBarItem.image = UIImage(systemName: imageName)
    }

}
