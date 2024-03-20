//
//  MainTabBarController.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [setUpCardCollectionVC(), setUpCardEdittingVC()]
        tabBar.barTintColor = .systemBackground
    }

    private func setUpCardEdittingVC() -> UINavigationController {
        let cardEdittingVC = CardEdittingVC()
        cardEdittingVC.tabBarItem = UITabBarItem(title: "New Card", image: UIImage(systemName: "rectangle.portrait.badge.plus"), selectedImage: nil)
        let navVC = UINavigationController(rootViewController: cardEdittingVC)
        navVC.navigationBar.prefersLargeTitles = true
        return navVC
    }

    private func setUpCardCollectionVC() -> UINavigationController {
        let cardCollectionVC = CardCollectionVC()
        cardCollectionVC.tabBarItem = UITabBarItem(title: "Collection", image: UIImage(systemName: "rectangle.on.rectangle.angled")
, selectedImage: nil)
        let navVC = UINavigationController(rootViewController: cardCollectionVC)
        navVC.navigationBar.prefersLargeTitles = true
        return navVC
    }
}
