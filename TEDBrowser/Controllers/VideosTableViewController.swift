//
//  VideosTableViewController.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 10/12/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import UIKit

class VideosTableViewController: UITableViewController {
    
    private let cellID = "TEDVideoCell"
    var videos = [TEDVideo]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var navigationTitle: String?
    
    private var searchController: UISearchController!
    private var searchResultController: SearchResultViewController!

    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .black
        tableView.register(UINib(nibName: "TEDVideoTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        tableView.rowHeight = 90
        
        searchResultController = SearchResultViewController()
        searchController = UISearchController(searchResultsController: searchResultController)
        searchController?.searchBar.barStyle = .black
        searchController.searchResultsUpdater = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let navigationTitle = navigationTitle {
            parent?.navigationItem.title = navigationTitle
        }
        
        if let searchController = searchController {
            parent?.navigationItem.searchController = searchController
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TEDVideoTableViewCell
        let video = videos[indexPath.row]
        
        cell.setup(with: video)
        
        if let cachedImageData = VideoManager.cache.object(forKey: video.title.hashValue as NSNumber) {
            cell.thumbnail = UIImage(data: cachedImageData as Data)
        } else {
            cell.thumbnail = UIImage(systemName: "video")
            VideoManager.fetchThumbnail(for: video) { (image) in
                DispatchQueue.main.async {
                    cell.thumbnail = image
                }
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let descriptionVC = DescriptionViewController()
        descriptionVC.video = videos[indexPath.row]
        self.present(descriptionVC, animated: true) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

extension VideosTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchResultController.searchResult = videos.filter({ (video) -> Bool in
            guard let text = searchController.searchBar.text else { return true}
            
            return video.title.contains(text) || video.author.contains(text)
        })
    }
    
    
}
