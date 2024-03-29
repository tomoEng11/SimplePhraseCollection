//
//  MainTabBarController.swift
//  SimplePharaseCollection
//
//  Created by 井本智博 on 2024/03/19.
//

import UIKit

class MainTabBarController: UITabBarController {

    lazy var newCardVC: UINavigationController = {
        let newCardVC = NewCardVC()
        newCardVC.tabBarItem = UITabBarItem(title: "New Card", image: UIImage(systemName: "rectangle.portrait.badge.plus"), selectedImage: nil)
        let navVC = UINavigationController(rootViewController: newCardVC)
        navVC.navigationBar.prefersLargeTitles = true
        return navVC
    }()
    lazy var cardCollectionVC: UINavigationController = {
        let cardCollectionVC = CardCollectionVC()
        cardCollectionVC.tabBarItem = UITabBarItem(
            title: "Collection",
            image: UIImage(systemName: "rectangle.on.rectangle.angled"),
            selectedImage: nil)
        let navVC = UINavigationController(rootViewController: cardCollectionVC)
        navVC.navigationBar.prefersLargeTitles = true
        return navVC
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [cardCollectionVC, newCardVC]
        tabBar.barTintColor = .systemBackground
    }
}
