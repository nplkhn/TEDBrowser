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
        
        self.viewControllers = [infoVC]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchController.automaticallyShowsCancelButton = true
        
        navigationItem.title = "Все видео"
        navigationItem.searchController = searchController
    }


}

