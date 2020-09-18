//
//  VideoManager.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 9/18/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class VideoManager {
    
    var favouriteVideos: [NSManagedObject] = []
    var allVideos: [TEDVideo] = [] {
        didSet {
            checkForFavourites()
        }
    }
    let cache = NSCache<NSString, UIImage>()
    
    private func fetchFavourites() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TEDVideo")
        
        do {
            self.favouriteVideos = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetchAllVideos() {
        let parser = FeedParser()
        parser.parseFeed(url: "https://www.ted.com/themes/rss/id") { (allVideos) in
            self.allVideos = allVideos
            self.fetchAndCacheThumbnailImages()
        }
    }
    
    func fetchAndCacheThumbnailImages() {
        for video in allVideos {
            let session = URLSession.shared
            session.dataTask(with: URL(string: video.thumbnailURL!)!) { (imageData, _, error) in
                if let imageData = imageData {
                    guard error != nil else {
                        print("Error while fetching thumbnail image")
                        return
                    }
                    self.cache.setObject(UIImage(data: imageData)!, forKey: NSString(string: video.videoID!))
                }
            }
        }
    }
    
    func fetchAndCacheThumbnailImage(for video: TEDVideo) {
        let session = URLSession.shared
        session.dataTask(with: URL(string: video.thumbnailURL!)!) { (imageData, _, error) in
            if let imageData = imageData {
                guard error != nil else {
                    print("Error while fetching thumbnail image")
                    return
                }
                self.cache.setObject(UIImage(data: imageData)!, forKey: NSString(string: video.videoID!))
            }
        }
    }
    
    init(_ completionHandler: (_ allVideos: [TEDVideo], _ favouriteVideos: [NSManagedObject]) -> Void) {
        fetchAllVideos()
        fetchFavourites()
        completionHandler(allVideos, favouriteVideos)
    }
    
    func checkForFavourites() {
        for idx in 0...allVideos.count {
            if favouriteVideos.contains(where: { (video) -> Bool in
                return ((video.value(forKey: "videoID") as? String) == allVideos[idx].videoID)
            }) {
                allVideos[idx].isFavourite = true
            }
        }
    }
}
