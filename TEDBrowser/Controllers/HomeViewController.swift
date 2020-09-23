//
//  InfoViewController.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 8/20/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController, XMLParserDelegate {
    var videos: [TEDVideo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityView.stopAnimating()
            }
        }
    }
    
    private let activityView: UIActivityIndicatorView = UIActivityIndicatorView()
    private var searchController: UISearchController?
    private var searchResult = [TEDVideo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.parent?.view.addSubview(activityView)
        
        // defining search controller
        searchController = UISearchController(searchResultsController: self)
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.barStyle = .black
        searchController?.automaticallyShowsCancelButton = true
        searchController?.searchResultsUpdater = self
        
        
        
        
        activityView.center = (self.parent?.view.center)!
        activityView.color = .white
        activityView.startAnimating()
        
        tableView.register(UINib(nibName: "TEDVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "TEDVideoCell")
        tableView.rowHeight = 90
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = "Все видео"
        self.parent?.navigationItem.searchController = searchController
//        self.parent?.navigationItem.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        activityView.center = (self.parent?.view.center)!
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let descriptionVC = DescriptionViewController()
        descriptionVC.video = videos[indexPath.row]
        self.present(descriptionVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TEDVideoCell", for: indexPath) as! TEDVideoTableViewCell
        let video = videos[indexPath.row]
        
        cell.duration = video.duration!
        cell.author = video.author!
        cell.title = video.title!
        
        if let cachedImage = VideoManager.cache.object(forKey: video.videoID! as NSString) {
            cell.thumbnail = cachedImage
        } else {
            VideoManager.fetchAndCacheThumbnailImage(for: video) { (image) in
                DispatchQueue.main.async {
                    cell.thumbnail = image
                }
            }
        }
        
        return cell
    }
    
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //        // Update the filtered array based on the search text.
        //        let searchResults = self.videos
        //
        //        // Strip out all the leading and trailing spaces.
        //        let whitespaceCharacterSet = CharacterSet.whitespaces
        //        let strippedString =
        //            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        //        let searchItems = strippedString.components(separatedBy: " ") as [String]
        //
        ////         Build all the "AND" expressions for each value in searchString.
        //        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
        //            findMatches(searchString: searchString)
        //        }
        //
        ////         Match up the fields of the Product object.
        //        let finalCompoundPredicate =
        //            NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        //
        //        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }
        //
        ////         Apply the filtered results to the search results table.
        //        if let resultsController = searchController.searchResultsController as? HomeViewController {
        //            resultsController.videos = filteredResults
        //            resultsController.tableView.reloadData()
        //
        //        }
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    private func filterContentForSearchText(_ searchText: String) {
        searchResult = videos.filter({ (video: TEDVideo) -> Bool in
            return (video.title?.lowercased().contains(searchText.lowercased()))!// || (video.author?.contains(searchText.lowercased()))!
        })
        
        tableView.reloadData()
    }
}
