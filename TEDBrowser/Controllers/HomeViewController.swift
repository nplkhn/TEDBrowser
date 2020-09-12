//
//  InfoViewController.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 8/20/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController, XMLParserDelegate {
    var videos: [TEDVideoModel] = []
    
    let activityView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.parent?.view.addSubview(activityView)
        activityView.center = (self.parent?.view.center)!
        activityView.color = .white
        activityView.startAnimating()
        
        tableView.register(UINib(nibName: "TEDVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "TEDVideoTableViewCell")
        tableView.rowHeight = 90
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.parent?.navigationItem.title = "Все видео"
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        activityView.center = (self.parent?.view.center)!
    }
    
    func fetchData() {
        let parser = FeedParser()
        
        parser.parseFeed(url: "https://www.ted.com/themes/rss/id") { videos in
            self.videos = videos
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityView.stopAnimating()
            }
            
            
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TEDVideoTableViewCell", for: indexPath) as! TEDVideoTableViewCell
        
        cell.duration.text = videos[indexPath.row].duration
        cell.authorName.text = videos[indexPath.row].author
        cell.videoTitle.text = videos[indexPath.row].title
        
        cell.thumbnailImage.image = UIImage(systemName: "video")
        if let thumbnail = videos[indexPath.row].thumbnailURL,
            let thumbnailURL = URL(string: thumbnail) {
            let thumbnailDataTask = URLSession.shared.dataTask(with: thumbnailURL) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let thumbnailData = data {
                    DispatchQueue.main.async {
                        cell.thumbnailImage.image = UIImage(data: thumbnailData)
                    }
                }
            }
            thumbnailDataTask.resume()
        }

        
        // Configure the cell...
        
        return cell
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
    
}
