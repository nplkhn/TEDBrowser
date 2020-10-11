//
//  ViewController.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 8/20/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    private var homeVC: VideosTableViewController = VideosTableViewController()
    private var favouritesVC: VideosTableViewController = VideosTableViewController()
    private var videoManager = VideoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        VideoManager.fetchVideos(allVideosCompletionHandler: { (videos) in
            self.homeVC.videos = videos
        }, favouriteVideosCompletionHandler: { (videos) in
            self.favouritesVC.videos = videos
        })
        
        setupViewControllers()
        
        
        self.viewControllers = [homeVC, favouritesVC]
    }
    
    private func setupViewControllers() {
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        homeVC.navigationTitle = "Все видео"
        
        favouritesVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        favouritesVC.navigationTitle = "Понравившиеся"
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

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print(text)
    }
    
    
}
