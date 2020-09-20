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
    
    private var homeVC: HomeViewController = HomeViewController()
    private var favouritesVC: FavouritesViewController = FavouritesViewController()
    private var videoManager: VideoManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        
        
        videoManager = VideoManager({ (videos) in
            self.homeVC.videos = videos
        }, { (videos) in
            self.favouritesVC.videos = videos
        })
        self.homeVC.cache = VideoManager.cache
        
        setupViewControllers()
        
        self.viewControllers = [homeVC, favouritesVC]
        
    }
    
    private func setupViewControllers() {
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        favouritesVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
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
