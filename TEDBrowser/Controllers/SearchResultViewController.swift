//
//  SearchResultViewController.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 10/11/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import UIKit

class SearchResultViewController: UITableViewController {
    
    var searchResult: [TEDVideo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let cellID = "TEDVideoCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .black
        tableView.register(UINib(nibName: "TEDVideoTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        tableView.rowHeight = 90
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let descriptionVC = DescriptionViewController()
        descriptionVC.video = searchResult[indexPath.row]
        self.present(descriptionVC, animated: true) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResult.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TEDVideoTableViewCell
        let result = searchResult[indexPath.row]
        
        cell.setup(with: result)
        
        if let cachedImageData = VideoManager.cache.object(forKey: result.title.hashValue as NSNumber) {
            cell.thumbnail = UIImage(data: cachedImageData as Data)
        } else {
            cell.thumbnail = UIImage(systemName: "video")
            VideoManager.fetchThumbnail(for: result) { (image) in
                DispatchQueue.main.async {
                    cell.thumbnail = image
                }
            }
        }

        return cell
    }

}
