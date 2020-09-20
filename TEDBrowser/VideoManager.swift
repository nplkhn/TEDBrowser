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
    
    var favouriteVideos: [NSManagedObject] = [] {
        didSet {
            self.favouriteVideosCompletionHandler?(favouriteVideos)
        }
    }
    var allVideos: [TEDVideo] = [] {
        didSet {
            checkForFavourites()
        }
    }
    let cache = NSCache<NSString, UIImage>()
    
    var allVideosCompletionHandler: (([TEDVideo]) -> Void)?
    var favouriteVideosCompletionHandler: (([NSManagedObject]) -> Void)?
    
    init(_ allVideosCompletionHandler: @escaping ([TEDVideo]) -> Void, _ favouriteVideosCompletionHandler: @escaping ([NSManagedObject]) -> Void) {
        fetchFavourites()
        fetchAllVideos()
        
        
        self.allVideosCompletionHandler = allVideosCompletionHandler
        self.favouriteVideosCompletionHandler = favouriteVideosCompletionHandler
    }
    
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
        DispatchQueue.global(qos: .userInteractive).async {
            for video in self.allVideos {
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
            self.allVideosCompletionHandler!(self.allVideos)
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
