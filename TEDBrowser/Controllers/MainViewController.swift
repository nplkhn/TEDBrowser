//
//  ViewController.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 8/20/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    let infoVC: InfoViewController = InfoViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        infoVC.tabBarItem = tabBarItem
        
        self.viewControllers = [infoVC]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tabBar.barTintColor = .black
        tabBar.tintColor = .lightGray
        
        
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchController.automaticallyShowsCancelButton = true
        navigationItem.searchController = searchController
        
        navigationItem.title = "Все видео"
        
        
    }


}

