//
//  ViewController.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 8/20/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UITabBarController {
    
    private var homeVC: HomeViewController {
        let homeVC = HomeViewController()
        let tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        homeVC.tabBarItem = tabBarItem
        return homeVC
    }
    
    private var favouritesVC: FavouritesViewController {
        let favouritesVC = FavouritesViewController()
        let tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        favouritesVC.tabBarItem = tabBarItem
        return favouritesVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        self.viewControllers = [homeVC, favouritesVC]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tabBar.barTintColor = .black
        tabBar.tintColor = .lightGray
        
    }
}
