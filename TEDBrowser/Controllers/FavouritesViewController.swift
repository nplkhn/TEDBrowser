//
//  FavouritesViewCellTableViewController.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 9/12/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import UIKit

class FavouritesViewController: UITableViewController {
    
    let cellID = "TEDVideoCell"
    
    var videos: [TEDVideo] = [] {
        didSet {
            videos.sort { (left, right) -> Bool in
                left.title < right.title
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TEDVideoTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        tableView.rowHeight = 90
        self.view.backgroundColor = .black
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = "Понравившиеся"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let descriptionVC = DescriptionViewController()
        descriptionVC.video = videos[indexPath.row]
        self.present(descriptionVC, animated: true, completion: nil)
    }
    
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
}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

